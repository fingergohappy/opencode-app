# Servers Industrial Visual Refresh Design

## Goal

在不改变 `servers` 页面核心结构和交互方式的前提下，重做页面视觉语言，使其摆脱当前偏默认 Flutter Material 的观感，改为克制的工业感样式。

## Confirmed Constraints

- 页面仍然跟随当前主题，不做固定深色页
- 改动力度为保守级，只重做视觉，不重做结构
- 搜索框继续保持固定位置，不改当前布局逻辑
- 主识别点优先保留“硬边细线卡片”
- 搜索框使用硬边矩形，不使用胶囊样式
- 整体气质为“克制工业感”，不要做成夸张海报风

## Visual Direction

本次视觉方向基于用户确认的 `A · 轮廓堆叠` 方案，并吸收 `localhost:4096` 移动端页面中真正有效的气质元素，而不是直接照抄其界面。

重点保留以下语言：

- 大留白与更明确的垂直节奏
- 低彩度背景上的细线边框
- 更硬朗的矩形搜索框和卡片外轮廓
- 标题与说明的强弱对比更明显
- URL、状态、小标签使用等宽字强化信息层级

## Component Changes

### 1. Page Surface

- 保留 `ServersScreen` 现有结构与搜索框固定位置
- 使用更有层次的背景，而不是单纯平铺色
- 保持克制，不引入强烈装饰性图形作为主元素

### 2. Search Bar

- 从当前圆润搜索条改为硬边矩形搜索框
- 降低阴影感，改为边框与轻微面板填充
- placeholder 和输入内容使用更偏系统化的信息层级

### 3. Server Cards

- 维持现有卡片式列表结构和滑动操作能力
- 统一改为细线边框、较硬转角、低阴影或无阴影
- 选中态不靠大面积高饱和底色，而靠边框、轻微底色变化和信息标签强化

### 4. Typography

- 主标题保持简洁，但更有控制台感
- 服务器标题继续可读优先
- URL、副信息、状态标签改为等宽字风格

### 5. FAB And Tags

- FAB 改得更克制，避免当前默认悬浮按钮的“玩具感”
- `默认`、健康状态等标签改为更像系统标记而不是彩色胶囊

## Testing Expectations

- 现有布局和交互测试继续通过
- 不改变搜索框固定位置和滚动边界
- 不破坏列表底部与 FAB 的避让
- 保持横屏无溢出

## Files Expected To Change

- `lib/servers/screen.dart`
- `lib/servers/widgets/server_search_bar.dart`
- `lib/servers/widgets/server_tile.dart`
- `lib/servers/widgets/server_health_badge.dart`
- `lib/servers/widgets/servers_empty_state.dart`
- 如有必要，补充或更新 `test/servers/servers_screen_test.dart`
