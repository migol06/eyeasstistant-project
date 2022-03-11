import 'package:flutter/material.dart';

import 'constants/constants.dart';

enum ESTextSize {
  xxSmall,
  xSmall,
  small,
  medium,
  large,
  xLarge,
  xxLarge,
  xxxLarge
}

enum ESTextWeight { light, normal, semiBold, bold, extraBold }

enum ESTextStyle { normal, italic }

class ESText extends StatelessWidget {
  final String data;
  final Color color;
  final TextAlign textAlign;
  final ESTextWeight weight;
  final ESTextSize size;
  final ESTextStyle style;
  final int? maxLines;

  const ESText(this.data,
      {Key? key,
      this.color = ESColor.scorpion,
      this.textAlign = TextAlign.left,
      this.weight = ESTextWeight.normal,
      this.size = ESTextSize.medium,
      this.style = ESTextStyle.normal,
      this.maxLines})
      : super(key: key);

  const ESText.heading(this.data)
      : color = ESColor.plantation,
        textAlign = TextAlign.left,
        weight = ESTextWeight.bold,
        size = ESTextSize.xxLarge,
        style = ESTextStyle.normal,
        maxLines = null;

  const ESText.title(this.data)
      : color = ESColor.plantation,
        textAlign = TextAlign.left,
        weight = ESTextWeight.bold,
        size = ESTextSize.xLarge,
        style = ESTextStyle.normal,
        maxLines = null;

  const ESText.subheading(this.data)
      : color = ESColor.scorpion,
        textAlign = TextAlign.left,
        weight = ESTextWeight.bold,
        size = ESTextSize.large,
        style = ESTextStyle.normal,
        maxLines = null;

  const ESText.body1Light(this.data)
      : color = ESColor.scorpion,
        textAlign = TextAlign.left,
        weight = ESTextWeight.light,
        size = ESTextSize.medium,
        style = ESTextStyle.normal,
        maxLines = null;

  const ESText.body1(this.data)
      : color = ESColor.scorpion,
        textAlign = TextAlign.left,
        weight = ESTextWeight.normal,
        size = ESTextSize.medium,
        style = ESTextStyle.normal,
        maxLines = null;

  const ESText.body1SemiBold(this.data)
      : color = ESColor.scorpion,
        textAlign = TextAlign.left,
        weight = ESTextWeight.semiBold,
        size = ESTextSize.medium,
        style = ESTextStyle.normal,
        maxLines = null;

  const ESText.body1Bold(this.data)
      : color = ESColor.scorpion,
        textAlign = TextAlign.left,
        weight = ESTextWeight.bold,
        size = ESTextSize.medium,
        style = ESTextStyle.normal,
        maxLines = null;

  const ESText.body2Light(this.data)
      : color = ESColor.scorpion,
        textAlign = TextAlign.left,
        weight = ESTextWeight.light,
        size = ESTextSize.xSmall,
        style = ESTextStyle.normal,
        maxLines = null;

  const ESText.body2(this.data)
      : color = ESColor.scorpion,
        textAlign = TextAlign.left,
        weight = ESTextWeight.normal,
        size = ESTextSize.xSmall,
        style = ESTextStyle.normal,
        maxLines = null;

  @override
  Widget build(BuildContext context) {
    return Text(data,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow:
            maxLines != null ? TextOverflow.ellipsis : TextOverflow.visible,
        style: TextStyle(
            color: color,
            fontWeight: _getWeight(weight),
            fontSize: _getSize(size),
            fontStyle: _getStyle(style)));
  }

  FontWeight _getWeight(ESTextWeight weight) {
    switch (weight) {
      case ESTextWeight.light:
        return ESFontWeight.light;
      case ESTextWeight.normal:
        return ESFontWeight.normal;
      case ESTextWeight.semiBold:
        return ESFontWeight.semiBold;
      case ESTextWeight.bold:
        return ESFontWeight.bold;
      case ESTextWeight.extraBold:
        return ESFontWeight.extraBold;
    }
  }

  double _getSize(ESTextSize size) {
    switch (size) {
      case ESTextSize.xxSmall:
        return ESFontSize.xxSmall;
      case ESTextSize.xSmall:
        return ESFontSize.xSmall;
      case ESTextSize.small:
        return ESFontSize.small;
      case ESTextSize.medium:
        return ESFontSize.medium;
      case ESTextSize.large:
        return ESFontSize.large;
      case ESTextSize.xLarge:
        return ESFontSize.xLarge;
      case ESTextSize.xxLarge:
        return ESFontSize.xxLarge;
      case ESTextSize.xxxLarge:
        return ESFontSize.xxxLarge;
    }
  }

  FontStyle _getStyle(ESTextStyle style) {
    switch (style) {
      case ESTextStyle.normal:
        return FontStyle.normal;
      case ESTextStyle.italic:
        return FontStyle.italic;
    }
  }
}
