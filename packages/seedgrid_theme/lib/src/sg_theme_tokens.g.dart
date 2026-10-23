// GERADO por tools/parity_vectors/generate_theme.mjs a partir de @seedgrid/fe-theme 0.3.0. Nao edite a mao.
// Regra de nome: "--sg-btn-primary-bg" vira btnPrimaryBg (tira "--sg-", camelCase; segmento numerico gruda: primary600).
import 'dart:ui' show Color;

import 'sg_theme.dart';

/// Getters tipados dos tokens `--sg-*` (193).
extension SgThemeTokens on SgTheme {
  /// `--sg-bg`
  Color get bg => color('--sg-bg');

  /// `--sg-surface`
  Color get surface => color('--sg-surface');

  /// `--sg-muted-surface`
  Color get mutedSurface => color('--sg-muted-surface');

  /// `--sg-border`
  Color get border => color('--sg-border');

  /// `--sg-ring`
  Color get ring => color('--sg-ring');

  /// `--sg-text`
  Color get text => color('--sg-text');

  /// `--sg-muted`
  Color get muted => color('--sg-muted');

  /// `--sg-disabled`
  Color get disabled => color('--sg-disabled');

  /// `--sg-on-disabled`
  Color get onDisabled => color('--sg-on-disabled');

  /// `--sg-link`
  Color get link => color('--sg-link');

  /// `--sg-link-hover`
  Color get linkHover => color('--sg-link-hover');

  /// `--sg-badge`
  Color get badge => color('--sg-badge');

  /// `--sg-on-badge`
  Color get onBadge => color('--sg-on-badge');

  /// `--sg-tooltip`
  Color get tooltip => color('--sg-tooltip');

  /// `--sg-on-tooltip`
  Color get onTooltip => color('--sg-on-tooltip');

  /// `--sg-on-primary`
  Color get onPrimary => color('--sg-on-primary');

  /// `--sg-on-secondary`
  Color get onSecondary => color('--sg-on-secondary');

  /// `--sg-on-tertiary`
  Color get onTertiary => color('--sg-on-tertiary');

  /// `--sg-on-warning`
  Color get onWarning => color('--sg-on-warning');

  /// `--sg-on-error`
  Color get onError => color('--sg-on-error');

  /// `--sg-on-info`
  Color get onInfo => color('--sg-on-info');

  /// `--sg-on-success`
  Color get onSuccess => color('--sg-on-success');

  /// `--sg-primary-50`
  Color get primary50 => color('--sg-primary-50');

  /// `--sg-secondary-50`
  Color get secondary50 => color('--sg-secondary-50');

  /// `--sg-tertiary-50`
  Color get tertiary50 => color('--sg-tertiary-50');

  /// `--sg-warning-50`
  Color get warning50 => color('--sg-warning-50');

  /// `--sg-error-50`
  Color get error50 => color('--sg-error-50');

  /// `--sg-info-50`
  Color get info50 => color('--sg-info-50');

  /// `--sg-success-50`
  Color get success50 => color('--sg-success-50');

  /// `--sg-primary-100`
  Color get primary100 => color('--sg-primary-100');

  /// `--sg-secondary-100`
  Color get secondary100 => color('--sg-secondary-100');

  /// `--sg-tertiary-100`
  Color get tertiary100 => color('--sg-tertiary-100');

  /// `--sg-warning-100`
  Color get warning100 => color('--sg-warning-100');

  /// `--sg-error-100`
  Color get error100 => color('--sg-error-100');

  /// `--sg-info-100`
  Color get info100 => color('--sg-info-100');

  /// `--sg-success-100`
  Color get success100 => color('--sg-success-100');

  /// `--sg-primary-200`
  Color get primary200 => color('--sg-primary-200');

  /// `--sg-secondary-200`
  Color get secondary200 => color('--sg-secondary-200');

  /// `--sg-tertiary-200`
  Color get tertiary200 => color('--sg-tertiary-200');

  /// `--sg-warning-200`
  Color get warning200 => color('--sg-warning-200');

