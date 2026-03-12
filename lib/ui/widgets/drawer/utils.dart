import 'package:flutter/material.dart';
import '../../../models/project.dart';
import '../../../models/server_config.dart';

/// 取项目图标首字母时，优先用后端返回的 override 字段。
String getProjectInitial(Project project) {
  final iconOverride = project.icon?.override;
  if (iconOverride != null && iconOverride.isNotEmpty) {
    return iconOverride[0].toUpperCase();
  }
  final name = project.worktree == '/'
      ? 'Global'
      : project.worktree.split('/').last;
  return name.isNotEmpty ? name[0].toUpperCase() : '?';
}

/// 把 worktree 转成更适合展示的项目名。
String getProjectName(Project project) {
  return project.worktree == '/' ? 'Global' : project.worktree.split('/').last;
}

/// 项目图标支持后端自定义颜色；解析失败时退回默认主题色。
Color getProjectColor(Project project, Color defaultColor) {
  final hexColor = project.icon?.color;
  if (hexColor != null && hexColor.startsWith('#')) {
    try {
      return Color(int.parse(hexColor.substring(1), radix: 16) + 0xFF000000);
    } catch (_) {}
  }
  return defaultColor;
}

String getServerInitial(ServerConfig server) {
  return server.name.isNotEmpty ? server.name[0].toUpperCase() : 'S';
}
