# servers 页面设计

## 目录结构

```text
lib/servers/
  model.dart
  providers.dart
  data/
    api/
      health_api.dart
    storage/
      servers_storage.dart
  controller.dart
  screen.dart
```

## 说明

- `model.dart`：定义 `Server`、`ServersState`、`ServerHealthStatus` 等核心模型
- `data/api/`：负责服务器健康检查请求，不负责本地保存
- `data/storage/`：负责本地读写服务器列表
- `controller.dart`：`ServersController`（Notifier），管理服务器列表增删改、设默认、选中服务器、创建 client
- `providers.dart`：对外暴露列表、当前选中服务器、client、健康状态等 provider
- `screen.dart`：服务器页面入口

### 认证说明

- opencode server 使用 Basic Auth
- 不设计独立的 `auth_api.dart`
- 用户名和密码属于 `Server` 的连接配置
- 每次请求都直接携带 `username` 和 `password`
- “测试连接” 或“健康检查”本质上都是带 Basic Auth 的普通请求

## 1. Model

### Server

用于保存一个 opencode 服务器。

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `url` | `String` | 是 | 服务器地址 |
| `name` | `String?` | 否 | 服务器名称 |
| `username` | `String?` | 否 | 用户名 |
| `password` | `String?` | 否 | 密码 |
| `isDefault` | `bool` | 是 | 是否为默认服务器 |

### 约束

- `url` 不能为空
- `name` 可为空，为空时界面显示 `url`
- `username` 可为空
- `password` 可为空
- 同一时刻最多只能有一个默认服务器

### Dart 定义

```dart
class Server {
  const Server({
    required this.url,
    this.name,
    this.username,
    this.password,
    this.isDefault = false,
  });

  final String url;
  final String? name;
  final String? username;
  final String? password;
  final bool isDefault;
}
```

### ServersState

controller 管理的聚合状态。

| 字段 | 类型 | 说明 |
|---|---|---|
| `servers` | `List<Server>` | 服务器列表 |
| `selectedServer` | `Server?` | 当前选中服务器 |
| `httpClient` | `OpencodeHttpClient?` | 当前选中服务器的 HTTP 客户端 |
| `sseClient` | `OpencodeSseClient?` | 当前选中服务器的 SSE 客户端 |

### Dart 定义

```dart
class ServersState {
  const ServersState({
    this.servers = const [],
    this.selectedServer,
    this.httpClient,
    this.sseClient,
  });

  final List<Server> servers;
  final Server? selectedServer;
  final OpencodeHttpClient? httpClient;
  final OpencodeSseClient? sseClient;
}
```

### ServerHealthStatus

表示服务器的健康检测结果，运行时状态，不持久化。

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `serverUrl` | `String` | 是 | 对应服务器的 url |
| `healthy` | `bool` | 是 | 是否健康 |
| `version` | `String?` | 否 | 服务器版本号，健康时有值 |
| `error` | `String?` | 否 | 错误信息，不健康时有值 |
| `checkedAt` | `DateTime` | 是 | 最近一次检测时间 |

### Dart 定义

```dart
class ServerHealthStatus {
  const ServerHealthStatus({
    required this.serverUrl,
    required this.healthy,
    this.version,
    this.error,
    required this.checkedAt,
  });

  final String serverUrl;
  final bool healthy;
  final String? version;
  final String? error;
  final DateTime checkedAt;
}
```

## 2. Storage

### 作用

`data/storage/servers_storage.dart` 负责本地持久化，不负责请求服务器。

### 保存内容

- 服务器列表（含默认服务器标记）

### 职责

- 读取所有服务器
- 保存所有服务器
- 更新默认服务器

### 方法

```dart
class ServersStorage {
  List<Server> loadServers();

  Future<void> saveServers(List<Server> servers);

  Future<void> updateDefault(String url);
}
```

### 说明

- 默认服务器信息保存在服务器列表里，通过 `isDefault` 表示
- `updateDefault` 内部：load → 清除旧 default → 将目标 url 的 `isDefault` 设为 true → save
- "当前选中服务器" 是运行时 UI 状态，由 controller / provider 管理，不持久化
- 启动时从列表中取 `isDefault == true` 的服务器作为当前选中
- storage 只负责读写，不负责默认服务器唯一性校验，这个规则由 controller 保证

