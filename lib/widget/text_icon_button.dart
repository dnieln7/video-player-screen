import 'package:flutter/material.dart';

class TextIconButton extends StatelessWidget {
  TextIconButton({
    @required this.icon,
    @required this.label,
    this.action,
  });

  final IconData icon;
  final String label;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action ?? () => print('$label pressed'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.black54,
            size: 45,
          ),
          SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}