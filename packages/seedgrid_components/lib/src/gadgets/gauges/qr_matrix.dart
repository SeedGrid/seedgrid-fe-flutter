// Gerador de QR igual ao do React: o SgQRCode usa o qrcode.react (ISC), que embute o gerador qrcodegen de Nayuki
// (MIT, https://www.nayuki.io/page/qr-code-generator-library). Este arquivo e um PORTE desse algoritmo para Dart,
// funcao por funcao, para a matriz de modulos sair IDENTICA a do React:
//   1. segmento unico: numerico, alfanumerico ou bytes UTF-8 (nessa ordem de preferencia);
//   2. menor versao (1 a 40) que comporta os dados no nivel pedido;
//   3. `boostLevel` (padrao do qrcode.react): sobe o nivel de correcao (M, Q, H) enquanto os dados ainda cabem na mesma versao;
//   4. mascara: a de menor penalidade pela regra do qrcodegen (a primeira em caso de empate).
// Por que nao o pacote `qr` (reexportado pelo qr_flutter 4.1.0, BSD-3): ele so gera em modo bytes, nao tem boost de nivel,
// escolhe a mascara por outra regra e, na versao 3.0.2 (a unica que o qr_flutter 4.1.0 aceita), tem a tabela de blocos
// Reed-Solomon da versao 15 nivel H truncada (`[11, 36, 12]`), o que faz o QR dessa combinacao falhar com
// "Input too long". A conferencia contra matrizes do qrcode.react de verdade esta em test/widgets/sg_qr_matrix_test.dart.
import 'dart:convert';

import '../../generated/enums.g.dart';
import 'qr_tables.g.dart';

/// Matriz quadrada de modulos (true = escuro), sem margem.
class QrMatrix {
  const QrMatrix(this.size, this.modules, this.version, this.level);

  final int size;

  /// `modules[y][x]`.
  final List<List<bool>> modules;
  final int version;

  /// Nivel de correcao realmente usado (pode ser maior que o pedido, por causa do `boostLevel`).
  final SgQRCodeErrorCorrectionLevel level;

  bool isDark(int x, int y) =>
      x >= 0 && y >= 0 && x < size && y < size && modules[y][x];
}

class QrDataTooLongException implements Exception {
  const QrDataTooLongException();
  @override
  String toString() => 'Data too long';
}

enum _Mode {
  numeric(1),
  alphanumeric(2),
  byte(4);

  const _Mode(this.modeBits);
  final int modeBits;
}

final RegExp _numericRegex = RegExp(r'^[0-9]*$');
final RegExp _alnumRegex = RegExp(r'^[A-Z0-9 $%*+.\/:-]*$');
const String _alnumCharset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ \$%*+-./:';

/// Ordem das linhas das tabelas: Low, Medium, Quartile, High.
int _eccIndex(SgQRCodeErrorCorrectionLevel l) => switch (l) {
  SgQRCodeErrorCorrectionLevel.l => 0,
  SgQRCodeErrorCorrectionLevel.m => 1,
  SgQRCodeErrorCorrectionLevel.q => 2,
  SgQRCodeErrorCorrectionLevel.h => 3,
};

/// `formatBits` do qrcodegen: Low 1, Medium 0, Quartile 3, High 2.
const List<int> _formatBits = [1, 0, 3, 2];

const List<SgQRCodeErrorCorrectionLevel> _levels = [
  SgQRCodeErrorCorrectionLevel.l,
  SgQRCodeErrorCorrectionLevel.m,
  SgQRCodeErrorCorrectionLevel.q,
  SgQRCodeErrorCorrectionLevel.h,
];

int _numRawDataModules(int ver) {
  var result = (16 * ver + 128) * ver + 64;
  if (ver >= 2) {
    final numAlign = ver ~/ 7 + 2;
    result -= (25 * numAlign - 10) * numAlign - 55;
    if (ver >= 7) result -= 36;
  }
  return result;
}

