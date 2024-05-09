import 'package:flutter/material.dart';
import 'package:score_card/theme/theme_helper.dart';

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Display text style
  static get displayMedium40 => theme.textTheme.displayMedium!.copyWith(
        fontSize: 40,
      );
  static get displayMediumOnPrimary => theme.textTheme.displayMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      );
  static get displaySmallLightgreen50 => theme.textTheme.displaySmall!.copyWith(
        color: appTheme.lightGreen50,
      );
// Headline text style
  static get headlineLargeErrorContainer =>
      theme.textTheme.headlineLarge!.copyWith(
        color: theme.colorScheme.errorContainer,
        fontSize: 30,
        fontWeight: FontWeight.w600,
      );
  static get headlineSmallLightgreen50 =>
      theme.textTheme.headlineSmall!.copyWith(
        color: appTheme.lightGreen50,
        fontWeight: FontWeight.w800,
      );
// Inter text style
  static get interOnPrimary => TextStyle(
        color: theme.colorScheme.onPrimary,
        fontSize: 96,
        fontWeight: FontWeight.w800,
      ).inter;
// Title text style
  static get titleLargeGray700 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.gray700,
        fontWeight: FontWeight.w600,
      );
  static get titleLargeGreen700 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.green700,
        fontWeight: FontWeight.w600,
      );
  static get titleLargeLightgreen50 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.lightGreen50,
      );
  static get titleLargeRedA700 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.redA700,
        fontWeight: FontWeight.w600,
      );
}
