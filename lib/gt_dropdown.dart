import 'package:flutter/material.dart';

/// A highly customizable dropdown widget for Flutter applications.
///
/// This widget provides a wide range of customization options, including
/// styling, validation, animations, and more. It is designed to be flexible
/// and easy to integrate into any Flutter project.
class GTDropdown<T> extends StatefulWidget {
  /// Margin around the dropdown.
  final EdgeInsets margin;

  /// Custom width for the dropdown.
  final double? width;

  /// Custom height for the dropdown.
  final double? height;

  /// Text alignment for the selected item.
  final TextAlign selectedTextAlign;

  /// The default text displayed when no item is selected.
  final String defaultText;

  /// Background color of the dropdown.
  final Color? backgroundColor;

  /// Background color of the dropdown menu.
  final Color? menuBackgroundColor;

  /// Icon displayed in the dropdown.
  final IconData? dropdownIcon;

  /// Whether the icon is placed at the start of the dropdown.
  final bool isIconAtStart;

  /// Vertical offset for the dropdown menu.
  final double menuOffset;

  /// Text style for the dropdown's selected item.
  final TextStyle? dropdownTextStyle;

  /// Text style for the menu items.
  final TextStyle? menuItemTextStyle;

  /// Text style for the selected menu item.
  final TextStyle? selectedItemTextStyle;

  /// Text style for the highlighted (hovered) menu item.
  final TextStyle? highlightedItemTextStyle;

  /// The list of items to display in the dropdown menu.
  final List<T> items;

  /// Callback triggered when an item is selected.
  final Function(T)? onChanged;

  /// Callback triggered when an item is tapped.
  final Function(T)? onTap;

  /// A function to customize the display text for each item.
  final String Function(T)? displayText;

  /// Whether to show dividers between menu items.
  final bool showDivider;

  /// Color of the divider.
  final Color dividerColor;

  /// Thickness of the divider.
  final double dividerThickness;

  /// Indent of the divider.
  final double dividerIndent;

  /// End indent of the divider.
  final double dividerEndIndent;

  /// Border radius for the dropdown.
  final BorderRadius? dropdownBorderRadius;

  /// Border radius for the dropdown menu.
  final BorderRadius? menuBorderRadius;

  /// Border color of the dropdown menu.
  final Color? menuBorderColor;

  /// Whether to highlight the selected item in the dropdown menu.
  final bool highlightSelectedItem;

  /// Text style for the selected and highlighted item.
  final TextStyle? selectedHighlightTextStyle;

  /// Background color for the selected item in the dropdown menu.
  final Color? selectedItemColor;

  /// Border color of the dropdown.
  final Color? dropdownBorderColor;

  /// A function to validate the selected value.
  final bool Function(T?)? validator;

  /// Error message to display when validation fails.
  final String? validationMessage;

  /// Maximum lines for the validation message.
  final int? validationMaxLines;

  /// Border color when validation fails.
  final Color? errorBorderColor;

  /// Text style for the validation error message.
  final TextStyle? validationTextStyle;

  /// Whether to show the validation message.
  final bool showValidationMessage;

  /// Optional name for form identification.
  final String? name;

  /// Constructor for the GTDropdown widget.
  const GTDropdown({
    super.key,
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.selectedTextAlign = TextAlign.left,
    this.defaultText = 'Select an option',
    this.backgroundColor,
    this.menuBackgroundColor,
    this.dropdownIcon,
    this.isIconAtStart = false,
    this.menuOffset = 0,
    this.dropdownTextStyle,
    this.menuItemTextStyle,
    this.selectedItemTextStyle,
    this.highlightedItemTextStyle,
    required this.items,
    this.onChanged,
    this.onTap,
    this.displayText,
    this.showDivider = false,
    this.dividerColor = Colors.grey,
    this.dividerThickness = 1.0,
    this.dividerIndent = 0.0,
    this.dividerEndIndent = 0.0,
    this.dropdownBorderRadius,
    this.dropdownBorderColor,
    this.menuBorderRadius,
    this.menuBorderColor,
    this.highlightSelectedItem = true,
    this.selectedHighlightTextStyle,
    this.selectedItemColor,
    this.validator,
    this.validationMessage,
    this.validationMaxLines = 2,
    this.errorBorderColor = Colors.red,
    this.validationTextStyle,
    this.showValidationMessage = true,
    this.name,
  });

  @override
  GTDropdownState<T> createState() => GTDropdownState<T>();
}

