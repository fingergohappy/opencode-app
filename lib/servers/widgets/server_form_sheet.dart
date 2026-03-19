import 'package:flutter/material.dart';

import '../model.dart';

/// 新增 / 编辑服务器的底部弹窗表单
///
/// [initialValue] 为 null 时表示新增，否则为编辑
class ServerFormSheet extends StatefulWidget {
  const ServerFormSheet({super.key, this.initialValue});

  final Server? initialValue;

  /// 打开表单弹窗，返回用户提交的 [Server]，取消返回 null
  static Future<Server?> show(
    BuildContext context, {
    Server? initialValue,
  }) {
    return showModalBottomSheet<Server>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ServerFormSheet(initialValue: initialValue),
    );
  }

  @override
  State<ServerFormSheet> createState() => _ServerFormSheetState();
}

class _ServerFormSheetState extends State<ServerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _passwordCtrl;
  late bool _isDefault;
  bool _obscurePassword = true;

  bool get _isEdit => widget.initialValue != null;

  @override
  void initState() {
    super.initState();
    final s = widget.initialValue;
    _urlCtrl = TextEditingController(text: s?.url ?? '');
    _nameCtrl = TextEditingController(text: s?.name ?? '');
    _usernameCtrl = TextEditingController(text: s?.username ?? '');
    _passwordCtrl = TextEditingController(text: s?.password ?? '');
    _isDefault = s?.isDefault ?? false;
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final server = Server(
      url: _urlCtrl.text.trim(),
      name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
      username:
          _usernameCtrl.text.trim().isEmpty ? null : _usernameCtrl.text.trim(),
      password:
          _passwordCtrl.text.isEmpty ? null : _passwordCtrl.text,
      isDefault: _isDefault,
    );
    Navigator.of(context).pop(server);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 键盘弹起时内容上移
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 标题行
            Row(
              children: [
                Text(
                  _isEdit ? '编辑服务器' : '新增服务器',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // URL（必填）
            TextFormField(
              controller: _urlCtrl,
              decoration: const InputDecoration(
                labelText: '服务器地址 *',
                hintText: 'http://localhost:4096',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              autocorrect: false,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '地址不能为空';
                final trimmed = v.trim();
                if (!trimmed.startsWith('http://') &&
                    !trimmed.startsWith('https://')) {
                  return '地址须以 http:// 或 https:// 开头';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // 名称（可选）
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: '名称（可选）',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // 用户名（可选）
            TextFormField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(
                labelText: '用户名（可选）',
                border: OutlineInputBorder(),
              ),
              autocorrect: false,
            ),
            const SizedBox(height: 12),

            // 密码（可选）
            TextFormField(
              controller: _passwordCtrl,
              decoration: InputDecoration(
                labelText: '密码（可选）',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 4),

            // 设为默认
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('设为默认服务器'),
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
            ),
            const SizedBox(height: 8),

            // 提交按钮
            FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(_isEdit ? '保存' : '添加'),
            ),
          ],
        ),
      ),
    );
  }
}
