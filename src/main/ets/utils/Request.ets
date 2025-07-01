import axios, { RawAxiosRequestHeaders, AxiosResponse, Method, InternalAxiosRequestConfig } from "@ohos/axios"
export class AxiosUtil {
  private static instance: AxiosUtil = new AxiosUtil()

  private constructor() {
    // 请求拦截器
    axios.interceptors.request.use((config: InternalAxiosRequestConfig) => {
      // config.headers['Content-Type'] = 'application/json'
      config.headers['Authorization'] =AppStorage.get("Authorization")
      return config
    })
    // 响应拦截器
    axios.interceptors.response.use((response: AxiosResponse) => {
      return response.data
    })
  }

  // axios: AxiosInstance
  create(baseUrl?: string) {
    axios.defaults.baseURL = baseUrl
    console.log(axios.defaults.baseURL)
  }

  public static getInstance(url: string) {
    AxiosUtil.instance.create(url)
    return AxiosUtil.instance
  }

  async request<D, T>(method: Method = 'get', path: string, data?: D, headers?: RawAxiosRequestHeaders): Promise<T> {
    return await axios.request({
      url: path,
      method,
      data,
      headers
    })
  }

  async post<D, T>(path: string, data?: D, headers?: RawAxiosRequestHeaders): Promise<T> {
    return await axios.post(path, data, { headers })
  }

  async put<T = void, D = undefined>(path: string, data?: D, headers?: RawAxiosRequestHeaders): Promise<T> {
    return axios.put(path, data, { headers });
  }

  async get<T>(path: string, headers?: RawAxiosRequestHeaders): Promise<T> {
    return await axios.get(path, { headers })
  }
  async delete<T>(path: string, headers?: RawAxiosRequestHeaders): Promise<T> {
    return await axios.delete(path, { headers })
  }
}

//http://10.0.2.2:8080 真机地址 模拟器地址：http://localhost:8080
export const Request = AxiosUtil.getInstance('http://10.0.2.2:8080')