  /// `--sg-error-200`
  Color get error200 => color('--sg-error-200');

  /// `--sg-info-200`
  Color get info200 => color('--sg-info-200');

  /// `--sg-success-200`
  Color get success200 => color('--sg-success-200');

  /// `--sg-primary-300`
  Color get primary300 => color('--sg-primary-300');

  /// `--sg-secondary-300`
  Color get secondary300 => color('--sg-secondary-300');

  /// `--sg-tertiary-300`
  Color get tertiary300 => color('--sg-tertiary-300');

  /// `--sg-warning-300`
  Color get warning300 => color('--sg-warning-300');

  /// `--sg-error-300`
  Color get error300 => color('--sg-error-300');

  /// `--sg-info-300`
  Color get info300 => color('--sg-info-300');

  /// `--sg-success-300`
  Color get success300 => color('--sg-success-300');

  /// `--sg-primary-400`
  Color get primary400 => color('--sg-primary-400');

  /// `--sg-secondary-400`
  Color get secondary400 => color('--sg-secondary-400');

  /// `--sg-tertiary-400`
  Color get tertiary400 => color('--sg-tertiary-400');

  /// `--sg-warning-400`
  Color get warning400 => color('--sg-warning-400');

  /// `--sg-error-400`
  Color get error400 => color('--sg-error-400');

  /// `--sg-info-400`
  Color get info400 => color('--sg-info-400');

  /// `--sg-success-400`
  Color get success400 => color('--sg-success-400');

  /// `--sg-primary-500`
  Color get primary500 => color('--sg-primary-500');

  /// `--sg-secondary-500`
  Color get secondary500 => color('--sg-secondary-500');

  /// `--sg-tertiary-500`
  Color get tertiary500 => color('--sg-tertiary-500');

  /// `--sg-warning-500`
  Color get warning500 => color('--sg-warning-500');

  /// `--sg-error-500`
  Color get error500 => color('--sg-error-500');

  /// `--sg-info-500`
  Color get info500 => color('--sg-info-500');

  /// `--sg-success-500`
  Color get success500 => color('--sg-success-500');

  /// `--sg-primary-600`
  Color get primary600 => color('--sg-primary-600');

  /// `--sg-secondary-600`
  Color get secondary600 => color('--sg-secondary-600');

  /// `--sg-tertiary-600`
  Color get tertiary600 => color('--sg-tertiary-600');

  /// `--sg-warning-600`
  Color get warning600 => color('--sg-warning-600');

  /// `--sg-error-600`
  Color get error600 => color('--sg-error-600');

  /// `--sg-info-600`
  Color get info600 => color('--sg-info-600');

  /// `--sg-success-600`
  Color get success600 => color('--sg-success-600');

  /// `--sg-primary-700`
  Color get primary700 => color('--sg-primary-700');

  /// `--sg-secondary-700`
  Color get secondary700 => color('--sg-secondary-700');

  /// `--sg-tertiary-700`
  Color get tertiary700 => color('--sg-tertiary-700');

  /// `--sg-warning-700`
  Color get warning700 => color('--sg-warning-700');

  /// `--sg-error-700`
  Color get error700 => color('--sg-error-700');

  /// `--sg-info-700`
  Color get info700 => color('--sg-info-700');

  /// `--sg-success-700`
  Color get success700 => color('--sg-success-700');

  /// `--sg-primary-800`
  Color get primary800 => color('--sg-primary-800');

  /// `--sg-secondary-800`
  Color get secondary800 => color('--sg-secondary-800');

  /// `--sg-tertiary-800`
  Color get tertiary800 => color('--sg-tertiary-800');

  /// `--sg-warning-800`
  Color get warning800 => color('--sg-warning-800');

  /// `--sg-error-800`
  Color get error800 => color('--sg-error-800');

  /// `--sg-info-800`
  Color get info800 => color('--sg-info-800');

  /// `--sg-success-800`
  Color get success800 => color('--sg-success-800');

