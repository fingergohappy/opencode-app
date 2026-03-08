# OpenCode Flutter App

这是从 Android Kotlin/Compose 项目转换而来的 Flutter 应用。

## 项目结构

```
lib/
├── data/                    # 数据层
│   ├── server_store.dart   # 服务器配置存储
│   └── settings_store.dart # 设置存储
├── models/                  # 数据模型
│   ├── project.dart        # 项目模型
│   ├── server_config.dart  # 服务器配置模型
│   └── settings.dart       # 设置模型（主题、语言等）
├── network/                 # 网络层
│   ├── api.dart            # API 接口
│   └── opencode_client.dart # HTTP 客户端
├── ui/
│   └── screens/            # 页面
│       ├── server_list_screen.dart    # 服务器列表
│       ├── project_list_screen.dart   # 项目列表
│       ├── project_detail_screen.dart # 项目详情
│       └── settings_screen.dart       # 设置页面
├── router.dart             # 路由配置
└── main.dart              # 应用入口
```

## 主要功能

- ✅ 服务器管理（添加、删除、选择）
- ✅ 项目列表展示
- ✅ 项目详情查看
- ✅ 设置页面（主题模式、主题预设、语言）
- ✅ 本地数据持久化
- ✅ 网络请求

## 依赖包

- `http`: HTTP 网络请求
- `shared_preferences`: 本地数据存储
- `provider`: 状态管理
- `go_router`: 路由导航
- `intl`: 国际化支持

## 运行项目

```bash
# 安装依赖
flutter pub get

# 运行应用
flutter run

# 构建 APK
flutter build apk

# 构建 iOS
flutter build ios
```

## 转换说明

### 已完成
1. ✅ 数据模型层（Kotlin data class → Dart class）
2. ✅ 本地存储（SharedPreferences → shared_preferences）
3. ✅ 网络层（Ktor → http）
4. ✅ 路由系统（Jetpack Navigation → go_router）
5. ✅ 基础 UI 页面（Compose → Flutter Widget）

### 待完善
- 主题系统（需要实现完整的主题切换）
- 国际化（需要实现多语言支持）
- 项目详情页面的完整功能
- 更多 API 接口的实现

## 与 Android 版本的差异

- 使用 Flutter 的 Material Design 组件替代 Compose
- 使用 `go_router` 替代 Jetpack Navigation
- 使用 `shared_preferences` 替代 Android SharedPreferences
- 使用 `http` 包替代 Ktor 客户端
- 简化了 UI 实现，保留核心功能