int _numDataCodewords(int ver, int eccIndex) =>
    _numRawDataModules(ver) ~/ 8 -
    kQrEccCodewordsPerBlock[eccIndex][ver] *
        kQrNumErrorCorrectionBlocks[eccIndex][ver];

int _ccBits(_Mode mode, int ver) {
  final band = (ver + 7) ~/ 17;
  return switch (mode) {
    _Mode.numeric => const [10, 12, 14][band],
    _Mode.alphanumeric => const [9, 11, 13][band],
    _Mode.byte => const [8, 16, 16][band],
  };
}

class _Segment {
  _Segment(this.mode, this.numChars, this.bits);
  final _Mode mode;
  final int numChars;
  final List<int> bits;
}

void _appendBits(int val, int len, List<int> bb) {
  for (var i = len - 1; i >= 0; i--) {
    bb.add((val >> i) & 1);
  }
}

_Segment _makeSegment(String text) {
  final bb = <int>[];
  if (_numericRegex.hasMatch(text)) {
    for (var i = 0; i < text.length;) {
      final n = text.length - i < 3 ? text.length - i : 3;
      _appendBits(int.parse(text.substring(i, i + n)), n * 3 + 1, bb);
      i += n;
    }
    return _Segment(_Mode.numeric, text.length, bb);
  }
  if (_alnumRegex.hasMatch(text)) {
    var i = 0;
    for (; i + 2 <= text.length; i += 2) {
      var temp = _alnumCharset.indexOf(text[i]) * 45;
      temp += _alnumCharset.indexOf(text[i + 1]);
      _appendBits(temp, 11, bb);
    }
    if (i < text.length) _appendBits(_alnumCharset.indexOf(text[i]), 6, bb);
    return _Segment(_Mode.alphanumeric, text.length, bb);
  }
  final data = utf8.encode(text);
  for (final b in data) {
    _appendBits(b, 8, bb);
  }
  return _Segment(_Mode.byte, data.length, bb);
}

/// Bits totais do segmento na versao [ver]; nulo se o numero de caracteres nao cabe no campo de contagem.
int? _totalBits(_Segment s, int ver) {
  final cc = _ccBits(s.mode, ver);
  if (s.numChars >= (1 << cc)) return null;
  return 4 + cc + s.bits.length;
}

// ------------------------------------------------------------------------------------ Reed-Solomon (GF(2^8) / 0x11D)

int _rsMultiply(int x, int y) {
  var z = 0;
  for (var i = 7; i >= 0; i--) {
    z = (z << 1) ^ ((z >> 7) * 0x11D);
    z ^= ((y >> i) & 1) * x;
  }
  return z;
}

List<int> _rsDivisor(int degree) {
  final result = List<int>.filled(degree, 0);
  result[degree - 1] = 1;
  var root = 1;
  for (var i = 0; i < degree; i++) {
    for (var j = 0; j < result.length; j++) {
      result[j] = _rsMultiply(result[j], root);
      if (j + 1 < result.length) result[j] ^= result[j + 1];
    }
    root = _rsMultiply(root, 2);
  }
  return result;
}

List<int> _rsRemainder(List<int> data, List<int> divisor) {
  final result = List<int>.filled(divisor.length, 0, growable: true);
  for (final b in data) {
    final factor = b ^ result.removeAt(0);
    result.add(0);
    for (var i = 0; i < divisor.length; i++) {
      result[i] ^= _rsMultiply(divisor[i], factor);
    }
  }
  return result;
}

// ------------------------------------------------------------------------------------ penalidade (qrcodegen)

const int _n1 = 3, _n2 = 3, _n3 = 40, _n4 = 10;

void _addHistory(int currentRunLength, List<int> runHistory, int size) {
  if (runHistory[0] == 0) currentRunLength += size;
  runHistory.removeLast();
  runHistory.insert(0, currentRunLength);
}

