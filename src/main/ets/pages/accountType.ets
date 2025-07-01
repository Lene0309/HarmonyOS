// 注册请求参数
export interface RegistryParamsType {
  username:string
  nickname:string
  password:string
  phoneNumber:string
  deptId:number
}
// 注册返回
export interface LoginRequestType {
  code: number
  message: string
  data: LoginToken
}
// 登录参数
export interface LoginParamsType{
  username:string
  password:string
}
export interface LoginRequestTypeInfo {
  userId:number
  deptId:number
  username: string
  nickname: string
  password: string
  phoneNumber: string
  createTime: string
  updateTime: string
}

export interface sendMessageRequestType{
  code: number
  message: string
  error: string
  data: LoginRequestTypeInfo
}
export interface LoginToken{
  accessToken:string
}
export interface RequestType{
  code: number
  message: string
  error: string
  data: null
}