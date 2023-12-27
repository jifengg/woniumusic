
# 简化代码的一些常用组件

Flutter组件使用推荐嵌套方式，但有时候我们为了统一UI风格，经常需要设置一些公共的属性，比如字体、颜色、间距等，这时候我们就可以使用一些组件来简化代码。

此类组件均存放于`lib/simple-widgets`中。

## 简单的描述列表SimpleTableView

使用`Table`可以实现以下的表格形式：

|          |      |
| -------- | ---- |
| 姓名     | 张三 |
| 年龄     | 35   |
| 其他信息 | ...  |
|          |      |

但是`Table`组件的实现方式比较繁琐，所以这里提供了一个`SimpleTableView`组件，可以实现上面的表格形式，并简化代码。

使用方法见 [simple_table_view_demo_page.dart](../lib/pages/simple-widgets/simple_table_view_demo_page.dart);

## 常用的弹框 Simple Dialog

在[simple-widgets/simple_dialog.dart](../lib/simple-widgets/simple_dialog.dart)中，实现了多个常用的弹框方法。

| 方法    | 作用       |
| ------- | ---------- |
| alert   | 消息展示框 |
| confirm | 确认框     |
| prompt  | 输入框     |


使用方法见 [simple_dialog_demo_page.dart](../lib/pages/simple-widgets/simple_dialog_demo_page.dart);
