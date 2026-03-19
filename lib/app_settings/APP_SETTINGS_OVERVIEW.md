# app_settings 当前实现总览

## 文档目的

这份文档用于说明 `lib/app_settings/` 当前已经落地的能力、目录职责和设置边界。

它描述的是**现状**，不是后续规划。

## 当前覆盖范围

`app_settings` 现在已经是一个按领域拆分的应用级偏好设置模块，包含以下 6 个设置域：

- `locale/`：语言选择
- `theme/`：主题方案与明暗模式
- `general/`：通用交互行为偏好
- `notifications/`：系统通知偏好
- `sound/`：提示音开关
- `updates/`：更新检查与版本说明偏好

对应的聚合根是 `lib/app_settings/model.dart` 中的 `AppSettings`，当前字段包括：

- `theme`
- `locale`
- `general`
- `notifications`
- `sound`
- `updates`

## 当前目录结构职责

### 1. 聚合层

- `model.dart`：定义 `AppSettings` 聚合模型与默认值
- `providers.dart`：聚合各领域 provider，并暴露整体设置快照与持久化监听
- `storage.dart`：负责整包设置的加载与保存
- `screen.dart`：设置页入口与分区组装

### 2. 领域层

每个设置域当前都沿用一致的拆分方式：

- `model.dart`：定义该领域的数据结构
- `controller.dart`：封装状态更新入口
- `providers.dart`：暴露细粒度读取 provider
- `section.dart`：渲染该分区的设置 UI

这一点在 `general/`、`notifications/`、`sound/`、`updates/`、`theme/` 中都已经落地；`locale/` 当前没有单独的 `section.dart`，而是由 `general/section.dart` 中的语言项直接消费。

## 已实现的设置功能

### General

`general/` 当前负责通用交互偏好，已经实现：

- Language：界面语言切换
  - `system`
  - `english`
  - `chinese`
- Show reasoning summaries：是否展示推理摘要
- Expand shell tool parts：是否默认展开 Shell 工具输出
- Expand edit tool parts：是否默认展开编辑工具输出
- Follow-up behavior：后续提示行为
  - `auto`
  - `manual`
  - `disabled`

其中语言模型定义在 `locale/model.dart`，但 UI 被放在 General 分区统一展示。

### Appearance

外观设置由 `theme/` 承载，当前已经实现：

- Color scheme：主题模式切换
  - 跟随系统
  - 浅色
  - 深色
- Theme：主题方案切换
  - 通过 `selectedThemeId` 选择当前主题
  - 主题数据来自 `lib/theme/opencode_themes.dart`

当前没有独立的字体设置，字体不属于 `app_settings` 的现有建模范围。

### Notifications

`notifications/` 当前已经实现 3 个通知开关：

- Agent notifications
- Permission notifications
- Error notifications

### Sound

`sound/` 当前实现为一个单独开关：

- Sound enabled：是否启用提示音

### Updates

`updates/` 当前已经实现：

- Auto check updates：是否自动检查更新
- Show release notes：是否展示版本说明

## 当前 UI 组织方式

设置页入口是 `lib/app_settings/screen.dart` 中的 `SettingsScreen`。

当前页面按分区顺序渲染为：

1. `GeneralSection`
2. `AppearanceSection`
3. `NotificationsSection`
4. `SoundSection`
5. `UpdatesSection`

每个分区独立 `watch` 自己关心的 provider，避免把所有设置状态集中在一个大 `build` 方法中。

## 当前状态管理方式

`app_settings` 当前使用 Riverpod 的 `NotifierProvider` 管理各设置域状态。

现有模式是：

- 每个领域在 `build()` 时从 `AppSettingsStorage` 读取自己的初始值
- 每个领域通过 `setXxx()` 方法更新本领域状态
- `currentAppSettingsProvider` 将各领域状态重新聚合成一个完整的 `AppSettings`
- `settingsPersistenceProvider` 监听整体设置变化，并自动写回本地存储

这意味着当前实现已经具备以下闭环：

1. 读取持久化设置
2. 将设置映射到分领域状态
3. 通过 UI 修改设置
4. 自动聚合并持久化保存

## 当前持久化方式

`storage.dart` 当前通过 `SharedPreferences` 以单个 key：`app_settings` 保存整包 JSON。

具体行为：

- 读取时：从 `SharedPreferences` 中读取 JSON 字符串
- 反序列化失败时：回退到 `AppSettings.defaults`
- 保存时：将完整 `AppSettings` 序列化后整体写回

这说明当前持久化边界是“整包设置快照”，而不是每个领域独立单存。

## 和应用壳层的连接方式

`lib/app/app.dart` 当前已经直接消费 `app_settings` 提供的结果：

- `currentLocaleProvider`：驱动 `MaterialApp.locale`
- `themeModeProvider`：驱动 `MaterialApp.themeMode`
- `lightThemeProvider` 与 `darkThemeProvider`：驱动应用主题
- `settingsPersistenceProvider`：在应用启动时挂载自动持久化监听

当前 `MyApp` 直接把 `SettingsScreen` 作为首页，因此这套设置系统已经可以独立运行和验证。

## 当前边界

以下内容**尚不属于** `app_settings` 当前已实现范围：

- Provider 连接配置、认证信息与连接状态
- 模型搜索、模型分组、模型启用状态
- 远端拉取的运行时元数据
- 加载中、错误态、连接态等运行时过程状态
- 字体类型、音效类型、音量等级等更细的表现层偏好

换句话说，`app_settings` 当前聚焦的是**用户偏好设置本身**，而不是所有运行时系统状态。

## 当前结论

`app_settings` 已经不再是只覆盖语言和主题的早期骨架，而是一个已经落地的多领域设置模块。

它目前完成了以下关键能力：

- 多领域设置模型拆分
- 分领域 Riverpod 状态管理
- 设置页分区 UI
- 本地 JSON 持久化
- 与 `MaterialApp` 的语言和主题联动

如果后续继续扩展，这份文档应继续以“当前已实现能力”为准更新，而不是混入尚未落地的规划项。
