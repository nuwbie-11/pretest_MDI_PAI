import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String name;
  final void Function() onPressed;
  MyButton({Key? key, required this.name, required this.onPressed})
      : super(key: key);

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: Text(widget.name),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          elevation: 0,
        ),
      ),
    );
  }
}