## 3. API

### 作用

`data/api/health_api.dart` 负责服务器健康检查请求，不负责本地保存。

### 接口

#### GET /global/health

检查 opencode 服务器是否可用。本质上也是验证 Basic Auth 凭证是否正确。

| 项目 | 说明 |
|---|---|
| 路径 | `/global/health` |
| 方法 | `GET` |
| 认证 | Basic Auth（`username` + `password`） |

#### 响应

##### 200 OK

```json
{
  "healthy": true,
  "version": "0.0.3"
}
```

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `healthy` | `bool` | 是 | 固定为 `true` |
| `version` | `String` | 是 | 服务器版本号 |

##### 非 200

认证失败、网络不可达、服务器异常等情况，均视为不健康。

### Dart 定义

```dart
class HealthApi {
  HealthApi(this._client);

  final OpencodeHttpClient _client;

  /// 检查服务器健康状态
  /// 成功返回版本号，失败抛异常
  Future<String> check();
}
```

### 说明

- 通过 `core/network` 的 `createHttpClient(NetworkConfig)` 创建 `OpencodeHttpClient`，注入到 `HealthApi`
- `NetworkConfig` 由 `Server` 的 `url`、`username`、`password` 构建，Basic Auth 由网络层自动处理
- `HealthApi` 只负责调用 `_client.get('/global/health')` 并解析响应
- 成功时返回 `version` 字符串
- 任何非 200 响应或网络异常均抛出异常，由 `healthStatusProvider` 转换为不健康状态

### 定时健康检测

`healthStatusProvider` 负责对当前选中服务器进行定时健康检测：

- 选中服务器后立即执行一次健康检查
- 之后每 30 秒轮询一次
- 切换服务器时取消旧定时器，重新开始
- 取消选中时停止定时器
- 检测结果更新到 `ServerHealthStatus`，UI 通过 provider 监听

## 4. Controller

### 作用

`controller.dart` 是 servers feature 的核心业务逻辑，使用 `Notifier<ServersState>` 管理聚合状态。

### 依赖

- `ServersStorage`：读写服务器列表
- `createHttpClient(NetworkConfig)`：按当前选中服务器创建 HTTP client
- `createSseClient(NetworkConfig)`：按当前选中服务器创建 SSE client

### 状态不变量

- `state.servers` 中最多一个 `isDefault == true`
- `state.selectedServer == null` 时，`httpClient` 和 `sseClient` 必须都为 `null`
- `state.selectedServer != null` 时，`httpClient` 和 `sseClient` 必须与该 server 的配置一致
- controller 只管理列表与选中态，不管理健康检查定时器

### 对外方法（建议）

- `build()`：初始化列表，恢复默认选中，并创建对应 client
- `addServer(Server server)`：新增服务器；若同 url 已存在则拒绝
- `updateServer(String originalUrl, Server next)`：编辑服务器；支持 url 变更
- `removeServer(String url)`：删除服务器；若删的是选中项则清空选中
- `setDefault(String url)`：将目标设为默认，并清除其他默认
- `selectServer(String url)`：切换当前选中服务器并重建 client
- `clearSelection()`：取消选中并清理 client

### Dart 定义

```dart
class ServersController extends Notifier<ServersState> {
  @override
  ServersState build() {
    // 从 storage 加载列表，自动选中 isDefault == true 的服务器
  }

  /// 新增服务器并持久化
  Future<void> addServer(Server server);

  /// 更新服务器并持久化，支持修改 url/name/认证信息
  Future<void> updateServer(String originalUrl, Server server);

  /// 删除服务器并持久化，如果删除的是选中服务器则清除选中
  Future<void> removeServer(String url);

  /// 设为默认服务器并持久化
  Future<void> setDefault(String url);

  /// 选中服务器，创建 http_client 和 sse_client
  void selectServer(String url);

  /// 取消选中，清除 client
  void clearSelection();
}
```

### 方法行为细节

1. `build()`
- 从 `ServersStorage.loadServers()` 读取列表
- 若存在多个 default，按列表顺序保留第一个并纠正后持久化
- `selectedServer` 默认取 default；无 default 则为 `null`
- 若有 `selectedServer`，立即创建 client

