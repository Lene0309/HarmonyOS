import { common } from '@kit.AbilityKit'
import { picker } from '@kit.CoreFileKit'
import fs from '@ohos.file.fs'
import request from '@ohos.request'
import { BusinessError } from '@kit.BasicServicesKit'
import { RequestType } from '../pages/Data'


/**
 * 上传图片（例如头像上传，多选后可以取第一张或全部上传）
 */

export async function uploadImage(): Promise<string> {
  const context = getContext() as common.UIAbilityContext

  // 1. 选择文件
  const fileResult = await new picker.DocumentViewPicker().select()
  if (!fileResult?.length) {
    throw new Error('未选择文件')
  }
  const sourceUri = fileResult[0]

  // 2. 准备文件
  const fileName = sourceUri.split('/').pop() || `file_${Date.now()}`
  const cacheUri = `${context.cacheDir}/${fileName}`
  const file = await fs.open(sourceUri)
  fs.copyFileSync(file.fd, cacheUri)
  fs.closeSync(file.fd)

  // 3. 执行上传（关键修正部分）
  return new Promise((resolve, reject) => { // 添加 resolve 参数
    const uploadConfig: request.UploadConfig = {
      url: 'http://10.0.2.2:8080/fileUpload/ds',
      header: { 'token': AppStorage.get('token') },
      method: "POST",
      files: [{
        filename: fileName,
        name: 'file',
        uri: `internal://cache/${fileName}`,
        type: fileName.endsWith('.png') ? 'png' : 'jpg' // 动态类型判断
      }],
      data: [],
    };
    request.uploadFile(context, uploadConfig).then((uploadTask) => {
      uploadTask.on("headerReceive", (response) => {
        try {
          const data = JSON.parse(response['body']) as RequestType
          console.log("返回数据：", data.data)
          if (data.data) {
            AppStorage.setOrCreate("avatar", data.data)
            resolve(data.data) // 正确返回结果
          } else {
            reject(new Error('服务器未返回有效地址'))
          }
        } catch (e) {
          reject(new Error('响应解析失败'))
        }
      })
    }).catch((e: BusinessError) => {
      reject(new Error(`请求初始化失败: ${e.message}`))
    })
  })
}
/**
 * 上传帖子图片（支持多图上传）
 */
export async function uploadPostImage(): Promise<string[]> {
  const context = getContext() as common.UIAbilityContext
  // 1. 选择文件（多选）
  const fileResults = await new picker.DocumentViewPicker().select()
  if (!fileResults || fileResults.length === 0) {
    throw new Error('未选择文件')
  }

  // 2. 遍历选择的文件并准备上传
  const uploadPromises = fileResults.map(async (sourceUri) => {
    const fileName = sourceUri.split('/').pop() || `file_${Date.now()}`
    const cacheUri = `${context.cacheDir}/${fileName}`
    const file = await fs.open(sourceUri)
    fs.copyFileSync(file.fd, cacheUri)
    fs.closeSync(file.fd)
    // 3. 执行上传
    return new Promise<string>((resolve, reject) => {
      const uploadConfig: request.UploadConfig = {
        url: 'http://10.0.2.2:8080/fileUpload/post',
        header: { 'token': AppStorage.get('token') },
        method: "POST",
        files: [{
          filename: fileName,
          name: 'file',
          uri: `internal://cache/${fileName}`,
          type: fileName.endsWith('.png') ? 'png' : 'jpg'
        }],
        data: [],
      }
      request.uploadFile(context, uploadConfig).then((uploadTask) => {
        uploadTask.on("headerReceive", (response) => {
          try {
            const data = JSON.parse(response['body']) as RequestType
            if (data.data) {
              resolve(data.data)
            }
          } catch (e) {
            reject(new Error('响应解析失败'))
          }
        })
      }).catch((e: BusinessError) => {
        reject(new Error(`请求初始化失败: ${e.message}`))
      })
    })
  })
  return Promise.all(uploadPromises)
}
