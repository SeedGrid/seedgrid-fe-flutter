// Barril do grupo: cada widget novo do grupo e exportado aqui (e so aqui).
library;

export 'gauges/gauge_math.dart' show jsRound, jsRoundText;
export 'gauges/gauge_types.dart';
export 'gauges/qr_matrix.dart'
    show QrDataTooLongException, QrMatrix, encodeQrMatrix;
export 'gauges/sg_linear_gauge.dart' show SgLinearGauge;
export 'gauges/sg_qr_code.dart' show SgQRCode, SgQRCodeLayout, sgQrCodeLayout;
export 'gauges/sg_radial_gauge.dart'
    show SgRadialGauge, kGaugeTouchSlop, radialGaugeCenterTexts;