int _countPatterns(List<int> h) {
  final n = h[1];
  final core = n > 0 && h[2] == n && h[3] == n * 3 && h[4] == n && h[5] == n;
  return ((core && h[0] >= n * 4 && h[6] >= n) ? 1 : 0) +
      ((core && h[6] >= n * 4 && h[0] >= n) ? 1 : 0);
}

int _terminateAndCount(bool runColor, int runLength, List<int> h, int size) {
  if (runColor) {
    _addHistory(runLength, h, size);
    runLength = 0;
  }
  runLength += size;
  _addHistory(runLength, h, size);
  return _countPatterns(h);
}

int _penaltyScore(List<List<bool>> m) {
  final size = m.length;
  var result = 0;
  for (var y = 0; y < size; y++) {
    var runColor = false;
    var runX = 0;
    final h = List<int>.filled(7, 0, growable: true);
    for (var x = 0; x < size; x++) {
      if (m[y][x] == runColor) {
        runX++;
        if (runX == 5) {
          result += _n1;
        } else if (runX > 5) {
          result++;
        }
      } else {
        _addHistory(runX, h, size);
        if (!runColor) result += _countPatterns(h) * _n3;
        runColor = m[y][x];
        runX = 1;
      }
    }
    result += _terminateAndCount(runColor, runX, h, size) * _n3;
  }
  for (var x = 0; x < size; x++) {
    var runColor = false;
    var runY = 0;
    final h = List<int>.filled(7, 0, growable: true);
    for (var y = 0; y < size; y++) {
      if (m[y][x] == runColor) {
        runY++;
        if (runY == 5) {
          result += _n1;
        } else if (runY > 5) {
          result++;
        }
      } else {
        _addHistory(runY, h, size);
        if (!runColor) result += _countPatterns(h) * _n3;
        runColor = m[y][x];
        runY = 1;
      }
    }
    result += _terminateAndCount(runColor, runY, h, size) * _n3;
  }
  for (var y = 0; y < size - 1; y++) {
    for (var x = 0; x < size - 1; x++) {
      final c = m[y][x];
      if (c == m[y][x + 1] && c == m[y + 1][x] && c == m[y + 1][x + 1]) {
        result += _n2;
      }
    }
  }
  var dark = 0;
  for (final row in m) {
    for (final c in row) {
      if (c) dark++;
    }
  }
  final total = size * size;
  final k = ((dark * 20 - total * 10).abs() / total).ceil() - 1;
  result += k * _n4;
  return result;
}

// ------------------------------------------------------------------------------------ desenho do simbolo

bool _bit(int x, int i) => ((x >> i) & 1) != 0;

class _Builder {
  _Builder(this.version, this.eccIndex, List<int> dataCodewords)
    : size = version * 4 + 17,
      modules = List.generate(
        version * 4 + 17,
        (_) => List<bool>.filled(version * 4 + 17, false),
      ),
      isFunction = List.generate(
        version * 4 + 17,
        (_) => List<bool>.filled(version * 4 + 17, false),
      ) {
    _drawFunctionPatterns();
    _drawCodewords(_addEccAndInterleave(dataCodewords));
  }

  final int version;
  final int eccIndex;
  final int size;
  final List<List<bool>> modules;
  final List<List<bool>> isFunction;

  void _setFunction(int x, int y, bool dark) {
    modules[y][x] = dark;
    isFunction[y][x] = true;
  }

