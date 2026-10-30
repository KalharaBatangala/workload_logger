import 'package:flutter/material.dart';

/// Design tokens from SPEC §11. Widgets take colours, text styles, radii and
/// spacing only from here — never hard-coded values.

/// Colours (SPEC §11.1).
abstract final class AppColors {
  static const navy = Color(0xFF13234A);
  static const navyDeep = Color(0xFF0B1733);
  static const gold = Color(0xFFC8A24A);
  static const goldText = Color(0xFF7A5C14);
  static const goldTextDeep = Color(0xFF5C4510);
  static const goldSoft = Color(0xFFFBF1D6);
  static const goldBorder = Color(0xFFE6D3A0);
  static const goldTint = Color(0xFFFBF6E8);
  static const cream = Color(0xFFE9D9A8);
  static const ground = Color(0xFFF5F6FA);
  static const surface = Color(0xFFFFFFFF);
  static const chip = Color(0xFFE8ECF5);
  static const track = Color(0xFFEEF1F7);
  static const border = Color(0xFFE3E6EE);
  static const borderStrong = Color(0xFFCBD1DE);
  static const divider = Color(0xFFEEF0F5);
  static const textBody = Color(0xFF3E475C);
  static const textMuted = Color(0xFF5B6478);
  static const navInactive = Color(0xFF6B7386);
  static const onNavyMuted = Color(0xFFC9D0E0);
  static const success = Color(0xFF2E7D5B);

  // Not in the SPEC palette; Material 3 default error red, for form errors.
  static const error = Color(0xFFB3261E);
}

/// Typography (SPEC §11.2). All styles use Plus Jakarta Sans and default to
/// navy; override the colour with `copyWith` where a screen needs another.
abstract final class AppText {
  static const fontFamily = 'PlusJakartaSans';

  static const display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
    height: 1.1,
    color: AppColors.navy,
  );
  static const countBig = TextStyle(
    fontFamily: fontFamily,
    fontSize: 56,
    fontWeight: FontWeight.w800,
    height: 1.1,
    color: AppColors.navy,
  );
  static const screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.navy,
  );
  static const stepTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.navy,
  );
  static const greeting = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.navy,
  );
  static const cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
  );
  static const section = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.navy,
  );
  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.navy,
  );
  static const bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textBody,
  );
  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );
  static const captionSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  /// Use with an upper-cased string; Flutter has no text-transform.
  static const overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    color: AppColors.textMuted,
  );
  static const badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: AppColors.navy,
  );
  static const tabLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.navInactive,
  );
  static const tabLabelActive = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: AppColors.navy,
  );
}

/// Corner radii (SPEC §11.3).
abstract final class AppRadii {
  static const hero = 22.0;
  static const card = 18.0;
  static const cardLarge = 20.0;
  static const cardSmall = 16.0;
  static const tile = 18.0;
  static const button = 14.0;
  static const buttonSmall = 12.0;
  static const badge = 8.0;
  static const chip = 10.0;
  static const logButton = 20.0;
  static const pill = 22.0;
}

/// Spacing scale (SPEC §11.3).
abstract final class AppSpacing {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const section = 18.0;
  static const xl = 20.0;
  static const xxl = 24.0;

  static const screenPadding = 20.0;
  static const minTouchTarget = 44.0;
}

/// Bottom navigation dimensions (SPEC §8.0).
abstract final class AppNavBar {
  static const height = 86.0;
  static const logButtonSize = 58.0;
  static const logButtonLift = 28.0;
}

/// The only shadow in the app: the raised Log button (SPEC §11.3).
abstract final class AppShadows {
  static const logButton = [
    BoxShadow(
      color: Color(0x4013234A), // navy at 25 %
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}
