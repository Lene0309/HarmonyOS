import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Task } from './Data';

@Entry
@Component
struct TaskDetailPage {
  @State task: Task = router.getParams() as Task;
  @State showAssignDialog: boolean = false;
  @State selectedExecutorId: number = 0;

  // 格式化日期时间
  private formatDateTime(date: Date | null): string {
    if (!date) {
      return '--';
    }
    return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${date.getMinutes()
      .toString()
      .padStart(2, '0')}`;
  }


  // 标记任务完成
  private completeTask() {
    promptAction.showDialog({
      title: '确认完成',
      message: '确定要标记此任务为已完成吗？',
      buttons: [
        { text: '取消', color: '#999' },
        { text: '确定', color: '#67c23a' }
      ]
    }).then(result => {
      if (result.index === 1) {

        promptAction.showToast({ message: '任务已完成', duration: 2000 });
        router.back();
      }
    });
  }

  build() {
    Column() {
      // 头部信息卡片
      Column({ space: 12 }) {
        Row() {
          Text(this.task.taskName)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333')
            .layoutWeight(1)

          // 状态标签
          Text(this.task.taskName)
            .fontSize(14)
            .fontColor(
              this.task.status === 0 ? '#67c23a' :
                this.task.status === 1 ? '#f56c6c' :
                  this.task.status === 2 ? '#409EFF' : '#e6a23c'
            )
            .padding({
              left: 8,
              right: 8,
              top: 4,
              bottom: 4
            })
            .backgroundColor(
              this.task.status === 0 ? '#f0f9eb' :
                this.task.status === 1 ? '#fef0f0' :
                  this.task.status === 2 ? '#ebf5ff' : '#fdf6ec'
            )
            .borderRadius(4)
        }

        Divider()
          .strokeWidth(1)
          .color('#f0f0f0')

        // 基本信息
        Column({ space: 8 }) {
          Row() {
            Text('任务ID:')
              .fontSize(14)
              .fontColor('#666')
              .width(80)
            Text(this.task.taskId)
              .fontSize(14)
              .fontColor('#333')
              .layoutWeight(1)
          }

          Row() {
            Text('创建者:')
              .fontSize(14)
              .fontColor('#666')
              .width(80)
            Text(`ID: ${this.task.creatorId}`)
              .fontSize(14)
              .fontColor('#333')
              .layoutWeight(1)
          }

          Row() {
            Text('执行者:')
              .fontSize(14)
              .fontColor('#666')
              .width(80)
            Text(this.task.executorId ? `ID: ${this.task.executorId}` : '未分配')
              .fontSize(14)
              .fontColor('#333')
              .layoutWeight(1)
          }

          Row() {
            Text('起始位置:')
              .fontSize(14)
              .fontColor('#666')
              .width(80)
            Text(this.task.startLocation)
              .fontSize(14)
              .fontColor('#333')
              .layoutWeight(1)
          }

          Row() {
            Text('距离:')
              .fontSize(14)
              .fontColor('#666')
              .width(80)
            Text(`${this.task.distance}公里`)
              .fontSize(14)
              .fontColor('#333')
              .layoutWeight(1)
          }
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#fff')
      .borderRadius(12)
      .margin({ top: 16, left: 16, right: 16 })

      // 时间信息卡片
      Column({ space: 12 }) {
        Text('时间信息')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333')
          .alignSelf(ItemAlign.Start)

        Divider()
          .strokeWidth(1)
          .color('#f0f0f0')

        Column({ space: 8 }) {
          Row() {
            Text('创建时间:')
              .fontSize(14)
              .fontColor('#666')
              .width(80)
            Text(this.task.createTime)
              .fontSize(14)
              .fontColor('#333')
              .layoutWeight(1)
          }

          Row() {
            Text('截止时间:')
              .fontSize(14)
              .fontColor('#666')
              .width(80)
            Text(this.task.deadlineTime)
              .fontSize(14)
              .fontColor('#000')
              .layoutWeight(1)
          }

          Row() {
            Text('完成时间:')
              .fontSize(14)
              .fontColor('#666')
              .width(80)
            Text(this.task.completionTime)
              .fontSize(14)
              .fontColor('#333')
              .layoutWeight(1)
          }
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#fff')
      .borderRadius(12)
      .margin(16)

      // 操作按钮区域
      Column({ space: 12 }) {
        if (this.task.status === 0) {
          Button('分配任务', { type: ButtonType.Normal })
            .width('100%')
            .height(48)
            .backgroundColor('#409EFF')
            .fontColor('#fff')
            .onClick(() => {
              this.showAssignDialog = true;
            })
        }

        if (this.task.status === 1) {
          Button('标记完成', { type: ButtonType.Normal })
            .width('100%')
            .height(48)
            .backgroundColor('#67c23a')
            .fontColor('#fff')
            .onClick(() => {
              this.completeTask();
            })
        }

        Button('返回列表', { type: ButtonType.Normal })
          .width('100%')
          .height(48)
          .backgroundColor('#f5f7fa')
          .fontColor('#606266')
          .onClick(() => {
            router.back();
          })
      }
      .width('100%')
      .padding(16)
      .margin({ bottom: 24 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f7fa')

  }

}