  /// `--sg-primary-900`
  Color get primary900 => color('--sg-primary-900');

  /// `--sg-secondary-900`
  Color get secondary900 => color('--sg-secondary-900');

  /// `--sg-tertiary-900`
  Color get tertiary900 => color('--sg-tertiary-900');

  /// `--sg-warning-900`
  Color get warning900 => color('--sg-warning-900');

  /// `--sg-error-900`
  Color get error900 => color('--sg-error-900');

  /// `--sg-info-900`
  Color get info900 => color('--sg-info-900');

  /// `--sg-success-900`
  Color get success900 => color('--sg-success-900');

  /// `--sg-primary-hover`
  Color get primaryHover => color('--sg-primary-hover');

  /// `--sg-primary-active`
  Color get primaryActive => color('--sg-primary-active');

  /// `--sg-secondary-hover`
  Color get secondaryHover => color('--sg-secondary-hover');

  /// `--sg-secondary-active`
  Color get secondaryActive => color('--sg-secondary-active');

  /// `--sg-tertiary-hover`
  Color get tertiaryHover => color('--sg-tertiary-hover');

  /// `--sg-tertiary-active`
  Color get tertiaryActive => color('--sg-tertiary-active');

  /// `--sg-warning-hover`
  Color get warningHover => color('--sg-warning-hover');

  /// `--sg-error-hover`
  Color get errorHover => color('--sg-error-hover');

  /// `--sg-info-hover`
  Color get infoHover => color('--sg-info-hover');

  /// `--sg-success-hover`
  Color get successHover => color('--sg-success-hover');

  /// `--sg-btn-primary-bg`
  Color get btnPrimaryBg => color('--sg-btn-primary-bg');

  /// `--sg-btn-primary-fg`
  Color get btnPrimaryFg => color('--sg-btn-primary-fg');

  /// `--sg-btn-primary-border`
  Color get btnPrimaryBorder => color('--sg-btn-primary-border');

  /// `--sg-btn-primary-hover-bg`
  Color get btnPrimaryHoverBg => color('--sg-btn-primary-hover-bg');

  /// `--sg-btn-primary-active-bg`
  Color get btnPrimaryActiveBg => color('--sg-btn-primary-active-bg');

  /// `--sg-btn-primary-ring`
  Color get btnPrimaryRing => color('--sg-btn-primary-ring');

  /// `--sg-btn-secondary-bg`
  Color get btnSecondaryBg => color('--sg-btn-secondary-bg');

  /// `--sg-btn-secondary-fg`
  Color get btnSecondaryFg => color('--sg-btn-secondary-fg');

  /// `--sg-btn-secondary-border`
  Color get btnSecondaryBorder => color('--sg-btn-secondary-border');

  /// `--sg-btn-secondary-hover-bg`
  Color get btnSecondaryHoverBg => color('--sg-btn-secondary-hover-bg');

  /// `--sg-btn-secondary-active-bg`
  Color get btnSecondaryActiveBg => color('--sg-btn-secondary-active-bg');

  /// `--sg-btn-secondary-ring`
  Color get btnSecondaryRing => color('--sg-btn-secondary-ring');

  /// `--sg-btn-success-bg`
  Color get btnSuccessBg => color('--sg-btn-success-bg');

  /// `--sg-btn-success-fg`
  Color get btnSuccessFg => color('--sg-btn-success-fg');

  /// `--sg-btn-success-border`
  Color get btnSuccessBorder => color('--sg-btn-success-border');

  /// `--sg-btn-success-hover-bg`
  Color get btnSuccessHoverBg => color('--sg-btn-success-hover-bg');

  /// `--sg-btn-success-active-bg`
  Color get btnSuccessActiveBg => color('--sg-btn-success-active-bg');

  /// `--sg-btn-success-ring`
  Color get btnSuccessRing => color('--sg-btn-success-ring');

  /// `--sg-btn-info-bg`
  Color get btnInfoBg => color('--sg-btn-info-bg');

