import 'package:flutter/material.dart';
import 'package:flutter_template/simple-widgets/simple_table_view.dart';

class SimpleTableViewDemoPage extends StatefulWidget {
  const SimpleTableViewDemoPage({super.key});

  @override
  State<SimpleTableViewDemoPage> createState() =>
      _SimpleTableViewDemoPageState();
}

class _SimpleTableViewDemoPageState extends State<SimpleTableViewDemoPage> {
  TextAlign labelTextAlign = TextAlign.end;
  EdgeInsets? cellPadding;
  TableColumnWidth? labelTableColumnWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SimpleTableView Demo'),
        centerTitle: true,
      ),
      body: getBody(),
    );
  }

  getBody() {
    return ListView(
      children: [
        const Text('预览效果'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimpleTableView(
              labelTableColumnWidth: labelTableColumnWidth,
              labelTextAlign: labelTextAlign,
              cellPadding: cellPadding,
              data: [
                SimpleTableRowData('名称', '张三'),
                SimpleTableRowData(
                  '头像',
                  const Row(children: [Icon(Icons.person, size: 44)]),
                ),
                SimpleTableRowData('年龄', '35'),
                SimpleTableRowData(
                  '人物介绍',
                  '张三，中国人最耳熟能详的名字。张三可能真有其人，但更多时候与李四、王五一起指代不特定的某个人，揶揄或者概括常用。',
                ),
              ],
            ),
          ),
        ),
        const Text('修改配置'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SimpleTableView(
              cellPadding: const EdgeInsets.all(2),
              labelTableColumnWidth: const IntrinsicColumnWidth(),
              data: [
                SimpleTableRowData(
                  'labelTextAlign：',
                  DropdownButton(
                    value: labelTextAlign,
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          labelTextAlign = value;
                        });
                      }
                    },
                    items: TextAlign.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SimpleTableRowData(
                  'labelTableColumnWidth：',
                  DropdownButton(
                    value: labelTableColumnWidth,
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          labelTableColumnWidth = value;
                        });
                      }
                    },
                    items: <TableColumnWidth>[
                      const FlexColumnWidth(),
                      const IntrinsicColumnWidth(),
                      const MaxColumnWidth(
                          FixedColumnWidth(120), IntrinsicColumnWidth()),
                    ]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.toString()),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SimpleTableRowData(
                  'cellPadding：',
                  DropdownButton(
                    value: cellPadding?.left,
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          cellPadding = EdgeInsets.all(value);
                        });
                      }
                    },
                    items: <double>[0, 4, 8, 12, 24]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.toString()),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
