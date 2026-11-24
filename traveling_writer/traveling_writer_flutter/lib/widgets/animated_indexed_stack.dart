import 'package:flutter/material.dart';

/// A drop-in replacement for [IndexedStack] that animates transitions
/// between children using smooth fade and subtle vertical slide micro-animations,
/// while preserving the full state of all child views (editor cursor, canvas pan/zoom,
/// scroll positions, etc.).
class AnimatedIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;
  final Curve curve;

  const AnimatedIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 280),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedIndexedStack> createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final curved = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.015),
      end: Offset.zero,
    ).animate(curved);

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      setState(() {
        _currentIndex = widget.index;
      });
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: IndexedStack(
          index: _currentIndex,
          children: widget.children,
        ),
      ),
    );
  }
}
