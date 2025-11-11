import 'package:flutter/material.dart';

class ExpandableDetailsText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final int maxLines;
  final VoidCallback onShowMore;
  final TextAlign textAlign;

  const ExpandableDetailsText({
    super.key,
    required this.text,
    required this.textStyle,
    required this.onShowMore,
    this.maxLines = 3,
    this.textAlign = TextAlign.center,
  });

  bool _isTextOverflowing(
    String text,
    TextStyle style,
    double maxWidth,
    int maxLines,
    TextDirection textDirection,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: textDirection,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isOverflowing = _isTextOverflowing(
          text,
          textStyle,
          constraints.maxWidth,
          maxLines,
          Directionality.of(context),
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: textStyle,
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            if (isOverflowing)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: TextButton(
                  onPressed: onShowMore,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Voir plus',
                    style: TextStyle(
                      color: textStyle.color?.withValues(alpha: 0.9) ??
                          theme.colorScheme.onSurface.withValues(alpha: 0.9),
                      fontSize: textStyle.fontSize,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