  void _drawFunctionPatterns() {
    for (var i = 0; i < size; i++) {
      _setFunction(6, i, i % 2 == 0);
      _setFunction(i, 6, i % 2 == 0);
    }
    _drawFinder(3, 3);
    _drawFinder(size - 4, 3);
    _drawFinder(3, size - 4);
    final pos = _alignmentPositions();
    final n = pos.length;
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        if (!((i == 0 && j == 0) ||
            (i == 0 && j == n - 1) ||
            (i == n - 1 && j == 0))) {
          _drawAlignment(pos[i], pos[j]);
        }
      }
    }
    drawFormatBits(0);
    _drawVersion();
  }

  void drawFormatBits(int mask) {
    final data = (_formatBits[eccIndex] << 3) | mask;
    var rem = data;
    for (var i = 0; i < 10; i++) {
      rem = (rem << 1) ^ ((rem >> 9) * 0x537);
    }
    final bits = ((data << 10) | rem) ^ 0x5412;
    for (var i = 0; i <= 5; i++) {
      _setFunction(8, i, _bit(bits, i));
    }
    _setFunction(8, 7, _bit(bits, 6));
    _setFunction(8, 8, _bit(bits, 7));
    _setFunction(7, 8, _bit(bits, 8));
    for (var i = 9; i < 15; i++) {
      _setFunction(14 - i, 8, _bit(bits, i));
    }
    for (var i = 0; i < 8; i++) {
      _setFunction(size - 1 - i, 8, _bit(bits, i));
    }
    for (var i = 8; i < 15; i++) {
      _setFunction(8, size - 15 + i, _bit(bits, i));
    }
    _setFunction(8, size - 8, true);
  }

  void _drawVersion() {
    if (version < 7) return;
    var rem = version;
    for (var i = 0; i < 12; i++) {
      rem = (rem << 1) ^ ((rem >> 11) * 0x1F25);
    }
    final bits = (version << 12) | rem;
    for (var i = 0; i < 18; i++) {
      final color = _bit(bits, i);
      final a = size - 11 + i % 3;
      final b = i ~/ 3;
      _setFunction(a, b, color);
      _setFunction(b, a, color);
    }
  }

  void _drawFinder(int x, int y) {
    for (var dy = -4; dy <= 4; dy++) {
      for (var dx = -4; dx <= 4; dx++) {
        final dist = dx.abs() > dy.abs() ? dx.abs() : dy.abs();
        final xx = x + dx;
        final yy = y + dy;
        if (xx >= 0 && xx < size && yy >= 0 && yy < size) {
          _setFunction(xx, yy, dist != 2 && dist != 4);
        }
      }
    }
  }

  void _drawAlignment(int x, int y) {
    for (var dy = -2; dy <= 2; dy++) {
      for (var dx = -2; dx <= 2; dx++) {
        final dist = dx.abs() > dy.abs() ? dx.abs() : dy.abs();
        _setFunction(x + dx, y + dy, dist != 1);
      }
    }
  }

  List<int> _alignmentPositions() {
    if (version == 1) return const [];
    final numAlign = version ~/ 7 + 2;
    final step = version == 32
        ? 26
        : ((version * 4 + 4) / (numAlign * 2 - 2)).ceil() * 2;
    final result = <int>[6];
    for (var pos = size - 7; result.length < numAlign; pos -= step) {
      result.insert(1, pos);
    }
    return result;
  }

  List<int> _addEccAndInterleave(List<int> data) {
    final numBlocks = kQrNumErrorCorrectionBlocks[eccIndex][version];
    final blockEccLen = kQrEccCodewordsPerBlock[eccIndex][version];
    final rawCodewords = _numRawDataModules(version) ~/ 8;
    final numShortBlocks = numBlocks - rawCodewords % numBlocks;
    final shortBlockLen = rawCodewords ~/ numBlocks;
    final blocks = <List<int>>[];
    final rsDiv = _rsDivisor(blockEccLen);
    var k = 0;
    for (var i = 0; i < numBlocks; i++) {
      final end =
          k + shortBlockLen - blockEccLen + (i < numShortBlocks ? 0 : 1);
      final dat = data.sublist(k, end);
      k += dat.length;
      final ecc = _rsRemainder(dat, rsDiv);
      if (i < numShortBlocks) dat.add(0);
      blocks.add([...dat, ...ecc]);
    }
    final result = <int>[];
    for (var i = 0; i < blocks[0].length; i++) {
      for (var j = 0; j < blocks.length; j++) {
        if (i != shortBlockLen - blockEccLen || j >= numShortBlocks) {
          result.add(blocks[j][i]);
        }
      }
    }
    return result;
  }

  void _drawCodewords(List<int> data) {
    var i = 0;
    for (var right = size - 1; right >= 1; right -= 2) {
      if (right == 6) right = 5;
      for (var vert = 0; vert < size; vert++) {
        for (var j = 0; j < 2; j++) {
          final x = right - j;
          final upward = ((right + 1) & 2) == 0;
          final y = upward ? size - 1 - vert : vert;
          if (!isFunction[y][x] && i < data.length * 8) {
            modules[y][x] = _bit(data[i >> 3], 7 - (i & 7));
            i++;
          }
        }
      }
    }
  }

  /// XOR da mascara (chamar de novo com a mesma mascara a desfaz).
  void applyMask(int mask) {
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        final invert = switch (mask) {
          0 => (x + y) % 2 == 0,
          1 => y % 2 == 0,
          2 => x % 3 == 0,
          3 => (x + y) % 3 == 0,
          4 => (x ~/ 3 + y ~/ 2) % 2 == 0,
          5 => x * y % 2 + x * y % 3 == 0,
          6 => (x * y % 2 + x * y % 3) % 2 == 0,
          7 => ((x + y) % 2 + x * y % 3) % 2 == 0,
          _ => throw RangeError('mascara fora de 0 a 7'),
        };
        if (!isFunction[y][x] && invert) modules[y][x] = !modules[y][x];
      }
    }
  }
}

