import 'package:flutter/material.dart';

class HoverDropdownMenu extends StatefulWidget {
  final Widget child;
  final List<DropdownMenuItemData> items;
  final double width;

  const HoverDropdownMenu({
    Key? key,
    required this.child,
    required this.items,
    this.width = 180,
  }) : super(key: key);

  @override
  State<HoverDropdownMenu> createState() => _HoverDropdownMenuState();
}

class DropdownMenuItemData {
  final String label;
  final VoidCallback onTap;

  DropdownMenuItemData({required this.label, required this.onTap});
}

class _HoverDropdownMenuState extends State<HoverDropdownMenu> {
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isHovering = false;

  void _showDropdown() {
    if (_overlayEntry != null) return;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context);
    if (renderBox == null || overlay == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy + size.height,
        child: MouseRegion(
          onEnter: (_) => _setHover(true),
          onExit: (_) => _scheduleHide(),
          child: Material(
            elevation: 4,
            color: Colors.transparent,
            child: Container(
              width: widget.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(widget.items.length, (index) {
                  final item = widget.items[index];
                  final isLast = index == widget.items.length - 1;

                  return InkWell(
                    onTap: () {
                      _hideDropdown();
                      item.onTap();
                    },
                    hoverColor: Colors.grey[200],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : const Border(
                                bottom: BorderSide(color: Colors.grey, width: 0.5),
                              ),
                      ),
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _setHover(bool hovering) {
    _isHovering = hovering;
  }

  void _scheduleHide() {
    _setHover(false);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!_isHovering) {
        _hideDropdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _key,
      onEnter: (_) {
        _setHover(true);
        _showDropdown();
      },
      onExit: (_) => _scheduleHide(),
      child: widget.child,
    );
  }
}
