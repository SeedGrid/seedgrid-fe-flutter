// Paridade com o TypeScript: cada caso de vectors.json foi calculado pelas funcoes do React
// (tools/parity_vectors/generate.mjs). Aqui a mesma entrada precisa dar a mesma saida.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seedgrid_commons/seedgrid_commons.dart';

void main() {
  final doc =
      jsonDecode(File('test/parity/vectors.json').readAsStringSync())
          as Map<String, dynamic>;

  final maskFns = <String, String Function(String)>{
    'maskCpf': maskCpf,
    'maskCnpj': maskCnpj,
    'maskCpfCnpj': maskCpfCnpj,
    'maskCep': maskCep,
    'maskPostalCodeBR': maskPostalCodeBR,
    'maskPostalCodePT': maskPostalCodePT,
    'maskPostalCodeUS': maskPostalCodeUS,
    'maskPostalCodeES': maskPostalCodeES,
    'maskPostalCodeUY': maskPostalCodeUY,
    'maskPostalCodeAR': maskPostalCodeAR,
    'maskPostalCodePY': maskPostalCodePY,
    'maskPhone': maskPhone,
    'onlyDigits': onlyDigits,
  };

  group('masks (React ${doc['versaoReact']})', () {
    final masks = doc['masks'] as Map<String, dynamic>;
    test('toda mascara dos vetores tem porte', () {
      expect(masks.keys.toSet(), maskFns.keys.toSet());
    });
    masks.forEach((name, cases) {
      test(name, () {
        for (final c in (cases as List).cast<Map<String, dynamic>>()) {
          expect(
            maskFns[name]!(c['in'] as String),
            c['out'],
            reason: '$name(${jsonEncode(c['in'])})',
          );
        }
      });
    });
  });

  List<Map<String, dynamic>> list(String k) =>
      (doc[k] as List).cast<Map<String, dynamic>>();

  test('isValidCpf', () {
    for (final c in list('isValidCpf')) {
      expect(
        isValidCpf(c['in'] as String),
        c['out'],
        reason: 'isValidCpf(${jsonEncode(c['in'])})',
      );
    }
  });

  test('isValidCnpj (inclui alfanumerico)', () {
    for (final c in list('isValidCnpj')) {
      expect(
        isValidCnpj(c['in'] as String),
        c['out'],
        reason: 'isValidCnpj(${jsonEncode(c['in'])})',
      );
    }
  });

  test('isValidEmail', () {
    for (final c in list('isValidEmail')) {
      expect(
        isValidEmail(c['in'] as String),
        c['out'],
        reason: 'isValidEmail(${jsonEncode(c['in'])})',
      );
    }
  });

  test('lista de dominios bloqueados igual a do React', () {
    expect(
      getBlockedEmailDomains(),
      (doc['blockedDomains'] as List).cast<String>(),
    );
  });

  test('isBlockedEmailDomain', () {
    for (final c in list('isBlockedEmailDomain')) {
      expect(
        isBlockedEmailDomain(c['in'] as String),
        c['out'],
        reason: jsonEncode(c['in']),
      );
    }
  });

  test('isBlockedEmailDomain com dominios extras', () {
    for (final c in list('isBlockedEmailDomainExtra')) {
      expect(
        isBlockedEmailDomain(
          c['in'] as String,
          (c['extra'] as List).cast<String>(),
        ),
        c['out'],
        reason: jsonEncode(c['in']),
      );
    }
  });

  test('validatePassword (problemas e minSize)', () {
    for (final c in list('validatePassword')) {
      final p = c['policy'] as Map<String, dynamic>;
      final r = validatePassword(
        c['in'] as String,
        PasswordPolicy(
          minSize: p['minSize'] as int?,
          upper: p['upper'] as bool?,
          lower: p['lower'] as bool?,
          number: p['number'] as bool?,
          special: p['special'] as bool?,
          noRepeat: p['noRepeat'] as bool?,
        ),
      );
      final out = c['out'] as Map<String, dynamic>;
      expect(r.ok, out['ok'], reason: 'ok: ${jsonEncode(c)}');
      expect(
        r.problems.map((e) => e.name).toList(),
        (out['problems'] as List).cast<String>(),
        reason: 'problemas: ${jsonEncode(c)}',
      );
      if (out['minSize'] != null &&
          r.problems.contains(PasswordProblem.minSize)) {
        expect(r.minSize, out['minSize']);
      }
    }
  });

  test('isDateAfter', () {
    for (final c in list('isDateAfter')) {
      expect(
        isDateAfter(c['value'] as String, c['min'] as String?),
        c['out'],
        reason: jsonEncode(c),
      );
    }
  });

  test('isDateBefore', () {
    for (final c in list('isDateBefore')) {
      expect(
        isDateBefore(c['value'] as String, c['max'] as String?),
        c['out'],
        reason: jsonEncode(c),
      );
    }
  });
}
