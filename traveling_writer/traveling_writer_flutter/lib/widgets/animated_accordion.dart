import 'package:flutter/material.dart';
import '../theme/parchment_theme.dart';

/// A fluid micro-animated accordion panel that smoothly expands and collapses
/// with [SizeTransition] and a rotating chevron icon.
class AnimatedAccordion extends StatefulWidget {
  final Widget header;
  final Widget content;
  final Widget? leading;
  final Widget? trailing;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Color? backgroundColor;
  final Color? expandedBorderColor;
  final EdgeInsetsGeometry padding;

  const AnimatedAccordion({
    super.key,
    required this.header,
    required this.content,
    this.leading,
    this.trailing,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.backgroundColor,
    this.expandedBorderColor,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<AnimatedAccordion> createState() => _AnimatedAccordionState();
}

class _AnimatedAccordionState extends State<AnimatedAccordion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _iconTurns;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 240),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final activeBorderColor = _isExpanded
        ? (widget.expandedBorderColor ??
            ParchmentTheme.primaryUmber.withValues(alpha: 0.4))
        : ParchmentTheme.cardBorder;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: activeBorderColor, width: _isExpanded ? 1.4 : 1.0),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleExpand,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: widget.padding,
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: 12),
                  ],
                  Expanded(child: widget.header),
                  if (widget.trailing != null) ...[
                    const SizedBox(width: 8),
                    widget.trailing!,
                  ],
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      Icons.expand_more,
                      size: 20,
                      color: _isExpanded
                          ? ParchmentTheme.primaryUmber
                          : ParchmentTheme.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: SizeTransition(
              sizeFactor: _expandAnimation,
              child: Padding(
                padding: EdgeInsets.only(
                  left: (widget.padding as EdgeInsets).left,
                  right: (widget.padding as EdgeInsets).right,
                  bottom: (widget.padding as EdgeInsets).bottom,
                  top: 4,
                ),
                child: widget.content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
