import 'package:flutter/material.dart';

enum PressType {
  tap,
  longPress,
}

class FPopupMenu<T> extends StatefulWidget {
  const FPopupMenu({
    super.key,
    required this.items,
    this.initialValue,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.splashRadius,
    this.offset = Offset.zero,
    this.enabled = true,
    this.shape,
    this.color,
    this.enableFeedback,
    this.constraints,
    this.position,
    this.clipBehavior = Clip.none,
    this.pressType = PressType.tap,
    this.addDivider = false,
  });

  final List<PopupMenuEntry<T>> items;

  final T? initialValue;

  final PressType pressType;

  final VoidCallback? onOpened;
  final PopupMenuItemSelected<T>? onSelected;
  final PopupMenuCanceled? onCanceled;
  final String? tooltip;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final EdgeInsetsGeometry padding;
  final double? splashRadius;
  final Widget? child;
  final Offset offset;
  final bool enabled;
  final ShapeBorder? shape;
  final Color? color;
  final bool? enableFeedback;
  final BoxConstraints? constraints;
  final PopupMenuPosition? position;
  final Clip clipBehavior;
  final bool addDivider;

  @override
  State<FPopupMenu<T>> createState() => _FPopupMenuState<T>();
}

class _FPopupMenuState<T> extends State<FPopupMenu<T>> {
  void showButtonMenu() {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(point!, ancestor: overlay),
        button.localToGlobal(point!, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    List<PopupMenuEntry<T>> items = widget.items;

    if (widget.addDivider) {
      final items2 = items
          .sublist(0, items.length - 1)
          .fold<List<PopupMenuEntry<T>>>([], (acc, x) {
        acc.addAll([x, const PopupMenuDivider()]);
        return acc;
      });
      items2.add(items.last);
      items = items2;
    }

    // Only show the menu if there is something to show
    if (items.isNotEmpty) {
      widget.onOpened?.call();
      showMenu<T?>(
        context: context,
        elevation: widget.elevation ?? popupMenuTheme.elevation,
        shadowColor: widget.shadowColor ?? popupMenuTheme.shadowColor,
        surfaceTintColor:
            widget.surfaceTintColor ?? popupMenuTheme.surfaceTintColor,
        items: items,
        initialValue: widget.initialValue,
        position: position,
        shape: widget.shape ?? popupMenuTheme.shape,
        color: widget.color ?? popupMenuTheme.color,
        constraints: widget.constraints,
        clipBehavior: widget.clipBehavior,
      ).then<void>((T? newValue) {
        if (!mounted) {
          return null;
        }
        if (newValue == null) {
          widget.onCanceled?.call();
          return null;
        }
        widget.onSelected?.call(newValue);
      });
    }
  }

  Offset? point;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        point = details.localPosition;
      },
      onTap: () {
        if (widget.pressType == PressType.tap) {
          showButtonMenu();
        }
      },
      onLongPress: () {
        if (widget.pressType == PressType.longPress) {
          showButtonMenu();
        }
      },
      child: widget.child,
    );
  }
}

class FPopupItem<T> extends PopupMenuItem<T> {
  FPopupItem({
    super.key,
    Widget? child,
    super.value,
    String? text,
    double? fontSize,
    Color? fontColor,
    FontWeight? fontWeight,
    String? icon,
    double? iconSize,
    double? height,
  })  : assert(
          !(child == null && text == null),
          'child 或 text 必须传入一项',
        ),
        super(
          child: child ??
              _FPopupChild(
                text: text!,
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontColor: fontColor,
                icon: icon,
                iconSize: iconSize,
              ),
          height: height ?? 20,
        );
}

class _FPopupChild extends StatelessWidget {
  const _FPopupChild({
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.fontColor,
    this.icon,
    this.iconSize,
  });

  final String text;
  final double? fontSize;
  final Color? fontColor;
  final FontWeight? fontWeight;

  final String? icon;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final bool showIcon = icon != null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          showIcon ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
        if (showIcon)
          Image.asset(
            icon!,
            width: iconSize,
            height: iconSize,
          ),
      ],
    );
  }
}