  /// `--sg-btn-info-fg`
  Color get btnInfoFg => color('--sg-btn-info-fg');

  /// `--sg-btn-info-border`
  Color get btnInfoBorder => color('--sg-btn-info-border');

  /// `--sg-btn-info-hover-bg`
  Color get btnInfoHoverBg => color('--sg-btn-info-hover-bg');

  /// `--sg-btn-info-active-bg`
  Color get btnInfoActiveBg => color('--sg-btn-info-active-bg');

  /// `--sg-btn-info-ring`
  Color get btnInfoRing => color('--sg-btn-info-ring');

  /// `--sg-btn-warning-bg`
  Color get btnWarningBg => color('--sg-btn-warning-bg');

  /// `--sg-btn-warning-fg`
  Color get btnWarningFg => color('--sg-btn-warning-fg');

  /// `--sg-btn-warning-border`
  Color get btnWarningBorder => color('--sg-btn-warning-border');

  /// `--sg-btn-warning-hover-bg`
  Color get btnWarningHoverBg => color('--sg-btn-warning-hover-bg');

  /// `--sg-btn-warning-active-bg`
  Color get btnWarningActiveBg => color('--sg-btn-warning-active-bg');

  /// `--sg-btn-warning-ring`
  Color get btnWarningRing => color('--sg-btn-warning-ring');

  /// `--sg-btn-danger-bg`
  Color get btnDangerBg => color('--sg-btn-danger-bg');

  /// `--sg-btn-danger-fg`
  Color get btnDangerFg => color('--sg-btn-danger-fg');

  /// `--sg-btn-danger-border`
  Color get btnDangerBorder => color('--sg-btn-danger-border');

  /// `--sg-btn-danger-hover-bg`
  Color get btnDangerHoverBg => color('--sg-btn-danger-hover-bg');

  /// `--sg-btn-danger-active-bg`
  Color get btnDangerActiveBg => color('--sg-btn-danger-active-bg');

  /// `--sg-btn-danger-ring`
  Color get btnDangerRing => color('--sg-btn-danger-ring');

  /// `--sg-btn-help-bg`
  Color get btnHelpBg => color('--sg-btn-help-bg');

  /// `--sg-btn-help-fg`
  Color get btnHelpFg => color('--sg-btn-help-fg');

  /// `--sg-btn-help-border`
  Color get btnHelpBorder => color('--sg-btn-help-border');

  /// `--sg-btn-help-hover-bg`
  Color get btnHelpHoverBg => color('--sg-btn-help-hover-bg');

  /// `--sg-btn-help-active-bg`
  Color get btnHelpActiveBg => color('--sg-btn-help-active-bg');

  /// `--sg-btn-help-ring`
  Color get btnHelpRing => color('--sg-btn-help-ring');

  /// `--sg-btn-plain-bg`
  Color get btnPlainBg => color('--sg-btn-plain-bg');

  /// `--sg-btn-plain-fg`
  Color get btnPlainFg => color('--sg-btn-plain-fg');

  /// `--sg-btn-plain-border`
  Color get btnPlainBorder => color('--sg-btn-plain-border');

  /// `--sg-btn-plain-hover-bg`
  Color get btnPlainHoverBg => color('--sg-btn-plain-hover-bg');

  /// `--sg-btn-plain-active-bg`
  Color get btnPlainActiveBg => color('--sg-btn-plain-active-bg');

  /// `--sg-btn-plain-ring`
  Color get btnPlainRing => color('--sg-btn-plain-ring');

  /// `--sg-input-bg`
  Color get inputBg => color('--sg-input-bg');

  /// `--sg-input-fg`
  Color get inputFg => color('--sg-input-fg');

  /// `--sg-input-border`
  Color get inputBorder => color('--sg-input-border');

  /// `--sg-input-border-hover`
  Color get inputBorderHover => color('--sg-input-border-hover');

  /// `--sg-input-border-focus`
  Color get inputBorderFocus => color('--sg-input-border-focus');

