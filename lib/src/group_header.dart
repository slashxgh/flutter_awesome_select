import 'package:flutter/widgets.dart';
import 'model/group_style.dart';

/// Choice group header widget
class S2GroupHeader extends StatelessWidget {
  /// Choice group title
  final Widget title;

  /// Trailing widget
  final Widget? trailing;

  /// The header Style
  final S2GroupHeaderStyle? style;

  /// Default constructor
  const S2GroupHeader({
    super.key,
    required this.title,
    this.trailing,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: style!.height,
      color: style!.backgroundColor,
      padding: style!.padding,
      child: Row(
        crossAxisAlignment:
            style!.crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment:
            style!.mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
        children: [
          title,
          trailing,
        ].whereType<Widget>().toList(),
      ),
    );
  }
}
