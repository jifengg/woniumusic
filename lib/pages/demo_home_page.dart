import 'package:flutter/material.dart';
import 'package:woniu_music/pages/simple-widgets/simple_dialog_demo_page.dart';
import 'package:woniu_music/pages/simple-widgets/simple_table_view_demo_page.dart';

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主页'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleTableViewDemoPage(),
                ),
              );
            },
            child: const Text('SimpleTableView Demo'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleDialogDemoPage(),
                ),
              );
            },
            child: const Text('Simple Dialog Demo'),
          ),
        ],
      ),
    );
  }
}
