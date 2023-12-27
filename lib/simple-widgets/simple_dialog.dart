import 'package:flutter/material.dart';

/// 显示一个简单的弹框，只有一个“确定”按钮可以关闭对话框，无返回值；
///
/// [content] 要显示的内容，支持类型：String，Widget；
///
/// [barrierDismissible] 决定是否点击空白处可以关闭对话框；
///
/// [title] 设置对话框的标题；
///
/// [okText] 设置“确定”按钮的文本，设置为null时则不显示该按钮；
///
/// [icon] 设置标题前面的图标，可以是Icon或其他任意Widget；
Future alert(
  dynamic content, {
  required BuildContext context,
  String title = '提示',
  String? okText = '确定',
  bool barrierDismissible = false,
  Widget? icon = const Icon(Icons.info_outline),
}) {
  assert(content is String || content is Widget);
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AlertDialog.adaptive(
      title: Row(
        children: [
          if (icon != null) icon,
          if (icon != null) const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: content is String ? Text(content) : content as Widget,
      actions: [
        if (okText != null)
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(okText),
          ),
      ],
    ),
  );
}

/// 显示一个简单的确认框，可以选择“确定”或“取消”，返回true或false；
///
/// [content] 要显示的内容，支持类型：String，Widget；
///
/// [barrierDismissible] 决定是否点击空白处可以关闭对话框，点击空白处关闭时返回false；
///
/// [title] 设置对话框的标题；
///
/// [cancelText] 设置“取消”按钮的文本；
///
/// [okText] 设置“确定”按钮的文本；
///
/// [icon] 设置标题前面的图标，可以是Icon或其他任意Widget；
Future<bool> confirm(
  dynamic content, {
  required BuildContext context,
  String title = '请确认',
  String cancelText = '取消',
  String okText = '确定',
  bool barrierDismissible = false,
  Widget? icon = const Icon(Icons.help_outline),
}) {
  assert(content is String || content is Widget);
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AlertDialog.adaptive(
      title: Row(
        children: [
          if (icon != null) icon,
          if (icon != null) const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: content is String ? Text(content) : content as Widget,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(okText),
        ),
      ],
    ),
  ).then((value) => value == true);
}

/// 显示一个简单的输入框，返回String?；
///
/// [tips] 要显示的提示内容，支持类型：String，Widget；
///
/// [barrierDismissible] 决定是否点击空白处可以关闭对话框，点击空白处关闭时返回false；
///
/// [title] 设置对话框的标题；
///
/// [cancelText] 设置“取消”按钮的文本；
///
/// [okText] 设置“确定”按钮的文本；
///
/// [initValue] 输入框中的初始值；
///
/// [minLines] 输入框的最小行数；
///
/// [maxLines] 输入框的最大行数；
///
/// [validator] 输入框中的校验方法；
///
/// [icon] 设置标题前面的图标，可以是Icon或其他任意Widget；
///
Future<String?> prompt({
  required BuildContext context,
  String title = '请输入',
  dynamic tips,
  String? initValue,
  String cancelText = '取消',
  String okText = '确定',
  int minLines = 1,
  int? maxLines,
  bool barrierDismissible = false,
  Widget? icon = const Icon(Icons.edit_outlined),
  FormFieldValidator<String>? validator,
}) {
  assert(tips == null || tips is String || tips is Widget);
  var key = GlobalKey();
  return showDialog<String?>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => AlertDialog.adaptive(
      title: Row(
        children: [
          if (icon != null) icon,
          if (icon != null) const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tips != null) tips is String ? Text(tips) : tips as Widget,
            Form(
              key: key,
              child: TextFormField(
                minLines: minLines,
                maxLines: maxLines,
                validator: validator,
                initialValue: initValue,
                onSaved: (newValue) {
                  initValue = newValue;
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            var form = (key.currentState as FormState);
            var validate = form.validate();
            if (validate) {
              form.save();
              Navigator.pop(context, initValue);
            }
          },
          child: Text(okText),
        ),
      ],
    ),
  );
}
