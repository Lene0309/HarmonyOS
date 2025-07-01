import { router } from '@kit.ArkUI'

@Component
export struct NavBar {
  @Prop title: string = 'Nav Bar'
  textAlign: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
    'center': { 'anchor': '__container__', 'align': HorizontalAlign.Center },
  }
  imageAlign: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
    'center': { 'anchor': '__container__', 'align': VerticalAlign.Center }
  }

  build() {
    RelativeContainer() {
      Image($r('app.media.back'))
        .alignRules(this.imageAlign)
        .width(20)
        .margin({ left: 10 })
        .onClick(() => {
          router.back()
          console.log('返回')
        })
        .zIndex(9)
      Text(this.title)
        .alignRules(this.textAlign)
        .height('100%')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontWeight(600)
    }.width('100%').height(60)
  }
}