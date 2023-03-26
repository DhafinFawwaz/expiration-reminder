import 'package:flutter/material.dart';

class PullRefresh extends StatefulWidget {
  const PullRefresh({super.key, required this.onRefresh, required this.child});

  final Widget child;
  final Future Function() onRefresh;

  @override
  State<PullRefresh> createState() => _PullRefreshState();
}

class _PullRefreshState extends State<PullRefresh> {
  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: widget.onRefresh,
    child: Stack(
      children: [widget.child, ListView()],
    )
  );
}