import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { Request } from '../utils/Request';
import { RequestType, sendMessageRequestType } from './accountType';
import { Task, TaskRequestType } from './Data';


@Component
export struct AdminTaskList {
  @State tasks: Task[] = [];
  @State searchText: string = '';
  @State page: number = 1;
  @State currentTask: Task = {
    taskId: '',
    taskName: '',
    creatorId: 0,
    executorId: 0,
    startLocation: '',
    distance: 0,
    deadlineTime: '',
    completionTime: '',
    uploadTime: '',
    status: 0,
    createTime: ''
  };

  aboutToAppear(): void {
    const userId = AppStorage.get("userId") as number
    Request.get<TaskRequestType>(`/api/inspection/task/user/${userId}?page=${this.page}&pageSize=${20}`).then((res) => {
      this.tasks = res.data['items'];
      console.log('data' + JSON.stringify(res.data['items']))
    })
  }

  // 获取状态标签样式
  @Builder
  statusTag(status: number) {
    if (status === 1) {
      Text('待接收')
        .fontSize(12)
        .fontColor('#e6a23c')
        .padding(4)
        .backgroundColor('#fdf6ec')
        .borderRadius(4)
    } else if (status === 2) {
      Text('进行中')
        .fontSize(12)
        .fontColor('#409EFF')
        .padding(4)
        .backgroundColor('#ebf5ff')
        .borderRadius(4)
    } else if (status === 3) {
      Text('已完成')
        .fontSize(12)
        .fontColor('#67c23a')
        .padding(4)
        .backgroundColor('#f0f9eb')
        .borderRadius(4)
    }
  }

  build() {
    Column() {
      // 顶部操作栏
      Row({ space: 12 }) {
        // 搜索框
        TextInput({ text: this.searchText, placeholder: '搜索任务名称/ID' })
          .layoutWeight(1)
          .height(40)
          .backgroundColor('#fff')
          .borderRadius(20)
          .padding({ left: 16, right: 16 })
          .onChange(val => this.searchText = val)


        // 添加任务按钮
        Button('+ 添加', { type: ButtonType.Normal })
          .width(100)
          .height(40)
          .backgroundColor('#409EFF')
          .fontColor('#fff')
          .onClick(() => {
            router.pushUrl({ url: 'pages/admin/AddTask' });
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#fff')
      .border({ width: 1, color: '#f0f0f0' })

      // 任务列表
      List({ space: 12 }) {
        ForEach(this.tasks, (task: Task, index) => {
          ListItem() {
            // 任务卡片
            Column({ space: 12 }) {
              Row() {
                Column({ space: 6 }) {
                  Row() {
                    Text(task.taskName)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#333')
                      .layoutWeight(1)

                    this.statusTag(task.status)
                  }

                  Text(`任务ID: ${task.taskId}`)
                    .fontSize(12)
                    .fontColor('#666')

                  Text(`起始位置: ${task.startLocation}`)
                    .fontSize(12)
                    .fontColor('#666')

                  Row({ space: 8 }) {
                    Text(`距离: ${task.distance}km`)
                      .fontSize(12)
                      .fontColor('#606266')

                    Text(`截止: ${task.deadlineTime}`)
                      .fontSize(12)
                      .fontColor(task.status === 4 ? '#f56c6c' : '#606266')
                  }
                  .margin({ top: 4 })
                }
                .layoutWeight(1)
              }

              // 操作按钮
              Row({ space: 12 }) {
                if (task.status === 1) {
                  Button('接收', { type: ButtonType.Normal })
                    .width(80)
                    .height(36)
                    .backgroundColor('#ebf5ff')
                    .fontColor('#409EFF')
                    .onClick(() => {
                      task.status = task.status + 1;
                      Request.put<RequestType, Task>(`/api/inspection/task/${task.taskId}`, task).then(() => {
                        this.tasks.splice(index, 1, task)
                      })
                    })
                }

                if (task.status === 2) {
                  Button('完成', { type: ButtonType.Normal })
                    .width(80)
                    .height(36)
                    .backgroundColor('#f0f9eb')
                    .fontColor('#67c23a')
                    .onClick(() => {
                      task.status = task.status + 1;
                      Request.put<RequestType, Task>(`/api/inspection/task/${task.taskId}`, task).then(() => {
                        this.tasks.splice(index, 1, task)
                      })
                    })
                }


                if (task.status !== 3 && task.status !== 4) {
                  Button('取消', { type: ButtonType.Normal })
                    .width(80)
                    .height(36)
                    .backgroundColor('#fef0f0')
                    .fontColor('#f56c6c')
                    .margin({ left: 12 })
                    .onClick(() => {
                      promptAction.showDialog({
                        title: '确认取消',
                        message: '确定要取消此任务吗？',
                        buttons: [
                          { text: '否', color: '#999' },
                          { text: '是', color: '#f56c6c' }
                        ]
                      }).then(result => {
                        if (result.index === 1) {
                          // 实际项目中这里调用取消API
                          this.tasks = this.tasks.filter(t => t.taskId !== task.taskId);
                          promptAction.showToast({ message: '任务已取消', duration: 2000 });
                        }
                      });
                    })
                }
              }
              .justifyContent(FlexAlign.Center)
              .width('100%')
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#fff')
            .borderRadius(8)
            .border({ width: 1, color: '#f0f0f0' })
          }.onClick(() => {
            router.pushUrl({ url: 'pages/TaskDetailPage', params: task })
          })
        })
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 8 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f7fa')

  }

  @Builder
  buildDetailDialogContent() {
    Column({ space: 12 }) {
      Row() {
        Text('任务ID:')
          .fontSize(14)
          .fontColor('#666')
          .width(80)
          .textAlign(TextAlign.End)
        Text(this.currentTask?.taskId || '--')
          .fontSize(14)
          .fontColor('#333')
          .layoutWeight(1)
      }

      Row() {
        Text('任务名称:')
          .fontSize(14)
          .fontColor('#666')
          .width(80)
          .textAlign(TextAlign.End)
        Text(this.currentTask?.taskName || '--')
          .fontSize(14)
          .fontColor('#333')
          .layoutWeight(1)
      }

      Row() {
        Text('起始位置:')
          .fontSize(14)
          .fontColor('#666')
          .width(80)
          .textAlign(TextAlign.End)
        Text(this.currentTask?.startLocation || '--')
          .fontSize(14)
          .fontColor('#333')
          .layoutWeight(1)
      }

      Row() {
        Text('距离:')
          .fontSize(14)
          .fontColor('#666')
          .width(80)
          .textAlign(TextAlign.End)
        Text(`${this.currentTask?.distance || '--'}km`)
          .fontSize(14)
          .fontColor('#333')
          .layoutWeight(1)
      }

      Row() {
        Text('截止时间:')
          .fontSize(14)
          .fontColor('#666')
          .width(80)
          .textAlign(TextAlign.End)
        Text(this.currentTask.deadlineTime)
          .fontSize(14)
          .fontColor('#333')
          .layoutWeight(1)
      }

      Row() {
        Text('完成时间:')
          .fontSize(14)
          .fontColor('#666')
          .width(80)
          .textAlign(TextAlign.End)
        Text(this.currentTask.completionTime)
          .fontSize(14)
          .fontColor('#333')
          .layoutWeight(1)
      }

      Row() {
        Text('创建时间:')
          .fontSize(14)
          .fontColor('#666')
          .width(80)
          .textAlign(TextAlign.End)
        Text(this.currentTask.createTime)
          .fontSize(14)
          .fontColor('#333')
          .layoutWeight(1)
      }
    }
    .width('100%')
    .padding(12)
  }
}