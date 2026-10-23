// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_skeleton_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgSkeletonPageSnippets {
  /// Region `sg-skeleton-animacoes`.
  static const String sgSkeletonAnimacoes = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgSkeleton(width: 220),
    SizedBox(height: 8),
    SgSkeleton(width: 220, animation: SgSkeletonAnimation.pulse),
    SizedBox(height: 8),
    SgSkeleton(width: 220, animation: SgSkeletonAnimation.none),
  ],
)
''';

  /// Region `sg-skeleton-cartao`.
  static const String sgSkeletonCartao = r'''
const Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgSkeleton(shape: SgSkeletonShape.circle, size: 48),
    SizedBox(width: 12),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SgSkeleton(width: '60%'),
          SizedBox(height: 8),
          SgSkeleton(),
          SizedBox(height: 8),
          SgSkeleton(width: '80%'),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-skeleton-dimensoes`.
  static const String sgSkeletonDimensoes = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgSkeleton(width: '50%', height: '2rem'),
    SizedBox(height: 8),
    SgSkeleton(size: '3rem', shape: SgSkeletonShape.circle),
    SizedBox(height: 8),
    SgSkeleton(width: 200, height: 24, borderRadius: 4),
  ],
)
''';

  /// Region `sg-skeleton-formas`.
  static const String sgSkeletonFormas = r'''
const Wrap(
  spacing: 16,
  runSpacing: 16,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgSkeleton(width: 160),
    SgSkeleton(
      shape: SgSkeletonShape.rectangle,
      width: 120,
      height: 48,
    ),
    SgSkeleton(
      shape: SgSkeletonShape.rounded,
      width: 120,
      height: 48,
    ),
    SgSkeleton(shape: SgSkeletonShape.square),
    SgSkeleton(shape: SgSkeletonShape.circle),
  ],
)
''';
}
