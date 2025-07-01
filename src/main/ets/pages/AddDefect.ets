import { Request } from '../utils/Request'
import { uploadImage } from '../utils/uploadPictures'
import { sendMessageRequestType } from './accountType'
import { Defect, DefectRequestType, Task, TaskRequestType } from './Data'
import { promptAction, router } from '@kit.ArkUI'
import { NavBar } from './NavBar'

@Entry
@Component
struct AddDefect {
  @State data: Defect = {
    defectId: 0,
    taskId: '',
    defectType: '',
    distanceFromOrigin: '',
    imageUrls: '',
    isVerified: false,
    severity: '',
    defectLength: 0,
    defectArea: 0,
    defectQuantity: 0,
    recommendedAction: '',
    reportedTime: '',
    status: '0'
  }
  //属实数组
  @State type: SelectOption[] = [{ value: '是' }, { value: '否' }]
  @State tasks: SelectOption[] = []
  @State task: Task[] = [];

  private async getData() {
    const userId = AppStorage.get("userId") as number
    Request.get<TaskRequestType>(`/api/inspection/task/user/${userId}?page=${1}&pageSize=${20}`).then((res) => {
      this.task = res.data['items'];
      this.task.forEach((item) => {
        this.tasks.push({ value: item.taskName })
      })
      console.log('task' + JSON.stringify(this.tasks))
    })
  }

  onPageShow(): void {
    this.getData();
  }

  build() {
    Column({ space: 10 }) {
      NavBar({ title: '添加缺陷' })
      Scroll() {
        Column({ space: 10 }) {
          Column({ space: 5 }) {
            Image(this.data.imageUrls == '' ? $r('app.media.tjtp') : this.data.imageUrls)
              .width('100%')
              .height(100)
              .objectFit(ImageFit.Contain)
            Text('添加图片')
          }.width('100%').justifyContent(FlexAlign.Center).onClick(() => {
            uploadImage().then((res) => {
              console.log('res' + res)
              this.data.imageUrls = res;
            })
          })

          //选择任务id
          Text('所属任务').fontSize(16).fontWeight(FontWeight.Bold)
          Select(this.tasks)
            .width('100%')
            .borderRadius(5)
            .value('请选择上所属任务')
            .onSelect((value) => {
              this.data.taskId = this.task[value].taskId;
            })
          //缺陷类型
          Text('缺陷类型').fontSize(16).fontWeight(FontWeight.Bold)
          TextInput({ text: $$this.data.defectType, placeholder: `请输入缺陷类型` })
            .borderRadius(5)
          //缺陷位置
          Text('缺陷位置').fontSize(16).fontWeight(FontWeight.Bold)
          TextInput({ text: $$this.data.distanceFromOrigin, placeholder: `请输入缺陷位置` })
            .borderRadius(5)
          Text('是否属实').fontSize(16).fontWeight(FontWeight.Bold)
          Select(this.type)
            .width('100%')
            .borderRadius(5)
            .value(this.data.isVerified ? '是' : '否')
            .onSelect((value) => {
              this.data.isVerified = value === 0 ? true : false
            })
          //严重长度
          Text('严重长度').fontSize(16).fontWeight(FontWeight.Bold)
          TextInput({ text: $$this.data.defectLength, placeholder: `请输入缺陷长度` })
            .borderRadius(5)
          Text('缺陷面积').fontSize(16).fontWeight(FontWeight.Bold)
          TextInput({ text: $$this.data.defectArea, placeholder: `请输入缺陷面积` })
            .borderRadius(5)
          Text('缺陷数量').fontSize(16).fontWeight(FontWeight.Bold)
          TextInput({ text: $$this.data.defectQuantity, placeholder: `请输入缺陷数量` })
            .borderRadius(5)
          Text('建议操作').fontSize(16).fontWeight(FontWeight.Bold)
          TextInput({ text: $$this.data.recommendedAction, placeholder: `请输入建议操作` })
            .borderRadius(5)
        }.width('100%').alignItems(HorizontalAlign.Start)
      }.width('100%').layoutWeight(1).align(Alignment.TopStart)

      Button('提交')
        .width('100%')
        .borderRadius(5)
        .backgroundColor('#409EFF')
        .fontColor('#fff')
        .fontSize(16)
        .onClick(() => {
          Request.post<Defect, sendMessageRequestType>(`/defect/create`, this.data).then((res) => {
            if (res.code === 0) {
              promptAction.showToast({ message: '添加成功' })
              router.back()
            }
          })
        })
    }
    .padding({ left: 10, right: 10 })
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#f5f5f5')
    .height('100%')
    .width('100%')
  }
}