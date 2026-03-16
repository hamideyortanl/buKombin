import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class WardrobeHeader extends StatefulWidget {
  final String title;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final bool grid;
  final VoidCallback onToggleGrid;
  final VoidCallback onOpenFilter;
  final bool filterActionOpen;
  final ValueChanged<bool> onFilterActionChanged;
  final FocusNode focusNode;

  const WardrobeHeader({
    super.key,
    required this.title,
    required this.query,
    required this.onQueryChanged,
    required this.grid,
    required this.onToggleGrid,
    required this.onOpenFilter,
    required this.filterActionOpen,
    required this.onFilterActionChanged,
    required this.focusNode,
  });

  @override
  State<WardrobeHeader> createState() => _WardrobeHeaderState();
}

class _WardrobeHeaderState extends State<WardrobeHeader> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);

    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant WardrobeHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChanged);
      widget.focusNode.addListener(_handleFocusChanged);
    }
  }

  void _handleFocusChanged() {
    final shouldOpen =
        widget.focusNode.hasFocus || _controller.text.trim().isNotEmpty;

    if (shouldOpen != widget.filterActionOpen) {
      widget.onFilterActionChanged(shouldOpen);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        BuKombinMetrics.headerHorizontalPadding,
        MediaQuery.of(context).padding.top + BuKombinMetrics.headerTopPadding,
        BuKombinMetrics.headerHorizontalPadding,
        BuKombinMetrics.headerBottomPadding,
      ),
      decoration: BuKombinDecorations.headerBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: BuKombinColors.beige1,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _GlassTextField(
            controller: _controller,
            focusNode: widget.focusNode,
            hintText: 'Parça ara...',
            prefixIcon: Icons.search,
            onTap: () => widget.onFilterActionChanged(true),
            onChanged: (value) {
              widget.onQueryChanged(value);

              final shouldOpen =
                  widget.focusNode.hasFocus || value.trim().isNotEmpty;

              if (shouldOpen != widget.filterActionOpen) {
                widget.onFilterActionChanged(shouldOpen);
              }

              setState(() {});
            },
            onClear: () {
              _controller.clear();
              widget.onQueryChanged('');
              widget.focusNode.unfocus();
              widget.onFilterActionChanged(false);
              setState(() {});
            },
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: widget.filterActionOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _GlassButton(
                      onTap: widget.onOpenFilter,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.tune,
                              color: BuKombinColors.beige1, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Filtrele',
                            style: TextStyle(color: BuKombinColors.beige1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _GlassButton(
                    width: 54,
                    height: 46,
                    onTap: widget.onToggleGrid,
                    child: Icon(
                      widget.grid
                          ? Icons.view_agenda_outlined
                          : Icons.grid_view_rounded,
                      color: BuKombinColors.beige1,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData prefixIcon;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _GlassTextField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    required this.onChanged,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
      BuKombinDecorations.glassSurface(alpha: 0.12, borderAlpha: 0.18),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(color: BuKombinColors.beige1),
        decoration: BuKombinInputStyles.headerSearch(
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const _GlassButton({
    required this.child,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            padding: width == null
                ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12)
                : null,
            decoration: BuKombinDecorations.glassSurface(),
            child: child,
          ),
        ),
      ),
    );
  }
}