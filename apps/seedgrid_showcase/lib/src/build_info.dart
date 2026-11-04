// Identificacao da publicacao: versao da lib, commit e hora do build. O workflow do Pages injeta os valores com
// `--dart-define`; fora dele (execucao local) aparece "local".
const String kSgVersion = String.fromEnvironment(
  'SG_VERSION',
  defaultValue: 'local',
);
const String kSgBuild = String.fromEnvironment(
  'SG_BUILD',
  defaultValue: 'local',
);
const String kSgBuiltAt = String.fromEnvironment('SG_BUILT_AT');

/// Ex.: `v2026.7.1 · build 1be2771 · 2026-11-04 09:44 UTC`.
String sgBuildLabel() {
  final parts = <String>[
    'v$kSgVersion',
    'build $kSgBuild',
    if (kSgBuiltAt.isNotEmpty) kSgBuiltAt,
  ];
  return parts.join(' · ');
}
