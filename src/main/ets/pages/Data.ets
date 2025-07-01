/**
 * 任务数据模型
 */
export interface Task {
  /** 任务ID */
  taskId: string;

  /** 任务名称 */
  taskName: string;

  /** 创建者ID */
  creatorId: number;

  /** 执行者ID */
  executorId: number;

  /** 起始位置 */
  startLocation: string;

  /** 距离（单位：公里） */
  distance: number;

  /** 截止时间 */
  deadlineTime: string;

  /** 完成时间 */
  completionTime: string;

  /** 上传时间 */
  uploadTime: string;

  /** 任务状态
   * 1-待分配 2-进行中 3-已完成 4-已超时
   */
  status: number;

  /** 创建时间 */
  createTime: string;

}

export interface TaskRequestType {
  code: number
  message: string
  data: Task[]
  error: string
}

/**
 * 缺陷数据模型
 */
export interface Defect {
  /** 缺陷编号 */
  defectId: number;

  /** 所属任务编号 */
  taskId: string;

  /** 缺陷类型 */
  defectType: string;

  /** 缺陷距离原点位置 */
  distanceFromOrigin: string;

  /** 缺陷图片URL列表（逗号分隔） */
  imageUrls: string;

  /** 是否属实 */
  isVerified: boolean;

  /** 严重程度 */
  severity: 'critical' | 'high' | 'medium' | 'low' | string;

  /** 缺陷长度（米） */
  defectLength: number;

  /** 缺陷面积（平方米） */
  defectArea: number;

  /** 缺陷数量 */
  defectQuantity: number;

  /** 建议整改方式 */
  recommendedAction: string;

  /** 缺陷上报时间 */
  reportedTime: string;

  /** 缺陷状态（0已上报 1已整改） */
  status: '0' | '1';
}

export interface RequestType {
  code: number
  message: string
  data: null
}
export interface DefectRequestType {
  code: number
  message: string
  data: Defect[]
  error: string
}

//部门数据类
export interface Department {
  deptId: number;
  parentId: number;
  deptName: string;
  status: number;
  createTime: string;
  remark: string;
}
export interface DepartmentRequestType {
  code: number
  message: string
  data: Department[]
  error: string
}