import { promptAction, router } from '@kit.ArkUI'
import { Request } from '../utils/Request'
import { LoginRequestTypeInfo, RegistryParamsType, sendMessageRequestType } from './accountType'
import { Department, DepartmentRequestType } from './Data'
import { NavBar } from './NavBar'

class selectListType {
  value: string = ''

  constructor(value: string) {
    this.value = value
  }
}

@Entry
@Component
struct Registry {
  @State formData: RegistryParamsType = {
    username: '',
    nickname: '',
    password: '',
    phoneNumber: '',
    deptId: 0
  }
  @State list: selectListType[] = [
    new selectListType('教研院'),
    new selectListType('技术部'),
    new selectListType('神龙教'),
  ]
  @State text: string = "请选择" //*
  @State index: number = 0
  @State Lock: boolean = true
  @State department: Department[] = [];

  private async getData() {
    //获取部门列表
    const result = await Request.get<DepartmentRequestType>("/api/system/dept/list")
    console.log('data' + JSON.stringify(result.data))
    this.department = result.data;
    if (result.code === 0) {
      this.list = result.data.map(item => new selectListType(item.deptName))
    }
  }

  onPageShow(): void {
    this.getData();
  }

  // 校验表单
  private checkForm(): boolean {
    if (this.formData.username && this.formData.password && this.formData.phoneNumber && this.formData) {
      return true
    } else {
      return false
    }
  }

  // 注册账号
  async register() {
    const result = await Request.post<RegistryParamsType, sendMessageRequestType>("/api/auth/register", this.formData)
    if (result.code === 0) {
      this.Lock = false
      promptAction.showToast({
        message: '注册成功,正在跳转登录·····',
        duration: 1000
      })
      setTimeout(() => {
        router.back()
      }, 1000)
    } else {
      promptAction.showToast({
        message: result.error,
        duration: 2000
      })
    }
  }

  build() {
    Column() {
      NavBar({ title: '注册' })
      Row() {
        Text("选择所属部门").margin({ left: 10 })
        Select(this.list)
          .selected(this.index)
          .value(this.text)
          .font({ size: 16, weight: 500 })
          .fontColor('#000')
          .selectedOptionFont({ size: 16, weight: 400 })
          .optionFont({ size: 16, weight: 400 })
          .space(8)
          .arrowPosition(ArrowPosition.END)
          .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
          .optionWidth(200)
          .optionHeight(300)
          .backgroundColor('#eaeaea')
          .onSelect((index: number, text?: string | undefined) => {
            this.formData.deptId = this.department[index].deptId;
          })
      }
      .width('100%')
      .backgroundColor('#eaeaea')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 10 })
      .height(60)

      Row() {
        Text("登录账号").fontSize(20)
        TextInput({ placeholder: '请输入登录账号' })
          .borderRadius(0)
          .padding({ left: 20 })
          .backgroundColor("#f5f5f5")
          .onSubmit((EnterKeyType) => {
            console.info(EnterKeyType + '输入法回车键的类型值')
          })
          .fontSize(20)
          .onChange((value: string) => {
            this.formData.username = value
          })
      }.width('100%')
      .border({
        width: { bottom: 2 },
        color: { bottom: '#eaeaea' },
        style: { bottom: BorderStyle.Solid }
      }).padding({ top: 20, bottom: 20, left: 20 })

      //密码
      Row() {
        Text("登录密码").fontSize(20)
        TextInput({ placeholder: '请输入登录密码' })
          .borderRadius(0)
          .padding({ left: 20 })
          .backgroundColor("#f5f5f5")
          .onSubmit((EnterKeyType) => {
            console.info(EnterKeyType + '输入法回车键的类型值')
          })
          .fontSize(20)
          .onChange((value: string) => {
            this.formData.password = value
          })
          .type(InputType.Password)
          .maxLength(16)
      }.width('100%')
      .border({
        width: { bottom: 2 },
        color: { bottom: '#eaeaea' },
        style: { bottom: BorderStyle.Solid }
      }).padding({ top: 20, bottom: 20, left: 20 })

      //手机号
      Row() {
        Text("手机账号").fontSize(20)
        TextInput({ placeholder: '请输入手机账号' })
          .borderRadius(0)
          .padding({ left: 20 })
          .backgroundColor("#f5f5f5")
          .onSubmit((EnterKeyType) => {
            console.info(EnterKeyType + '输入法回车键的类型值')
          })
          .fontSize(20)
          .onChange((value: string) => {
            this.formData.phoneNumber = value
          })
          .type(InputType.PhoneNumber)
          .maxLength(11)
      }.width('100%')
      .border({
        width: { bottom: 2 },
        color: { bottom: '#eaeaea' },
        style: { bottom: BorderStyle.Solid }
      }).padding({ top: 20, bottom: 20, left: 20 })

      // 用户名
      Row() {
        Text("用户昵称").fontSize(20)
        TextInput({ placeholder: '请输入用户昵称' })
          .borderRadius(0)
          .padding({ left: 20 })
          .backgroundColor("#f5f5f5")
          .onSubmit((EnterKeyType) => {
            console.info(EnterKeyType + '输入法回车键的类型值')
          })
          .fontSize(20)
          .onChange((value: string) => {
            this.formData.nickname = value
          })
      }.width('100%')
      .border({
        width: { bottom: 2 },
        color: { bottom: '#eaeaea' },
        style: { bottom: BorderStyle.Solid }
      }).padding({ top: 20, bottom: 20, left: 20 })

      Button('立即注册', { type: ButtonType.Normal })
        .backgroundColor("#484a9c")
        .width('85%')
        .height('8%')
        .margin({ top: 30 })
        .onClick(async (event: ClickEvent) => {
          if (this.Lock) {
            if (this.checkForm()) {
              this.register()
            } else {
              promptAction.showToast({
                message: '有数据输入格式错误',
                duration: 2000
              })
            }
          } else {
            promptAction.showToast({
              message: '别TM点了！',
              duration: 2000
            })
          }
        })
    }.width('100%').height('100%').backgroundColor("#f5f5f5")
  }
}