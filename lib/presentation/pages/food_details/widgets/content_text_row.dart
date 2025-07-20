import 'package:flutter/material.dart';
import 'package:food_ai/core/extensions/spacing.dart';
import 'package:food_ai/core/theme/color_schemes.g.dart';

class ContentTextRow extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  final String value;
  final double? height;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final bool? showBorder;

  const ContentTextRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.value,
    this.showBorder = true,
    this.height,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color,
        border: showBorder == true ? Border(bottom: BorderSide(color: CustomColors.dividerColor)) : null,
      ),
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                icon,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              HSpace(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CustomColors.textPrimaryColor,
                        ),
                  ),
                  Text(
                    subTitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: CustomColors.textPrimaryColor,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: CustomColors.textPrimaryColor,
                ),
          ),
        ],
      ),
    );
  }
}
