import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final Function() onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            : Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