  /// `--sg-input-ring`
  Color get inputRing => color('--sg-input-ring');

  /// `--sg-input-placeholder`
  Color get inputPlaceholder => color('--sg-input-placeholder');

  /// `--sg-input-disabled-bg`
  Color get inputDisabledBg => color('--sg-input-disabled-bg');

  /// `--sg-input-disabled-fg`
  Color get inputDisabledFg => color('--sg-input-disabled-fg');

  /// `--sg-card-bg`
  Color get cardBg => color('--sg-card-bg');

  /// `--sg-card-fg`
  Color get cardFg => color('--sg-card-fg');

  /// `--sg-card-border`
  Color get cardBorder => color('--sg-card-border');

  /// `--sg-card-header-bg`
  Color get cardHeaderBg => color('--sg-card-header-bg');

  /// `--sg-alert-info-bg`
  Color get alertInfoBg => color('--sg-alert-info-bg');

  /// `--sg-alert-info-fg`
  Color get alertInfoFg => color('--sg-alert-info-fg');

  /// `--sg-alert-info-border`
  Color get alertInfoBorder => color('--sg-alert-info-border');

  /// `--sg-alert-success-bg`
  Color get alertSuccessBg => color('--sg-alert-success-bg');

  /// `--sg-alert-success-fg`
  Color get alertSuccessFg => color('--sg-alert-success-fg');

  /// `--sg-alert-success-border`
  Color get alertSuccessBorder => color('--sg-alert-success-border');

  /// `--sg-alert-warning-bg`
  Color get alertWarningBg => color('--sg-alert-warning-bg');

  /// `--sg-alert-warning-fg`
  Color get alertWarningFg => color('--sg-alert-warning-fg');

  /// `--sg-alert-warning-border`
  Color get alertWarningBorder => color('--sg-alert-warning-border');

  /// `--sg-alert-error-bg`
  Color get alertErrorBg => color('--sg-alert-error-bg');

  /// `--sg-alert-error-fg`
  Color get alertErrorFg => color('--sg-alert-error-fg');

  /// `--sg-alert-error-border`
  Color get alertErrorBorder => color('--sg-alert-error-border');

  /// `--sg-badge-bg`
  Color get badgeBg => color('--sg-badge-bg');

  /// `--sg-badge-fg`
  Color get badgeFg => color('--sg-badge-fg');

  /// `--sg-tooltip-bg`
  Color get tooltipBg => color('--sg-tooltip-bg');

  /// `--sg-tooltip-fg`
  Color get tooltipFg => color('--sg-tooltip-fg');

  /// `--sg-modal-bg`
  Color get modalBg => color('--sg-modal-bg');

  /// `--sg-modal-fg`
  Color get modalFg => color('--sg-modal-fg');

  /// `--sg-modal-overlay`
  Color get modalOverlay => color('--sg-modal-overlay');

  /// `--sg-menu-bg`
  Color get menuBg => color('--sg-menu-bg');

  /// `--sg-menu-fg`
  Color get menuFg => color('--sg-menu-fg');

  /// `--sg-menu-border`
  Color get menuBorder => color('--sg-menu-border');

  /// `--sg-menu-item-hover-bg`
  Color get menuItemHoverBg => color('--sg-menu-item-hover-bg');

  /// `--sg-menu-item-active-bg`
  Color get menuItemActiveBg => color('--sg-menu-item-active-bg');

  /// `--sg-table-bg`
  Color get tableBg => color('--sg-table-bg');

  /// `--sg-table-fg`
  Color get tableFg => color('--sg-table-fg');

  /// `--sg-table-border`
  Color get tableBorder => color('--sg-table-border');

  /// `--sg-table-header-bg`
  Color get tableHeaderBg => color('--sg-table-header-bg');

  /// `--sg-table-row-hover-bg`
  Color get tableRowHoverBg => color('--sg-table-row-hover-bg');

  /// `--sg-table-row-selected-bg`
  Color get tableRowSelectedBg => color('--sg-table-row-selected-bg');
}
