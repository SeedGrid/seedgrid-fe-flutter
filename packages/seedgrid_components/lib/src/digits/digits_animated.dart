// Barril do grupo: cada widget novo do grupo e exportado aqui (e so aqui).
// parseCssColor/parseFontWeight de digits_support.dart ficam fora do barril: o grupo overlay ja exporta um
// parseCssColor (nome igual) e dois exports com o mesmo nome quebram a biblioteca.
library;

export 'animated/digits_support.dart'
    show
        kCssEase,
        kDiscardCurve,
        kIncomingCurve,
        kRollerCurve,
        sgEaseOutBounce,
        sgEaseOutCubic,
        sgEaseOutSine;
export 'animated/flip_engine.dart';
export 'animated/sg_discard_digit.dart';
export 'animated/sg_flip_digit.dart';
export 'animated/sg_roller3d_digit.dart';
