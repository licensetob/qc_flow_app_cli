enum QcPageStateConfig {
  // 初始状态
  initialized,
  // 加载中状态
  loading,
  // 错误状态,显示失败界面
  errorWithPage,
  // 错误状态,只弹错误信息
  errorOnlyToast,
  // 错误状态,显示刷新按钮
  errorWithRefresh,
  // 没有更多数据
  noMoreData,
  // 空数据状态
  emptyData,
  // 数据获取成功状态
  dataFetched,
}