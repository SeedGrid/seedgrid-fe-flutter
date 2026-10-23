// dart format off
// GERADO por tools/gen_props/emit.mjs a partir de @seedgrid/fe-components 2026.7.1. NAO EDITE A MAO.
// Fonte: tools/gen_props/props-spec.json (compilador TypeScript + *.meta.ts). Tipos que nao viraram tipo exato
// estao em tools/gen_props/excecoes.json.
// ignore_for_file: constant_identifier_names

/// Valores aceitos pelo React: `vertical`, `horizontal`.
enum SgAccordionOrientation {
  vertical('vertical'),
  horizontal('horizontal');

  const SgAccordionOrientation(this.value);

  /// String equivalente no React.
  final String value;

  static SgAccordionOrientation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `solid`, `outline`, `ghost`.
enum SgAppearance {
  solid('solid'),
  outline('outline'),
  ghost('ghost');

  const SgAppearance(this.value);

  /// String equivalente no React.
  final String value;

  static SgAppearance? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgAutocompleteElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgAutocompleteElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgAutocompleteElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgAutocompleteLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgAutocompleteLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgAutocompleteLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgAutocompleteLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgAutocompleteLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgAutocompleteLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgAutocompleteTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgAutocompleteTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgAutocompleteTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgAvatarGroupOverlap {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgAvatarGroupOverlap(this.value);

  /// String equivalente no React.
  final String value;

  static SgAvatarGroupOverlap? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `primary`, `secondary`, `success`, `warning`, `danger`, `info`, `neutral`, `custom`.
enum SgAvatarSeverity {
  primary('primary'),
  secondary('secondary'),
  success('success'),
  warning('warning'),
  danger('danger'),
  info('info'),
  neutral('neutral'),
  custom('custom');

  const SgAvatarSeverity(this.value);

  /// String equivalente no React.
  final String value;

  static SgAvatarSeverity? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `circle`, `square`.
enum SgAvatarShape {
  circle('circle'),
  square('square');

  const SgAvatarShape(this.value);

  /// String equivalente no React.
  final String value;

  static SgAvatarShape? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `sm`, `md`, `lg`, `xs`, `xl`.
enum SgAvatarSize {
  sm('sm'),
  md('md'),
  lg('lg'),
  xs('xs'),
  xl('xl');

  const SgAvatarSize(this.value);

  /// String equivalente no React.
  final String value;

  static SgAvatarSize? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `solid`, `soft`, `outline`, `ghost`.
enum SgBadgeBadgeStyle {
  solid('solid'),
  soft('soft'),
  outline('outline'),
  ghost('ghost');

  const SgBadgeBadgeStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgBadgeBadgeStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `top`, `left`, `top-left`, `top-right`, `bottom-left`, `bottom-right`, `right`, `bottom`.
enum SgBadgeOverlayPlacement {
  top('top'),
  left('left'),
  topLeft('top-left'),
  topRight('top-right'),
  bottomLeft('bottom-left'),
  bottomRight('bottom-right'),
  right('right'),
  bottom('bottom');

  const SgBadgeOverlayPlacement(this.value);

  /// String equivalente no React.
  final String value;

  static SgBadgeOverlayPlacement? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `primary`, `secondary`, `success`, `warning`, `danger`, `info`, `neutral`, `custom`.
enum SgBadgeSeverity {
  primary('primary'),
  secondary('secondary'),
  success('success'),
  warning('warning'),
  danger('danger'),
  info('info'),
  neutral('neutral'),
  custom('custom');

  const SgBadgeSeverity(this.value);

  /// String equivalente no React.
  final String value;

  static SgBadgeSeverity? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `sm`, `md`, `lg`, `xs`.
enum SgBadgeSize {
  sm('sm'),
  md('md'),
  lg('lg'),
  xs('xs');

  const SgBadgeSize(this.value);

  /// String equivalente no React.
  final String value;

  static SgBadgeSize? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `collapse`, `scroll`.
enum SgBreadcrumbOverflowBehavior {
  collapse('collapse'),
  scroll('scroll');

  const SgBreadcrumbOverflowBehavior(this.value);

  /// String equivalente no React.
  final String value;

  static SgBreadcrumbOverflowBehavior? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `sm`, `md`, `lg`.
enum SgBreadcrumbSize {
  sm('sm'),
  md('md'),
  lg('lg');

  const SgBreadcrumbSize(this.value);

  /// String equivalente no React.
  final String value;

  static SgBreadcrumbSize? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `primary`, `default`, `subtle`.
enum SgBreadcrumbVariant {
  primary('primary'),
  defaultValue('default'),
  subtle('subtle');

  const SgBreadcrumbVariant(this.value);

  /// String equivalente no React.
  final String value;

  static SgBreadcrumbVariant? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `circle`, `square`, `rounded`, `default`.
enum SgButtonShape {
  circle('circle'),
  square('square'),
  rounded('rounded'),
  defaultValue('default');

  const SgButtonShape(this.value);

  /// String equivalente no React.
  final String value;

  static SgButtonShape? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `narrow`, `short`, `long`.
enum SgCalendarWeekdayFormat {
  narrow('narrow'),
  short('short'),
  long('long');

  const SgCalendarWeekdayFormat(this.value);

  /// String equivalente no React.
  final String value;

  static SgCalendarWeekdayFormat? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `default`, `outlined`, `flat`, `elevated`.
enum SgCardCardStyle {
  defaultValue('default'),
  outlined('outlined'),
  flat('flat'),
  elevated('elevated');

  const SgCardCardStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgCardCardStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `left`, `right`.
enum SgCardCollapseToggleAlign {
  left('left'),
  right('right');

  const SgCardCollapseToggleAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgCardCollapseToggleAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `sm`, `md`, `lg`.
enum SgCardSize {
  sm('sm'),
  md('md'),
  lg('lg');

  const SgCardSize(this.value);

  /// String equivalente no React.
  final String value;

  static SgCardSize? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `vertical`, `horizontal`.
enum SgCarouselOrientation {
  vertical('vertical'),
  horizontal('horizontal');

  const SgCarouselOrientation(this.value);

  /// String equivalente no React.
  final String value;

  static SgCarouselOrientation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `vertical`, `horizontal`.
enum SgCheckboxGroupOrientation {
  vertical('vertical'),
  horizontal('horizontal');

  const SgCheckboxGroupOrientation(this.value);

  /// String equivalente no React.
  final String value;

  static SgCheckboxGroupOrientation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `checkbox`, `highlight`.
enum SgCheckboxGroupSelectionStyle {
  checkbox('checkbox'),
  highlight('highlight');

  const SgCheckboxGroupSelectionStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgCheckboxGroupSelectionStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `digital`, `analog`.
enum SgClockClockStyle {
  digital('digital'),
  analog('analog');

  const SgClockClockStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgClockClockStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `default`, `segment`, `sevenSegment`, `roller3d`, `flip`, `fade`, `matrix`, `neon`, `discard`.
enum SgClockDigitalStyle {
  defaultValue('default'),
  segment('segment'),
  sevenSegment('sevenSegment'),
  roller3d('roller3d'),
  flip('flip'),
  fade('fade'),
  matrix('matrix'),
  neon('neon'),
  discard('discard');

  const SgClockDigitalStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgClockDigitalStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `12h`, `24h`.
enum SgClockFormat {
  v12h('12h'),
  v24h('24h');

  const SgClockFormat(this.value);

  /// String equivalente no React.
  final String value;

  static SgClockFormat? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `step`, `smooth`.
enum SgClockSecondHandMode {
  step('step'),
  smooth('smooth');

  const SgClockSecondHandMode(this.value);

  /// String equivalente no React.
  final String value;

  static SgClockSecondHandMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgComboboxElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgComboboxElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgComboboxElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgComboboxLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgComboboxLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgComboboxLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgComboboxLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgComboboxLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgComboboxLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgComboboxTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgComboboxTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgComboboxTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `top`, `left`.
enum SgConfirmationDialogIconPlacement {
  top('top'),
  left('left');

  const SgConfirmationDialogIconPlacement(this.value);

  /// String equivalente no React.
  final String value;

  static SgConfirmationDialogIconPlacement? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `multiple`, `single`.
enum SgDatatableSelectionMode {
  multiple('multiple'),
  single('single');

  const SgDatatableSelectionMode(this.value);

  /// String equivalente no React.
  final String value;

  static SgDatatableSelectionMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `fade`, `zoom`, `slideUp`.
enum SgDialogAnimation {
  fade('fade'),
  zoom('zoom'),
  slideUp('slideUp');

  const SgDialogAnimation(this.value);

  /// String equivalente no React.
  final String value;

  static SgDialogAnimation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `primary`, `secondary`, `success`, `warning`, `danger`, `info`, `help`, `plain`.
enum SgDialogSeverity {
  primary('primary'),
  secondary('secondary'),
  success('success'),
  warning('warning'),
  danger('danger'),
  info('info'),
  help('help'),
  plain('plain');

  const SgDialogSeverity(this.value);

  /// String equivalente no React.
  final String value;

  static SgDialogSeverity? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `sm`, `md`, `lg`, `xl`, `full`.
enum SgDialogSize {
  sm('sm'),
  md('md'),
  lg('lg'),
  xl('xl'),
  full('full');

  const SgDialogSize(this.value);

  /// String equivalente no React.
  final String value;

  static SgDialogSize? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `discard`, `incoming`.
enum SgDiscardDigitChangeAnimationMode {
  discard('discard'),
  incoming('incoming');

  const SgDiscardDigitChangeAnimationMode(this.value);

  /// String equivalente no React.
  final String value;

  static SgDiscardDigitChangeAnimationMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgDockMenuElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgDockMenuElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgDockMenuElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `left-top`, `left-center`, `left-bottom`, `center-top`, `center-bottom`, `right-top`, `right-center`, `right-bottom`.
enum SgDockMenuPosition {
  leftTop('left-top'),
  leftCenter('left-center'),
  leftBottom('left-bottom'),
  centerTop('center-top'),
  centerBottom('center-bottom'),
  rightTop('right-top'),
  rightCenter('right-center'),
  rightBottom('right-bottom');

  const SgDockMenuPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgDockMenuPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `top`, `left`, `right`, `bottom`, `free`.
enum SgDockZoneId {
  top('top'),
  left('left'),
  right('right'),
  bottom('bottom'),
  free('free');

  const SgDockZoneId(this.value);

  /// String equivalente no React.
  final String value;

  static SgDockZoneId? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`.
enum SgElevation {
  none('none'),
  sm('sm'),
  md('md');

  const SgElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgExpandablePanelElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgExpandablePanelElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgExpandablePanelElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `top`, `left`, `right`, `bottom`.
enum SgExpandablePanelExpandTo {
  top('top'),
  left('left'),
  right('right'),
  bottom('bottom');

  const SgExpandablePanelExpandTo(this.value);

  /// String equivalente no React.
  final String value;

  static SgExpandablePanelExpandTo? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `inline`, `overlay`.
enum SgExpandablePanelMode {
  inline('inline'),
  overlay('overlay');

  const SgExpandablePanelMode(this.value);

  /// String equivalente no React.
  final String value;

  static SgExpandablePanelMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgExpandablePanelPlacement {
  start('start'),
  center('center'),
  end('end');

  const SgExpandablePanelPlacement(this.value);

  /// String equivalente no React.
  final String value;

  static SgExpandablePanelPlacement? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `dialog`, `region`.
enum SgExpandablePanelRole {
  dialog('dialog'),
  region('region');

  const SgExpandablePanelRole(this.value);

  /// String equivalente no React.
  final String value;

  static SgExpandablePanelRole? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `md`, `lg`, `xl`.
enum SgExpandablePanelRounded {
  none('none'),
  md('md'),
  lg('lg'),
  xl('xl');

  const SgExpandablePanelRounded(this.value);

  /// String equivalente no React.
  final String value;

  static SgExpandablePanelRounded? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `pulse`, `fade`, `scale`, `slide`, `rotate`.
enum SgFloatActionButtonAnimation {
  none('none'),
  pulse('pulse'),
  fade('fade'),
  scale('scale'),
  slide('slide'),
  rotate('rotate');

  const SgFloatActionButtonAnimation(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonAnimation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `mount`, `hover`, `click`.
enum SgFloatActionButtonAnimationOn {
  mount('mount'),
  hover('hover'),
  click('click');

  const SgFloatActionButtonAnimationOn(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonAnimationOn? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `left`, `right`, `down`, `up`.
enum SgFloatActionButtonDirection {
  left('left'),
  right('right'),
  down('down'),
  up('up');

  const SgFloatActionButtonDirection(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonDirection? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgFloatActionButtonElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgFloatActionButtonElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `primary`, `secondary`, `success`, `warning`, `danger`, `info`, `help`, `plain`.
enum SgFloatActionButtonFloatActionButtonStyle {
  primary('primary'),
  secondary('secondary'),
  success('success'),
  warning('warning'),
  danger('danger'),
  info('info'),
  help('help'),
  plain('plain');

  const SgFloatActionButtonFloatActionButtonStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonFloatActionButtonStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `down`, `up`.
enum SgFloatActionButtonHideDirection {
  down('down'),
  up('up');

  const SgFloatActionButtonHideDirection(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonHideDirection? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `top`, `left`, `right`, `bottom`.
enum SgFloatActionButtonHintPosition {
  top('top'),
  left('left'),
  right('right'),
  bottom('bottom');

  const SgFloatActionButtonHintPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonHintPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `left-top`, `left-center`, `left-bottom`, `center-top`, `center-bottom`, `right-top`, `right-center`, `right-bottom`.
enum SgFloatActionButtonPosition {
  leftTop('left-top'),
  leftCenter('left-center'),
  leftBottom('left-bottom'),
  centerTop('center-top'),
  centerBottom('center-bottom'),
  rightTop('right-top'),
  rightCenter('right-center'),
  rightBottom('right-bottom');

  const SgFloatActionButtonPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `primary`, `secondary`, `success`, `warning`, `danger`, `info`, `help`, `plain`.
enum SgFloatActionButtonSeverity {
  primary('primary'),
  secondary('secondary'),
  success('success'),
  warning('warning'),
  danger('danger'),
  info('info'),
  help('help'),
  plain('plain');

  const SgFloatActionButtonSeverity(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonSeverity? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `circle`, `square`, `rounded`.
enum SgFloatActionButtonShape {
  circle('circle'),
  square('square'),
  rounded('rounded');

  const SgFloatActionButtonShape(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonShape? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `sm`, `md`, `lg`.
enum SgFloatActionButtonSize {
  sm('sm'),
  md('md'),
  lg('lg');

  const SgFloatActionButtonSize(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonSize? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `circle`, `linear`, `semi-circle`, `quarter-circle`.
enum SgFloatActionButtonType {
  circle('circle'),
  linear('linear'),
  semiCircle('semi-circle'),
  quarterCircle('quarter-circle');

  const SgFloatActionButtonType(this.value);

  /// String equivalente no React.
  final String value;

  static SgFloatActionButtonType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`, `stretch`.
enum SgGridAlign {
  start('start'),
  center('center'),
  end('end'),
  stretch('stretch');

  const SgGridAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgGridAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`, `stretch`, `between`, `around`, `evenly`.
enum SgGridJustify {
  start('start'),
  center('center'),
  end('end'),
  stretch('stretch'),
  between('between'),
  around('around'),
  evenly('evenly');

  const SgGridJustify(this.value);

  /// String equivalente no React.
  final String value;

  static SgGridJustify? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputBirthDateElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputBirthDateElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputBirthDateElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputBirthDateLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputBirthDateLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputBirthDateLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputBirthDateLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputBirthDateLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputBirthDateLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputBirthDateTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputBirthDateTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputBirthDateTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputCNPJElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputCNPJElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCNPJElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputCNPJLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputCNPJLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCNPJLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputCNPJLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputCNPJLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCNPJLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputCNPJTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputCNPJTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCNPJTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputCPFCNPJElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputCPFCNPJElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCPFCNPJElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputCPFCNPJLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputCPFCNPJLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCPFCNPJLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputCPFCNPJLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputCPFCNPJLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCPFCNPJLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputCPFCNPJTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputCPFCNPJTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCPFCNPJTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputCPFElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputCPFElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCPFElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputCPFLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputCPFLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCPFLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputCPFLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputCPFLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCPFLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputCPFTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputCPFTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCPFTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `symbol`, `name`, `narrowSymbol`, `code`.
enum SgInputCurrencyCurrencyDisplay {
  symbol('symbol'),
  name('name'),
  narrowSymbol('narrowSymbol'),
  code('code');

  const SgInputCurrencyCurrencyDisplay(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCurrencyCurrencyDisplay? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `prefix`, `auto`, `suffix`.
enum SgInputCurrencyCurrencySymbolPlacement {
  prefix('prefix'),
  auto('auto'),
  suffix('suffix');

  const SgInputCurrencyCurrencySymbolPlacement(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCurrencyCurrencySymbolPlacement? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `null`, `zero`.
enum SgInputCurrencyEmptyValue {
  nullValue('null'),
  zero('zero');

  const SgInputCurrencyEmptyValue(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCurrencyEmptyValue? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputCurrencyTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputCurrencyTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputCurrencyTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputDateElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputDateElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputDateElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputDateLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputDateLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputDateLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputDateLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputDateLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputDateLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputDateTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputDateTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputDateTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputEmailElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputEmailElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputEmailElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputEmailLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputEmailLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputEmailLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputEmailLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputEmailLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputEmailLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputEmailTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputEmailTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputEmailTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputNumberElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputNumberElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputNumberElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `null`, `zero`.
enum SgInputNumberEmptyValue {
  nullValue('null'),
  zero('zero');

  const SgInputNumberEmptyValue(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputNumberEmptyValue? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputNumberLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputNumberLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputNumberLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputNumberLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputNumberLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputNumberLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputNumberTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputNumberTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputNumberTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputPasswordElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputPasswordElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPasswordElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputPasswordLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputPasswordLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPasswordLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputPasswordLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputPasswordLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPasswordLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputPasswordTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputPasswordTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPasswordTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputPhoneElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputPhoneElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPhoneElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputPhoneLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputPhoneLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPhoneLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputPhoneLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputPhoneLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPhoneLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputPhoneTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputPhoneTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPhoneTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `BR`, `PT`, `US`, `ES`, `UY`, `AR`, `PY`.
enum SgInputPostalCodeCountry {
  br('BR'),
  pt('PT'),
  us('US'),
  es('ES'),
  uy('UY'),
  ar('AR'),
  py('PY');

  const SgInputPostalCodeCountry(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPostalCodeCountry? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputPostalCodeElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputPostalCodeElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPostalCodeElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputPostalCodeLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputPostalCodeLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPostalCodeLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputPostalCodeLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputPostalCodeLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPostalCodeLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputPostalCodeTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputPostalCodeTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputPostalCodeTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputTextAreaElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputTextAreaElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextAreaElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputTextAreaLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputTextAreaLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextAreaLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputTextAreaLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputTextAreaLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextAreaLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputTextElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputTextElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputTextLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputTextLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputTextLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputTextLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgInputTextSearchElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgInputTextSearchElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextSearchElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgInputTextSearchLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgInputTextSearchLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextSearchLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgInputTextSearchLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgInputTextSearchLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextSearchLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputTextSearchTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputTextSearchTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextSearchTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgInputTextTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgInputTextTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgInputTextTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `vertical`, `horizontal`.
enum SgLinearGaugeOrientation {
  vertical('vertical'),
  horizontal('horizontal');

  const SgLinearGaugeOrientation(this.value);

  /// String equivalente no React.
  final String value;

  static SgLinearGaugeOrientation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `circle`, `triangle`, `inverted-triangle`, `diamond`, `rect`.
enum SgLinearGaugePrimaryPointerShape {
  circle('circle'),
  triangle('triangle'),
  invertedTriangle('inverted-triangle'),
  diamond('diamond'),
  rect('rect');

  const SgLinearGaugePrimaryPointerShape(this.value);

  /// String equivalente no React.
  final String value;

  static SgLinearGaugePrimaryPointerShape? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `compact`, `comfortable`.
enum SgMenuDensity {
  compact('compact'),
  comfortable('comfortable');

  const SgMenuDensity(this.value);

  /// String equivalente no React.
  final String value;

  static SgMenuDensity? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`.
enum SgMenuElevation {
  none('none'),
  sm('sm'),
  md('md');

  const SgMenuElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgMenuElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `inline`, `sidebar`, `drawer`, `hybrid`.
enum SgMenuMenuStyle {
  inline('inline'),
  sidebar('sidebar'),
  drawer('drawer'),
  hybrid('hybrid');

  const SgMenuMenuStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgMenuMenuStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `panel`, `tiered`, `mega-horizontal`, `mega-vertical`, `PanelMenu`, `Tiered`, `MegaMenuHorizontal`, `MegaMenuVertical`.
enum SgMenuMenuVariantStyle {
  panel('panel'),
  tiered('tiered'),
  megaHorizontal('mega-horizontal'),
  megaVertical('mega-vertical'),
  panelMenu('PanelMenu'),
  tiered2('Tiered'),
  megaMenuHorizontal('MegaMenuHorizontal'),
  megaMenuVertical('MegaMenuVertical');

  const SgMenuMenuVariantStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgMenuMenuVariantStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `multiple`, `accordion`.
enum SgMenuMode {
  multiple('multiple'),
  accordion('accordion');

  const SgMenuMode(this.value);

  /// String equivalente no React.
  final String value;

  static SgMenuMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `horizontal-left`, `horizontal-right`, `vertical-up`, `vertical-top`, `vertical-down`.
enum SgMenuOrientationDirection {
  horizontalLeft('horizontal-left'),
  horizontalRight('horizontal-right'),
  verticalUp('vertical-up'),
  verticalTop('vertical-top'),
  verticalDown('vertical-down');

  const SgMenuOrientationDirection(this.value);

  /// String equivalente no React.
  final String value;

  static SgMenuOrientationDirection? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `left`, `right`.
enum SgMenuPosition {
  left('left'),
  right('right');

  const SgMenuPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgMenuPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `sm`, `md`, `lg`.
enum SgMultiSelectElevation {
  none('none'),
  sm('sm'),
  md('md'),
  lg('lg');

  const SgMultiSelectElevation(this.value);

  /// String equivalente no React.
  final String value;

  static SgMultiSelectElevation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgMultiSelectLabelAlign {
  start('start'),
  center('center'),
  end('end');

  const SgMultiSelectLabelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgMultiSelectLabelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `float`, `top`, `left`.
enum SgMultiSelectLabelPosition {
  float('float'),
  top('top'),
  left('left');

  const SgMultiSelectLabelPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgMultiSelectLabelPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `email`, `search`, `tel`, `text`, `url`, `numeric`, `decimal`.
enum SgMultiSelectTextInputType {
  none('none'),
  email('email'),
  search('search'),
  tel('tel'),
  text('text'),
  url('url'),
  numeric('numeric'),
  decimal('decimal');

  const SgMultiSelectTextInputType(this.value);

  /// String equivalente no React.
  final String value;

  static SgMultiSelectTextInputType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `left`, `right`.
enum SgOrderListControlsPosition {
  left('left'),
  right('right');

  const SgOrderListControlsPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgOrderListControlsPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `multiple`, `single`.
enum SgOrderListSelectionMode {
  multiple('multiple'),
  single('single');

  const SgOrderListSelectionMode(this.value);

  /// String equivalente no React.
  final String value;

  static SgOrderListSelectionMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `scroll`, `select`.
enum SgPageControlMobilePageControl {
  scroll('scroll'),
  select('select');

  const SgPageControlMobilePageControl(this.value);

  /// String equivalente no React.
  final String value;

  static SgPageControlMobilePageControl? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `underline`, `pills`.
enum SgPageControlPageControlStyle {
  underline('underline'),
  pills('pills');

  const SgPageControlPageControlStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgPageControlPageControlStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `sm`, `md`, `lg`.
enum SgPageControlSize {
  sm('sm'),
  md('md'),
  lg('lg');

  const SgPageControlSize(this.value);

  /// String equivalente no React.
  final String value;

  static SgPageControlSize? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `top`, `left`, `right`, `bottom`, `client`.
enum SgPanelAlign {
  top('top'),
  left('left'),
  right('right'),
  bottom('bottom'),
  client('client');

  const SgPanelAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgPanelAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `solid`, `dashed`.
enum SgPanelBorderStyle {
  none('none'),
  solid('solid'),
  dashed('dashed');

  const SgPanelBorderStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgPanelBorderStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`, `stretch`.
enum SgPanelContentAlign {
  start('start'),
  center('center'),
  end('end'),
  stretch('stretch');

  const SgPanelContentAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgPanelContentAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `row`, `column`.
enum SgPanelContentDirection {
  row('row'),
  column('column');

  const SgPanelContentDirection(this.value);

  /// String equivalente no React.
  final String value;

  static SgPanelContentDirection? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`, `between`, `around`, `evenly`.
enum SgPanelContentJustify {
  start('start'),
  center('center'),
  end('end'),
  between('between'),
  around('around'),
  evenly('evenly');

  const SgPanelContentJustify(this.value);

  /// String equivalente no React.
  final String value;

  static SgPanelContentJustify? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `ALL`, `CUSTOM`, `TODAY`, `YESTERDAY`, `TOMORROW`, `THIS_WEEK`, `THIS_QUINZENA`, `THIS_MONTH`, `THIS_QUARTER`, `THIS_SEMESTER`, `THIS_YEAR`, `LAST_WEEK`, `LAST_QUINZENA`, `LAST_MONTH`, `LAST_QUARTER`, `LAST_SEMESTER`, `LAST_YEAR`, `NEXT_WEEK`, `NEXT_QUINZENA`, `NEXT_MONTH`, `NEXT_QUARTER`, `NEXT_SEMESTER`, `NEXT_YEAR`.
enum SgPeriodSelectorValue {
  all('ALL'),
  custom('CUSTOM'),
  today('TODAY'),
  yesterday('YESTERDAY'),
  tomorrow('TOMORROW'),
  thisWeek('THIS_WEEK'),
  thisQuinzena('THIS_QUINZENA'),
  thisMonth('THIS_MONTH'),
  thisQuarter('THIS_QUARTER'),
  thisSemester('THIS_SEMESTER'),
  thisYear('THIS_YEAR'),
  lastWeek('LAST_WEEK'),
  lastQuinzena('LAST_QUINZENA'),
  lastMonth('LAST_MONTH'),
  lastQuarter('LAST_QUARTER'),
  lastSemester('LAST_SEMESTER'),
  lastYear('LAST_YEAR'),
  nextWeek('NEXT_WEEK'),
  nextQuinzena('NEXT_QUINZENA'),
  nextMonth('NEXT_MONTH'),
  nextQuarter('NEXT_QUARTER'),
  nextSemester('NEXT_SEMESTER'),
  nextYear('NEXT_YEAR');

  const SgPeriodSelectorValue(this.value);

  /// String equivalente no React.
  final String value;

  static SgPeriodSelectorValue? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `contains`, `startsWith`, `endsWith`.
enum SgPickListFilterMatchMode {
  contains('contains'),
  startsWith('startsWith'),
  endsWith('endsWith');

  const SgPickListFilterMatchMode(this.value);

  /// String equivalente no React.
  final String value;

  static SgPickListFilterMatchMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `multiple`, `single`.
enum SgPickListSelectionMode {
  multiple('multiple'),
  single('single');

  const SgPickListSelectionMode(this.value);

  /// String equivalente no React.
  final String value;

  static SgPickListSelectionMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`.
enum SgPopupAlign {
  start('start'),
  center('center'),
  end('end');

  const SgPopupAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgPopupAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `top`, `left`, `right`, `bottom`, `auto`.
enum SgPopupPlacement {
  top('top'),
  left('left'),
  right('right'),
  bottom('bottom'),
  auto('auto');

  const SgPopupPlacement(this.value);

  /// String equivalente no React.
  final String value;

  static SgPopupPlacement? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `top`, `left`, `right`, `bottom`.
enum SgPopupPreferPlacement {
  top('top'),
  left('left'),
  right('right'),
  bottom('bottom');

  const SgPopupPreferPlacement(this.value);

  /// String equivalente no React.
  final String value;

  static SgPopupPreferPlacement? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `L`, `M`, `Q`, `H`.
enum SgQRCodeErrorCorrectionLevel {
  l('L'),
  m('M'),
  q('Q'),
  h('H');

  const SgQRCodeErrorCorrectionLevel(this.value);

  /// String equivalente no React.
  final String value;

  static SgQRCodeErrorCorrectionLevel? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `circle`, `square`, `triangle`, `diamond`.
enum SgRadialGaugePrimaryPointerShape {
  circle('circle'),
  square('square'),
  triangle('triangle'),
  diamond('diamond');

  const SgRadialGaugePrimaryPointerShape(this.value);

  /// String equivalente no React.
  final String value;

  static SgRadialGaugePrimaryPointerShape? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `range`, `needle`, `marker`.
enum SgRadialGaugePrimaryPointerType {
  range('range'),
  needle('needle'),
  marker('marker');

  const SgRadialGaugePrimaryPointerType(this.value);

  /// String equivalente no React.
  final String value;

  static SgRadialGaugePrimaryPointerType? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `vertical`, `horizontal`.
enum SgRadioGroupOrientation {
  vertical('vertical'),
  horizontal('horizontal');

  const SgRadioGroupOrientation(this.value);

  /// String equivalente no React.
  final String value;

  static SgRadioGroupOrientation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `radio`, `highlight`.
enum SgRadioGroupSelectionStyle {
  radio('radio'),
  highlight('highlight');

  const SgRadioGroupSelectionStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgRadioGroupSelectionStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `sm`, `md`, `lg`, `xl`.
enum SgRatingSize {
  sm('sm'),
  md('md'),
  lg('lg'),
  xl('xl');

  const SgRatingSize(this.value);

  /// String equivalente no React.
  final String value;

  static SgRatingSize? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `blue`, `green`, `red`, `white`, `yellow`.
enum SgSevenSegmentDigitPalette {
  blue('blue'),
  green('green'),
  red('red'),
  white('white'),
  yellow('yellow');

  const SgSevenSegmentDigitPalette(this.value);

  /// String equivalente no React.
  final String value;

  static SgSevenSegmentDigitPalette? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `primary`, `secondary`, `success`, `warning`, `danger`, `info`, `help`.
enum SgSeverity {
  primary('primary'),
  secondary('secondary'),
  success('success'),
  warning('warning'),
  danger('danger'),
  info('info'),
  help('help');

  const SgSeverity(this.value);

  /// String equivalente no React.
  final String value;

  static SgSeverity? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `sm`, `md`, `lg`.
enum SgSize {
  sm('sm'),
  md('md'),
  lg('lg');

  const SgSize(this.value);

  /// String equivalente no React.
  final String value;

  static SgSize? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `pulse`, `wave`.
enum SgSkeletonAnimation {
  none('none'),
  pulse('pulse'),
  wave('wave');

  const SgSkeletonAnimation(this.value);

  /// String equivalente no React.
  final String value;

  static SgSkeletonAnimation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `text`, `circle`, `square`, `rounded`, `rectangle`.
enum SgSkeletonShape {
  text('text'),
  circle('circle'),
  square('square'),
  rounded('rounded'),
  rectangle('rectangle');

  const SgSkeletonShape(this.value);

  /// String equivalente no React.
  final String value;

  static SgSkeletonShape? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `square`, `rounded`, `default`.
enum SgSplitButtonShape {
  square('square'),
  rounded('rounded'),
  defaultValue('default');

  const SgSplitButtonShape(this.value);

  /// String equivalente no React.
  final String value;

  static SgSplitButtonShape? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`, `stretch`.
enum SgStackAlign {
  start('start'),
  center('center'),
  end('end'),
  stretch('stretch');

  const SgStackAlign(this.value);

  /// String equivalente no React.
  final String value;

  static SgStackAlign? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `row`, `column`.
enum SgStackDirection {
  row('row'),
  column('column');

  const SgStackDirection(this.value);

  /// String equivalente no React.
  final String value;

  static SgStackDirection? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `start`, `center`, `end`, `between`, `around`, `evenly`.
enum SgStackJustify {
  start('start'),
  center('center'),
  end('end'),
  between('between'),
  around('around'),
  evenly('evenly');

  const SgStackJustify(this.value);

  /// String equivalente no React.
  final String value;

  static SgStackJustify? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `left`, `right`.
enum SgStringAnimatorAlignTo {
  left('left'),
  right('right');

  const SgStringAnimatorAlignTo(this.value);

  /// String equivalente no React.
  final String value;

  static SgStringAnimatorAlignTo? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `roller3d`, `flip`, `fade`, `matrix`, `neon`, `discard`.
enum SgStringAnimatorStringAnimatorStyle {
  roller3d('roller3d'),
  flip('flip'),
  fade('fade'),
  matrix('matrix'),
  neon('neon'),
  discard('discard');

  const SgStringAnimatorStringAnimatorStyle(this.value);

  /// String equivalente no React.
  final String value;

  static SgStringAnimatorStringAnimatorStyle? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `top-left`, `top-right`, `bottom-left`, `bottom-right`, `top-center`, `bottom-center`.
enum SgToasterPosition {
  topLeft('top-left'),
  topRight('top-right'),
  bottomLeft('bottom-left'),
  bottomRight('bottom-right'),
  topCenter('top-center'),
  bottomCenter('bottom-center');

  const SgToasterPosition(this.value);

  /// String equivalente no React.
  final String value;

  static SgToasterPosition? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `top`, `left`, `right`, `bottom`, `free`.
enum SgToolBarDockZone {
  top('top'),
  left('left'),
  right('right'),
  bottom('bottom'),
  free('free');

  const SgToolBarDockZone(this.value);

  /// String equivalente no React.
  final String value;

  static SgToolBarDockZone? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `horizontal-left`, `horizontal-right`, `vertical-up`, `vertical-down`.
enum SgToolBarOrientationDirection {
  horizontalLeft('horizontal-left'),
  horizontalRight('horizontal-right'),
  verticalUp('vertical-up'),
  verticalDown('vertical-down');

  const SgToolBarOrientationDirection(this.value);

  /// String equivalente no React.
  final String value;

  static SgToolBarOrientationDirection? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `primary`, `secondary`, `success`, `warning`, `danger`, `info`, `help`, `plain`.
enum SgToolbarIconButtonSeverity {
  primary('primary'),
  secondary('secondary'),
  success('success'),
  warning('warning'),
  danger('danger'),
  info('info'),
  help('help'),
  plain('plain');

  const SgToolbarIconButtonSeverity(this.value);

  /// String equivalente no React.
  final String value;

  static SgToolbarIconButtonSeverity? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `toggle`.
enum SgTreeViewBranchLabelBehavior {
  none('none'),
  toggle('toggle');

  const SgTreeViewBranchLabelBehavior(this.value);

  /// String equivalente no React.
  final String value;

  static SgTreeViewBranchLabelBehavior? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `live`, `confirm`.
enum SgTreeViewCheckMode {
  live('live'),
  confirm('confirm');

  const SgTreeViewCheckMode(this.value);

  /// String equivalente no React.
  final String value;

  static SgTreeViewCheckMode? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `all`, `leafOnly`.
enum SgTreeViewConfirmSelection {
  all('all'),
  leafOnly('leafOnly');

  const SgTreeViewConfirmSelection(this.value);

  /// String equivalente no React.
  final String value;

  static SgTreeViewConfirmSelection? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `compact`, `comfortable`, `normal`.
enum SgTreeViewDensity {
  compact('compact'),
  comfortable('comfortable'),
  normal('normal');

  const SgTreeViewDensity(this.value);

  /// String equivalente no React.
  final String value;

  static SgTreeViewDensity? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `primary`, `default`.
enum SgTreeViewIconTone {
  primary('primary'),
  defaultValue('default');

  const SgTreeViewIconTone(this.value);

  /// String equivalente no React.
  final String value;

  static SgTreeViewIconTone? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `sm`, `md`, `lg`.
enum SgTreeViewSize {
  sm('sm'),
  md('md'),
  lg('lg');

  const SgTreeViewSize(this.value);

  /// String equivalente no React.
  final String value;

  static SgTreeViewSize? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `default`, `muted`.
enum SgTreeViewTone {
  defaultValue('default'),
  muted('muted');

  const SgTreeViewTone(this.value);

  /// String equivalente no React.
  final String value;

  static SgTreeViewTone? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `previous`, `previous-and-next`.
enum SgWizardStepNavigation {
  none('none'),
  previous('previous'),
  previousAndNext('previous-and-next');

  const SgWizardStepNavigation(this.value);

  /// String equivalente no React.
  final String value;

  static SgWizardStepNavigation? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}

/// Valores aceitos pelo React: `none`, `numbered`, `icons`.
enum SgWizardStepper {
  none('none'),
  numbered('numbered'),
  icons('icons');

  const SgWizardStepper(this.value);

  /// String equivalente no React.
  final String value;

  static SgWizardStepper? fromValue(String? v) {
    for (final e in values) {
      if (e.value == v) return e;
    }
    return null;
  }
}
