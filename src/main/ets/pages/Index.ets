import { AdminTaskList } from './AdminTaskList';
import { DefectList } from './DefectList';

@Entry
@Component
struct Index {
  @State index: number = 0;
  private tabs: TabsController = new TabsController();
  @State isShow: boolean = true

  onPageShow(): void {
    this.isShow = true
  }

  onPageHide(): void {
    this.isShow = false
  }

  build() {
    if (this.isShow) {
      Tabs({ barPosition: BarPosition.End, controller: this.tabs, index: this.index }) {
        TabContent() {
          if (this.index === 0) {
            AdminTaskList();
          }
        }.tabBar(this.tabBear('任务列表', 0, $r('app.media.bg'), $r('app.media.bg1')))

        TabContent() {
          if (this.index === 1) {
            DefectList();
          }
        }.tabBar(this.tabBear('缺陷报告', 1, $r('app.media.qx'), $r('app.media.qx1')))
      }.scrollable(false)
      .height('100%')
      .width('100%')
    }
  }

  @Builder
  tabBear(text: string, selectIndex: number, normal: Resource, img: Resource) {
    Column() {
      Image(selectIndex == this.index ? img : normal).size({ width: 28, height: 28 })
      Text(text).fontSize(14).margin({ top: 5 }).fontColor(this.index == selectIndex ? '#1296db' : '#2c2c2c')
    }
    .justifyContent(FlexAlign.Center)
    .height(60)
    .width('100%')
    .onClick(() => {
      this.index = selectIndex
      this.tabs.changeIndex(this.index)
    })
  }
}