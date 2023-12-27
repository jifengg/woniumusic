import 'package:flutter/material.dart';
import 'package:flutter_template/simple-widgets/simple_dialog.dart';

class SimpleDialogDemoPage extends StatefulWidget {
  const SimpleDialogDemoPage({super.key});

  @override
  State<SimpleDialogDemoPage> createState() => _SimpleDialogDemoPageState();
}

class _SimpleDialogDemoPageState extends State<SimpleDialogDemoPage> {
  bool confirmDialogResult = false;
  String? promptDialogResult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Dialog Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getBody(),
      ),
    );
  }

  Widget getBody() {
    return ListView(
      children: [
        const Text('提示框 alert'),
        getAlertDemoPanel(),
        const Divider(height: 40),
        const Text('确认框 confirm'),
        getConfirmDemoPanel(),
        Text('获得的确认框返回值：$confirmDialogResult'),
        const Divider(height: 40),
        const Text('输入框 prompt'),
        getPromptDemoPanel(),
        Text('获得的输入框返回值：${promptDialogResult ?? '<无>'}'),
      ],
    );
  }

  Widget getAlertDemoPanel() {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () async {
            await alert('提示的信息', context: context);
          },
          child: const Text('默认'),
        ),
        ElevatedButton(
          onPressed: () async {
            await alert(const Icon(Icons.home, size: 80), context: context);
          },
          child: const Text('提示widget'),
        ),
        ElevatedButton(
          onPressed: () async {
            await alert(
              '定义的消息内容，比如：\n记得按时吃饭\n记得打电话回家',
              context: context,
              title: '一些唠叨',
              okText: '俺晓得了',
              icon: const Icon(Icons.favorite, color: Colors.red),
              barrierDismissible: true,
            );
          },
          child: const Text('自定义'),
        ),
        ElevatedButton(
          onPressed: () async {
            await alert(
              '没有按钮，点击空白处关闭',
              barrierDismissible: true,
              okText: null,
              context: context,
            );
          },
          child: const Text('隐藏按钮'),
        ),
      ],
    );
  }

  Widget getConfirmDemoPanel() {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () async {
            confirmDialogResult =
                await confirm('需要确认的信息，如：你确定18岁了吗？', context: context);
            setState(() {});
          },
          child: const Text('默认'),
        ),
        ElevatedButton(
          onPressed: () async {
            confirmDialogResult = await confirm(
                const Icon(Icons.home, size: 80),
                context: context);
            setState(() {});
          },
          child: const Text('显示widget'),
        ),
        ElevatedButton(
          onPressed: () async {
            confirmDialogResult = await confirm(
              '定义的消息内容，比如：\n记得按时吃饭\n记得打电话回家',
              context: context,
              title: '一些唠叨',
              cancelText: '我偏不',
              okText: '俺晓得了',
              icon: const Icon(Icons.favorite, color: Colors.red),
              barrierDismissible: true,
            );
            setState(() {});
          },
          child: const Text('自定义'),
        ),
      ],
    );
  }

  Widget getPromptDemoPanel() {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () async {
            promptDialogResult = await prompt(context: context);
            setState(() {});
          },
          child: const Text('默认'),
        ),
        ElevatedButton(
          onPressed: () async {
            promptDialogResult = await prompt(
                context: context, initValue: promptDialogResult ?? '默认初始值');
            setState(() {});
          },
          child: const Text('初始值'),
        ),
        ElevatedButton(
          onPressed: () async {
            promptDialogResult = await prompt(
              context: context,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '不能为空';
                }
                return null;
              },
            );
            setState(() {});
          },
          child: const Text('校验：非空'),
        ),
        ElevatedButton(
          onPressed: () async {
            promptDialogResult = await prompt(
              tips: const Icon(Icons.home, size: 80),
              context: context,
            );
            setState(() {});
          },
          child: const Text('显示widget'),
        ),
        ElevatedButton(
          onPressed: () async {
            promptDialogResult = await prompt(
              context: context,
              tips: '你好\n请告诉我你的微信号码：',
              title: '有人来搭讪',
              cancelText: '不给',
              okText: '给你',
              icon: const Icon(Icons.wechat, color: Colors.green),
              barrierDismissible: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '填了再给呀(*^_^*)';
                }
                if (value.length < 3) {
                  return '长度不对哦，要3个字符以上';
                }
                return null;
              },
            );
            setState(() {});
            if (promptDialogResult == null) {
              (() => alert('哎呀，没要到微信啊', title: '嘲笑', context: context))();
            }
          },
          child: const Text('自定义'),
        ),
      ],
    );
  }
}
