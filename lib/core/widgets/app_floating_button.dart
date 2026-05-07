import 'package:flutter/cupertino.dart';
import 'package:mexpense/core/constants/constants.dart';

class AppFloatingButton extends StatelessWidget {
  const AppFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: customGradient,
      ),
      child: Icon(CupertinoIcons.add),
    );
  }
}
