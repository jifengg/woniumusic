import 'package:flutter/material.dart';

/// 一个简单的双列表格内容展示组件
class SimpleTableView extends StatelessWidget {
  /// 要显示的数据
  final List<SimpleTableRowData> data;

  /// 标签文本的对齐方式
  final TextAlign labelTextAlign;

  /// 标签文本的宽度设置
  final TableColumnWidth? labelTableColumnWidth;
  final EdgeInsets? cellPadding;

  const SimpleTableView({
    super.key,
    required this.data,
    this.labelTextAlign = TextAlign.end,
    this.cellPadding,
    this.labelTableColumnWidth,
  });

  @override
  Widget build(BuildContext context) {
    var cellPadding = this.cellPadding ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    return Table(
      columnWidths: {
        0: labelTableColumnWidth ??
            const MinColumnWidth(IntrinsicColumnWidth(), FixedColumnWidth(150)),
        // 1: IntrinsicColumnWidth(),
      },
      // border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: data
          .map((e) => TableRow(children: [
                TableCell(
                    child: Padding(
                        padding: cellPadding,
                        child: Text(e.label, textAlign: labelTextAlign))),
                TableCell(
                    child: e.content is String
                        ? Text(e.content as String)
                        : (e.content as Widget))
              ]))
          .toList(),
    );
  }
}

class SimpleTableRowData {
  /// 标签文本
  String label;

  /// 要显示的内容，支持类型：String，Widget
  dynamic content;
  SimpleTableRowData(this.label, this.content)
      : assert(content is String || content is Widget);
}
