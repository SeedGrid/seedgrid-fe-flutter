// Barril do grupo: cada widget novo do grupo e exportado aqui (e so aqui).
library;

export 'tree/sg_tree_logic.dart'
    show
        sgTreeFromJson,
        sgTreeFromJsonWithChecked,
        computeCheckedState,
        computeCascadeValue,
        filterTreeByQuery,
        SgCheckedState,
        SgTreeFilter;
export 'tree/sg_tree_types.dart';
export 'tree/sg_tree_view.dart' show SgTreeView, SgTreeViewState;
