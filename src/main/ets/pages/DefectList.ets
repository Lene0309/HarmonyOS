import { router } from '@kit.ArkUI';
import { Request } from '../utils/Request';
import { Defect, DefectRequestType } from './Data';

@Component
export struct DefectList {
  @State defects: Defect[] = [];
  @State searchText: string = '';
  @State page: number = 1;

  aboutToAppear(): void {

    Request.get<DefectRequestType>(`/defect/list?page=${this.page}&pageSize=${20}`).then((res) => {
      this.defects = res.data['items'];
      console.log('data' + JSON.stringify(res.data['items']))
    })
  }

  // 获取状态标签样式
  @Builder
  statusTag(status: string) {
    if (status === '1') {
      Text('已整改')
        .fontSize(10)
        .fontColor('#67c23a')
        .padding({ left: 4, right: 4 })
        .border({ width: 1, color: '#67c23a', radius: 4 })
    } else {
      Text('已上报')
        .fontSize(10)
        .fontColor('#e6a23c')
        .padding({ left: 4, right: 4 })
        .border({ width: 1, color: '#e6a23c', radius: 4 })
    }
  }

  build() {
    Column({ space: 10 }) {
      Search({ placeholder: '搜索任务' })
        .width('100%')
        .borderRadius(5)
        .backgroundColor('#fff')
      Row() {
        Text('缺陷列表').fontWeight(FontWeight.Bold).fontSize(20)
        // 底部添加按钮
        Button('+ 添加缺陷', { type: ButtonType.Normal })
          .width(120)
          .height(40)
          .borderRadius(5)
          .backgroundColor('#409EFF')
          .fontColor('#fff')
          .fontSize(16)
          .onClick(() => {
            router.pushUrl({ url: 'pages/AddDefect' });
          })
          .alignSelf(ItemAlign.End)
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)

      // 缺陷列表
      List({ space: 10 }) {
        ForEach(this.defects, (defect: Defect) => {
          ListItem() {
            Row({ space: 10 }) {
              // 左侧图片
              Column() {
                if (defect.imageUrls) {
                  Image(defect.imageUrls)
                    .width(60)
                    .height(60)
                    .objectFit(ImageFit.Cover)
                    .borderRadius(4)
                } else {
                  Image($r('app.media.no_image'))
                    .width(60)
                    .height(60)
                    .objectFit(ImageFit.Cover)
                    .borderRadius(4)
                }
              }

              // 中间内容
              Column({ space: 4 }) {
                Row() {
                  Text(`#${defect.defectId}`)
                    .fontSize(12)
                    .fontColor('#409EFF')
                  Text(defect.defectType)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#333')
                    .margin({ left: 8 })
                    .layoutWeight(1)
                  this.statusTag(defect.status)
                }

                Row({ space: 10 }) {
                  Text(defect.taskId)
                    .fontSize(12)
                    .fontColor('#666')
                  Text(`位置: ${defect.distanceFromOrigin}`)
                    .fontSize(12)
                    .fontColor('#666')
                }

                Row({ space: 10 }) {
                  Text(`长度: ${defect.defectLength}m`)
                    .fontSize(12)
                    .fontColor('#666')

                  Text(`上报: ${defect.reportedTime}`)
                    .fontSize(12)
                    .fontColor('#666')

                }
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            .justifyContent(FlexAlign.Start)
            .width('100%')
            .padding(10)
            .backgroundColor('#fff')
            .borderRadius(5)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)

    }
    .alignItems(HorizontalAlign.Start)
    .padding({ left: 10, right: 10 })
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f7fa')
  }
}