/// Gera a matriz como o qrcode.react: `encodeSegments(makeSegments(text), level, 1, 40, -1, boostLevel)`.
/// Lanca [QrDataTooLongException] se nao couber na versao 40 (o React lanca `RangeError("Data too long")`).
QrMatrix encodeQrMatrix(
  String text,
  SgQRCodeErrorCorrectionLevel level, {
  bool boostLevel = true,
}) {
  final seg = _makeSegment(text);
  var ecc = _eccIndex(level);

  var version = 1;
  int dataUsedBits;
  while (true) {
    final capacity = _numDataCodewords(version, ecc) * 8;
    final used = _totalBits(seg, version);
    if (used != null && used <= capacity) {
      dataUsedBits = used;
      break;
    }
    if (version >= 40) throw const QrDataTooLongException();
    version++;
  }
  for (final newEcc in const [1, 2, 3]) {
    if (boostLevel && dataUsedBits <= _numDataCodewords(version, newEcc) * 8) {
      ecc = newEcc;
    }
  }

  // Bits de dados: modo, contagem, dados, terminador, alinhamento a byte e bytes de enchimento 0xEC/0x11.
  final bb = <int>[];
  _appendBits(seg.mode.modeBits, 4, bb);
  _appendBits(seg.numChars, _ccBits(seg.mode, version), bb);
  bb.addAll(seg.bits);
  final capacityBits = _numDataCodewords(version, ecc) * 8;
  final term = capacityBits - bb.length < 4 ? capacityBits - bb.length : 4;
  _appendBits(0, term, bb);
  _appendBits(0, (8 - bb.length % 8) % 8, bb);
  for (var padByte = 0xEC; bb.length < capacityBits; padByte ^= 0xEC ^ 0x11) {
    _appendBits(padByte, 8, bb);
  }
  final dataCodewords = List<int>.filled(bb.length ~/ 8, 0);
  for (var i = 0; i < bb.length; i++) {
    dataCodewords[i >> 3] |= bb[i] << (7 - (i & 7));
  }

  final b = _Builder(version, ecc, dataCodewords);
  var bestMask = 0;
  var minPenalty = 1 << 30;
  for (var mask = 0; mask < 8; mask++) {
    b.applyMask(mask);
    b.drawFormatBits(mask);
    final penalty = _penaltyScore(b.modules);
    if (penalty < minPenalty) {
      bestMask = mask;
      minPenalty = penalty;
    }
    b.applyMask(mask);
  }
  b.applyMask(bestMask);
  b.drawFormatBits(bestMask);
  return QrMatrix(b.size, b.modules, version, _levels[ecc]);
}
