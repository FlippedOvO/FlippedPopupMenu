
```dart
  Widget build(BuildContext context) {
    return FPopupMenu(
      items: [
        FPopupItem(
          text: '测试1',
          icon: 'assets/me.png',
          iconSize: 20,
        ),
        FPopupItem(text: '测试2'),
        FPopupItem(text: '测试3'),
        FPopupItem(text: '测试4'),
      ],
      color: Colors.white,
      pressType: PressType.longPress,
      addDivider: true,
      child: Container(
        color: Colors.red,
        height: 80,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
```
