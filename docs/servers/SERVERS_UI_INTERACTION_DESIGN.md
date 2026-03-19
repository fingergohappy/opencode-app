# servers 页面交互设计

## 页面目标

- 管理服务器列表（新增、编辑、删除）
- 切换当前连接服务器
- 设置默认服务器
- 展示当前选中服务器的健康状态
- 提供“测试连接”能力（手动触发）

## 建议目录

```text
lib/servers/
  screen.dart
  widgets/
    server_search_bar.dart
    server_list_section.dart
    server_tile.dart
    server_health_badge.dart
    server_form_sheet.dart
    servers_empty_state.dart
```

## Screen 结构

`screen.dart` 作为子页面内容组件，不自行创建 `Scaffold/AppBar`，由全局 layout 承载。页面只负责 body 内容区域，建议使用 `ListView`，由以下区域构成：

1. 搜索区（页面中部主区域）
- 在页面主内容区约 `1/3` 高度处放置一个明显的搜索框（等价于距底部约 `2/3` 高度，不放在 AppBar）
- 搜索框固定不随列表滚动
- 列表和空状态内容只能从搜索框下方开始，不得滚动到搜索框后面
- 占位文案：`搜索服务器名称或地址`
- 输入后实时过滤列表

2. 服务器列表区
- 每项使用 `ServerTile`
- 支持点击选中
- 每项支持左滑（`endToStart`）显示操作：`编辑`、`删除`
- 每项可显示默认标签与健康状态徽标

3. 空状态
- 无服务器时显示 `ServersEmptyState`
- 包含主按钮：`新增服务器`

4. 新增按钮
- 页面右下角 `FloatingActionButton` 为本页面独有
- 全局 layout 只负责统一 `AppBar`，不接管该页面 FAB

## 组件职责

1. `ServerListSection`
- 输入：`List<Server>`、`Server? selected`、`ServerHealthStatus? health`
- 仅负责列表布局，不处理业务

2. `ServerTile`
- 输入：`Server server`、`bool selected`、`bool isCurrentHealthTarget`、`ServerHealthStatus? health`
- 输出事件：`onTap`、`onEdit`、`onDelete`
- 展示规则：
- 标题：`name ?? url`
- 副标题：`url`
- leading：选中态图标
- trailing：默认标签 + 健康徽标
- 交互：左滑露出 `编辑`、`删除` 动作

3. `ServerSearchBar`
- 输入：`String query`
- 输出事件：`onChanged(String value)`
- 用途：按 `name/url` 过滤列表

4. `ServerHealthBadge`
- 输入：`ServerHealthStatus?`
- 展示文案：
- `healthy == true`：在线（可附带 version）
- `healthy == false`：离线（可点击查看 error 文案）
- `null`：未检测

5. `ServerFormSheet`
- 用途：新增 / 编辑共用
- 输入：`Server? initialValue`
- 字段：`url`、`name`、`username`、`password`、`isDefault`
- 输出：`ServerDraft` 或 `Server`
- 校验：
- `url` 必填
- `url` 基础格式校验（http/https）
- 其他字段可空

6. `ServersEmptyState`
- 空列表占位
- 提供新增入口

## 页面交互流程

1. 新增服务器
- 点右下角 FAB 或空状态按钮 -> 打开 `ServerFormSheet`
- 提交后调用 `serversControllerProvider.notifier.addServer(...)`
- 成功后关闭 sheet；失败显示 `SnackBar`

2. 编辑服务器
- 左滑列表项 -> 点 `编辑`
- 提交后调用 `updateServer(originalUrl, next)`
- 若编辑的是当前选中服务器，controller 内部会重建 client

3. 选中服务器
- 点击 `ServerTile`
- 调用 `selectServer(url)`
- UI 自动刷新当前选中与健康状态轮询目标

4. 设为默认
- 在编辑弹窗中切换 `isDefault` 并保存
- 调用 `setDefault(url)`
- 列表默认标记即时更新

5. 删除服务器
- 左滑列表项 -> 点 `删除` -> 二次确认
- 调用 `removeServer(url)`
- 若删除当前选中项，选中态会被清空

6. 测试连接
- 选中某项后在该项上显示“测试连接”入口（或长按菜单入口）
- 建议复用健康检查逻辑并立即触发一次检查
- 结果通过 `SnackBar` 或状态文案反馈

## Provider 绑定建议（UI 层）

- 页面主结构：
- `servers = ref.watch(serversProvider)`
- `selected = ref.watch(selectedServerProvider)`
- `health = ref.watch(healthStatusProvider)`
- `query = ref.watch(serverSearchQueryProvider)`（如需本地搜索状态）
- `filteredServers = ref.watch(filteredServersProvider)`

- 操作回调统一走 controller：
- `ref.read(serversControllerProvider.notifier).addServer(...)`
- `ref.read(serversControllerProvider.notifier).updateServer(...)`
- `ref.read(serversControllerProvider.notifier).removeServer(...)`
- `ref.read(serversControllerProvider.notifier).setDefault(...)`
- `ref.read(serversControllerProvider.notifier).selectServer(...)`
- `ref.read(serversControllerProvider.notifier).clearSelection()`

## 响应式与可用性细节

- 删除和危险操作必须二次确认
- 网络错误、认证失败、重复 url 等错误统一展示用户可读文案
- 列表项点击区域保持足够高度，适配移动端触控
- 长 url 需要省略显示，但详情/编辑时展示完整值
- 左滑操作建议使用 `flutter_slidable`，避免和 `Dismissible` 的删除语义冲突
