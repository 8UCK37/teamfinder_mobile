import 'package:flutter/material.dart';
import 'package:teamfinder_mobile/widgets/canvas_test/custom_child.dart';
import 'package:teamfinder_mobile/widgets/canvas_test/custom_root.dart';
import 'package:teamfinder_mobile/widgets/canvas_test/custom_theme.dart';
import 'package:provider/provider.dart';

typedef AvatarWidgetBuilder<T> = PreferredSize Function(
  BuildContext context,
  T value,
);
typedef ContentBuilder<T> = Widget Function(BuildContext context, T value);

class CustomCommentTreeWidget<R, C> extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = 'CommentTreeWidget';

  final R root;
  final List<C> replies;

  final AvatarWidgetBuilder<R>? avatarRoot;
  final ContentBuilder<R>? contentRoot;

  final AvatarWidgetBuilder<C>? avatarChild;
  final ContentBuilder<C>? contentChild;
  final TreeThemeData treeThemeData;

  const CustomCommentTreeWidget(
    this.root,
    this.replies, {
    this.treeThemeData = const TreeThemeData(lineWidth: 1),
    this.avatarRoot,
    this.contentRoot,
    this.avatarChild,
    this.contentChild,
  });

  @override
  _CustomCommentTreeWidgetState<R, C> createState() =>
      _CustomCommentTreeWidgetState<R, C>();
}

class _CustomCommentTreeWidgetState<R, C> extends State<CustomCommentTreeWidget<R, C>> {
  @override
  Widget build(BuildContext context) {
    final PreferredSize avatarRoot = widget.avatarRoot!(context, widget.root);
    return Provider<TreeThemeData>.value(
      value: widget.treeThemeData,
      child: Column(
        children: [
          RootCommentWidget(
            avatarRoot,
            widget.contentRoot!(context, widget.root),
          ),
          ...widget.replies.map(
            (e) => CommentChildWidget(
              isLast: widget.replies.indexOf(e) == (widget.replies.length - 1),
              avatar: widget.avatarChild!(context, e),
              avatarRoot: avatarRoot.preferredSize,
              content: widget.contentChild!(context, e),
            ),
          )
        ],
      ),
    );
  }
}