2. `addServer(server)`
- `url` 去空格后不能为空，否则抛 `ArgumentError`
- 若存在同 url（建议忽略大小写 + 去末尾 `/` 后比较），抛 `StateError`
- 若 `server.isDefault == true`，先清空旧 default，再插入新项
- 更新内存状态并持久化
- 若当前无选中且新项为 default，可自动选中新项并创建 client

3. `updateServer(originalUrl, next)`
- 若 `originalUrl` 不存在，抛 `StateError`
- 若 `next.url` 与其他项冲突（排除自身），抛 `StateError`
- 保持 default 唯一性
- 若被编辑项正好是 `selectedServer`，更新选中项并重建 client
- 更新内存状态并持久化

4. `removeServer(url)`
- 若目标不存在，直接返回（幂等）
- 删除后若目标是 `selectedServer`，执行 `clearSelection()`
- 删除后若列表不为空且无 default，可选择保留“无默认”状态，不自动指定 default
- 更新内存状态并持久化

5. `setDefault(url)`
- 若目标不存在，抛 `StateError`
- 将目标置为 default，其余置为非 default
- 更新内存状态并持久化

6. `selectServer(url)`
- 若目标不存在，抛 `StateError`
- 若目标已是当前选中，直接返回（幂等）
- 基于目标 server 构造 `NetworkConfig`，并创建 `httpClient` / `sseClient`
- 一次性更新 `selectedServer` + client，避免中间态

7. `clearSelection()`
- 将 `selectedServer`、`httpClient`、`sseClient` 统一置空
- 不影响已保存列表和默认服务器

### 失败处理约定

- 参数非法：抛 `ArgumentError`
- 业务规则冲突（重复 url、目标不存在等）：抛 `StateError`
- storage 持久化异常：向上抛出，由 UI/provider 显示错误提示

### 关键实现提示

- 建议新增私有辅助方法 `_normalizeUrl(String url)`，统一去尾 `/` 与 trim 规则
- 建议新增私有方法 `_buildClients(Server server)`，集中构造 `NetworkConfig` 与 client
- controller 不负责健康检测定时器，定时器由 `healthStatusProvider` 管理

## 5. Providers

### 作用

`providers.dart` 对外暴露 servers feature 的所有状态，供 UI 和其他 feature 使用。

### Provider 列表

```dart
/// controller 主 provider
final serversControllerProvider =
    NotifierProvider<ServersController, ServersState>(ServersController.new);

/// 服务器列表
final serversProvider = Provider<List<Server>>((ref) {
  return ref.watch(serversControllerProvider).servers;
});

/// 当前选中服务器
final selectedServerProvider = Provider<Server?>((ref) {
  return ref.watch(serversControllerProvider).selectedServer;
});

/// 当前 HTTP 客户端，其他 feature 通过此 provider 获取
final httpClientProvider = Provider<OpencodeHttpClient?>((ref) {
  return ref.watch(serversControllerProvider).httpClient;
});

/// 当前 SSE 客户端
final sseClientProvider = Provider<OpencodeSseClient?>((ref) {
  return ref.watch(serversControllerProvider).sseClient;
});

/// 健康状态，定时轮询当前选中服务器
final healthStatusProvider = Provider<ServerHealthStatus?>((ref) {
  // 监听 selectedServer 和 httpClient
  // 选中时立即检查一次，之后每 30 秒轮询
  // ref.onDispose 清除定时器
  // 切换服务器时自动重建
});
```

### 说明

- 派生 provider 均为只读 `Provider`，从 `serversControllerProvider` 的 state 中取值
- `healthStatusProvider` 是副作用 provider，内部管理 `Timer.periodic`，通过 `ref.onDispose` 自动清理
- `healthStatusProvider` 监听 `selectedServerProvider`，选中服务器变化时自动重建（旧定时器销毁，新定时器启动）
- 其他 feature 使用 client 示例：`ref.watch(httpClientProvider)` 获取当前连接的 client

## 6. 页面设计文档

页面布局、组件拆分与交互流程已拆分到独立文档：

- `docs/servers/SERVERS_UI_INTERACTION_DESIGN.md`

补充约束：

- 搜索框位于去掉 AppBar 后内容区的约 `1/3` 高度（等价于距底部约 `2/3` 高度）
- 搜索框固定不动，不参与列表滚动
- 列表、空状态和搜索结果状态都从搜索框下方开始布局
