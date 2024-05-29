import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback func;
  final String text;
  const MyButton({super.key, required this.func, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>func(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,

        ),
        padding: const EdgeInsets.all(25),
        margin:  const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
