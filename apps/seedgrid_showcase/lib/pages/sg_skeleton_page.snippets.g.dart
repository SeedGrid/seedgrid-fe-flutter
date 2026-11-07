// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_skeleton_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgSkeletonPageSnippets {
  /// Region `sg-skeleton-animacao`.
  static const String sgSkeletonAnimacao = r'''
const SgGrid(
  columns: {'base': 1, 'sm': 3},
  gap: 16,
  children: [
    SgStack(
      gap: 8,
      children: [
        Text('wave'),
        SgSkeleton(animation: SgSkeletonAnimation.wave, height: 56),
      ],
    ),
    SgStack(
      gap: 8,
      children: [
        Text('pulse'),
        SgSkeleton(
          animation: SgSkeletonAnimation.pulse,
          height: 56,
        ),
      ],
    ),
    SgStack(
      gap: 8,
      children: [
        Text('none'),
        SgSkeleton(animation: SgSkeletonAnimation.none, height: 56),
      ],
    ),
  ],
)
''';

  /// Region `sg-skeleton-card`.
  static const String sgSkeletonCard = r'''
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 384),
  child: SgPanel(
    borderStyle: SgPanelBorderStyle.solid,
    contentPadding: 16,
    contentGap: 16,
    children: [
      SgSkeleton(shape: SgSkeletonShape.rounded, height: 160),
      SgStack(
        gap: 8,
        children: [
          SgSkeleton(shape: SgSkeletonShape.text, width: '60%'),
          SgSkeleton(shape: SgSkeletonShape.text),
          SgSkeleton(shape: SgSkeletonShape.text, width: '82%'),
        ],
      ),
    ],
  ),
)
''';

  /// Region `sg-skeleton-dimensoes`.
  static const String sgSkeletonDimensoes = r'''
const SgStack(
  gap: 8,
  children: [
    SgSkeleton(width: '50%', height: '2rem'),
    SgSkeleton(size: '3rem', shape: SgSkeletonShape.circle),
    SgSkeleton(width: 200, height: 24, borderRadius: 4),
  ],
)
''';

  /// Region `sg-skeleton-formas`.
  static const String sgSkeletonFormas = r'''
const SgGrid(
  columns: {'base': 2, 'lg': 5},
  gap: 12,
  children: [
    SgSkeleton(shape: SgSkeletonShape.text),
    SgSkeleton(shape: SgSkeletonShape.rectangle, height: 48),
    SgSkeleton(shape: SgSkeletonShape.rounded, height: 48),
    SgSkeleton(shape: SgSkeletonShape.square, size: 56),
    SgSkeleton(shape: SgSkeletonShape.circle, size: 56),
  ],
)
''';

  /// Region `sg-skeleton-larguras`.
  static const String sgSkeletonLarguras = r'''
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 448),
  child: SgStack(
    gap: 8,
    children: [
      SgSkeleton(shape: SgSkeletonShape.text, width: '100%'),
      SgSkeleton(shape: SgSkeletonShape.text, width: '86%'),
      SgSkeleton(shape: SgSkeletonShape.text, width: '72%'),
      SgSkeleton(shape: SgSkeletonShape.text, width: '52%'),
    ],
  ),
)
''';

  /// Region `sg-skeleton-lista-tabela`.
  static const String sgSkeletonListaTabela = r'''
SgGrid(
  columns: const {'base': 1, 'lg': 2},
  gap: 24,
  children: [
    SgStack(
      gap: 12,
      children: [
        for (var i = 0; i < 5; i++)
          const Row(
            children: [
              SgSkeleton(shape: SgSkeletonShape.circle, size: 40),
              SizedBox(width: 12),
              Expanded(
                child: SgStack(
                  gap: 8,
                  children: [
                    SgSkeleton(
                      shape: SgSkeletonShape.text,
                      width: '55%',
                    ),
                    SgSkeleton(
                      shape: SgSkeletonShape.text,
                      width: '35%',
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    ),
    SgPanel(
      borderStyle: SgPanelBorderStyle.solid,
      contentPadding: 12,
      contentGap: 12,
      children: [
        const Row(
          children: [
            Expanded(
              child: SgSkeleton(
                shape: SgSkeletonShape.text,
                width: '80%',
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: SgSkeleton(
                shape: SgSkeletonShape.text,
                width: '70%',
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: SgSkeleton(
                shape: SgSkeletonShape.text,
                width: '70%',
              ),
            ),
          ],
        ),
        for (var i = 0; i < 5; i++)
          Row(
            children: [
              Expanded(
                child: SgSkeleton(
                  shape: SgSkeletonShape.text,
                  width: '${60 + ((i % 3) * 10)}%',
                ),
              ),
              const SizedBox(width: 12),
              const SizedBox(
                width: 120,
                child: SgSkeleton(
                  shape: SgSkeletonShape.text,
                  width: '55%',
                ),
              ),
              const SizedBox(width: 12),
              const SizedBox(
                width: 120,
                child: SgSkeleton(
                  shape: SgSkeletonShape.text,
                  width: '45%',
                ),
              ),
            ],
          ),
      ],
    ),
  ],
)
''';
}