class GTDropdownState<T> extends State<GTDropdown<T>>
    with SingleTickerProviderStateMixin {
  T? selectedValue;
  T? hoveredValue;
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _dropdownKey = GlobalKey();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller for dropdown menu.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  /// Returns the display text for a given item.
  String _getDisplayText(T item) {
    return widget.displayText?.call(item) ?? item.toString();
  }

  /// Toggles the visibility of the dropdown menu.
  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showDropdown();
    } else {
      _closeDropdown();
    }
  }

  /// Displays the dropdown menu.
  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  /// Closes the dropdown menu.
  void _closeDropdown() {
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  /// Validates the selected value.
  void _validateInput() {
    if (widget.validator != null) {
      setState(() {
        _hasError = !widget.validator!(selectedValue);
      });
    }
  }

  /// Creates an overlay entry for the dropdown menu.
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background overlay to close the dropdown when tapped outside.
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Dropdown menu positioned below the dropdown button.
          Positioned(
            left: offset.dx,
            width: size.width,
            top: offset.dy + size.height + widget.menuOffset,
            child: Material(
              elevation: 4.0,
              borderRadius:
                  widget.menuBorderRadius ?? BorderRadius.circular(4.0),
              child: ClipRRect(
                borderRadius:
                    widget.menuBorderRadius ?? BorderRadius.circular(4.0),
                child: SizeTransition(
                  sizeFactor: _animation,
                  axisAlignment: -1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.menuBackgroundColor ?? Colors.white,
                      border: Border.all(
                        color: widget.menuBorderColor ?? Colors.blue,
                      ),
                      borderRadius:
                          widget.menuBorderRadius ?? BorderRadius.circular(4.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _buildMenuItems(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the list of menu items for the dropdown.
  List<Widget> _buildMenuItems() {
    List<Widget> items = [];
    for (int i = 0; i < widget.items.length; i++) {
      items.add(_buildDropdownItem(widget.items[i]));
      if (widget.showDivider && i < widget.items.length - 1) {
        items.add(Divider(
          color: widget.dividerColor,
          thickness: widget.dividerThickness,
          indent: widget.dividerIndent,
          endIndent: widget.dividerEndIndent,
        ));
      }
    }
    return items;
  }

  /// Builds a single dropdown menu item.
  Widget _buildDropdownItem(T value) {
    final bool isSelected = value == selectedValue;
    final bool isHovered = value == hoveredValue;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredValue = value),
      onExit: (_) => setState(() => hoveredValue = null),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedValue = value;
          });
          widget.onTap?.call(value);
          widget.onChanged?.call(value);
          _validateInput();
          _closeDropdown();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          color: widget.highlightSelectedItem && isSelected
              ? widget.selectedItemColor ?? Colors.blue.shade100
              : isHovered
                  ? Colors.grey[200]
                  : null,
          child: Text(
            _getDisplayText(value),
            textAlign: widget.selectedTextAlign,
            style: widget.highlightSelectedItem && isSelected
                ? widget.selectedHighlightTextStyle ??
                    widget.selectedItemTextStyle
                : isHovered
                    ? widget.highlightedItemTextStyle
                    : widget.menuItemTextStyle,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.width ?? double.infinity,
          padding: widget.margin,
          child: FormField<T>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (widget.validator != null &&
                  !widget.validator!(selectedValue)) {
                return widget.validationMessage;
              }
              return null;
            },
            builder: (FormFieldState<T> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _toggleDropdown,
                    child: Container(
                      key: _dropdownKey,
                      height: widget.height,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ?? Colors.white,
                        border: Border.all(
                          color: (state.hasError || _hasError)
                              ? widget.errorBorderColor!
                              : widget.dropdownBorderColor ?? Colors.blue,
                        ),
                        borderRadius: widget.dropdownBorderRadius ??
                            BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (widget.isIconAtStart)
                            Icon(
                              widget.dropdownIcon ?? Icons.arrow_drop_down,
                              color: widget.dropdownTextStyle?.color,
                            ),
                          Expanded(
                            child: Text(
                              selectedValue != null
                                  ? _getDisplayText(selectedValue as T)
                                  : widget.defaultText,
                              textAlign: widget.selectedTextAlign,
                              style: widget.dropdownTextStyle,
                            ),
                          ),
                          if (!widget.isIconAtStart)
                            Icon(
                              widget.dropdownIcon ?? Icons.arrow_drop_down,
                              color: widget.dropdownTextStyle?.color,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (state.hasError && widget.showValidationMessage)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                      child: Text(
                        widget.validationMessage ?? '',
                        style: widget.validationTextStyle ??
                            TextStyle(
                              color: widget.errorBorderColor,
                              fontSize: 12,
                            ),
                        maxLines: widget.validationMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
