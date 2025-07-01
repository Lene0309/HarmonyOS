import router from '@ohos.router';
import { LoginParamsType, LoginRequestType, LoginRequestTypeInfo, sendMessageRequestType } from './accountType';
import { promptAction } from '@kit.ArkUI';
import { Request } from '../utils/Request';

@Entry
@Component
struct Login {
  @State isRegisterMode: boolean = false
  @State confirmPassword: string = ''
  @State formData: LoginParamsType = {
    username: 'test',
    password: '12345',
  }

  // 处理登录
  async handleLogin() {
    if (!this.formData.username || !this.formData.password) {
      promptAction.showToast({ message: '请输入用户名和密码' });
      return;
    }
    const result = await Request.post<LoginParamsType, LoginRequestType>(`/api/auth/login`, this.formData)
    const token = result.data.accessToken
    AppStorage.setOrCreate("Authorization", token)
    const user = await Request.post<string, sendMessageRequestType>(`/api/user/info`)
    AppStorage.setOrCreate("userId", user.data.userId)
    if (result.code === 0) {
      router.replaceUrl({
        url: 'pages/Index'
      })
      promptAction.showToast({
        message: '登录成功',
        duration: 2000
      })

    } else {
      promptAction.showToast({
        message: result.message,
        duration: 2000
      })
    }
  }

  build() {
    Stack() {
      Image($r('app.media.logo'))
        .width('100%')
        .height('35%')
      Column() {
        Row() {
          Image($rawfile('account/username_icon.png')).width(30)
          TextInput({ placeholder: '请输入账号', text: $$this.formData.username })
            .borderRadius(0)
            .backgroundColor(Color.White)
            .onSubmit((EnterKeyType) => {
              console.info(EnterKeyType + '输入法回车键的类型值')
            })
            .layoutWeight(1)
            .height('100%')
            .onChange((value: string) => {
              this.formData.username = value
            })
        }
        .width('90%')
        .height('14%')
        .border({
          width: 1,
          color: "#dedede",
          style: BorderStyle.Solid
        })
        .justifyContent(FlexAlign.Start)
        .margin({ top: 30 })

        Row() {
          Image($rawfile('account/password_icon.png')).width(30)
          TextInput({ placeholder: '请输入吗密码', text: $$this.formData.password })
            .type(InputType.Password)
            .borderRadius(0)
            .backgroundColor(Color.White)
            .onSubmit((EnterKeyType) => {
              console.info(EnterKeyType + '输入法回车键的类型值')
            })
            .layoutWeight(1)
            .height('100%')
            .onChange((value: string) => {
              this.formData.password = value
            })
        }
        .width('90%')
        .height('14%')
        .border({
          width: 1,
          color: "#dedede",
          style: BorderStyle.Solid
        })
        .justifyContent(FlexAlign.Start)
        .margin({ top: 30 })

        Button("登录")
          .width('90%')
          .height('18%')
          .backgroundColor("#4749a1")
          .margin({ top: 30 })
          .onClick((event: ClickEvent) => {
            this.handleLogin()
          })

        Text() {
          Span("登录即及代表同意").fontColor("#cacaca").fontSize(14)
          Span("《同意协议》").fontWeight(600).fontSize(14)
          Span("和").fontColor("#cacaca").fontSize(14)
          Span("《隐私条款》").fontWeight(600).fontSize(14)
        }.margin({ top: 30 })
      }
      .backgroundColor(Color.White)
      .borderRadius(10)
      .width('95%')
      .height('45%')
      .offset({ y: '28%' })

      Text("忘记密码")
        .fontColor("#4749a1")
        .width('100%')
        .offset({ y: '80%' })
        .textAlign(TextAlign.Center)
        .fontWeight(600)
      Text("注册账号")
        .fontColor("#4749a1")
        .width('100%')
        .offset({ y: '85%' })
        .textAlign(TextAlign.Center)
        .fontWeight(600)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Registry'
          }, router.RouterMode.Single)
        })
    }.width('100%').backgroundColor("#f5f5f5").height('100%')
    .alignContent(Alignment.Top)
  }
}