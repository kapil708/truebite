import 'package:flutter/material.dart';
import 'package:food_ai/core/extensions/spacing.dart';
import 'package:food_ai/core/theme/color_schemes.g.dart';

class HeaderTextRow extends StatelessWidget {
  final String title;
  final String tooltip;
  final String? description;
  final Widget? trailing;
  final double? height;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const HeaderTextRow({
    super.key,
    required this.title,
    required this.tooltip,
    this.description,
    this.trailing,
    this.height,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      color: color,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CustomColors.textPrimaryColor,
                    ),
              ),
              HSpace(4),
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                showDuration: Duration(seconds: 20),
                message: tooltip,
                child: Icon(Icons.info, color: CustomColors.iconPrimaryColor),
              ),
              Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          if (description != null)
            Text(
              description!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: CustomColors.textSecondaryColor,
                  ),
            ),
        ],
      ),
    );
  }
}
