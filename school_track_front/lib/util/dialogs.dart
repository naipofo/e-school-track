import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  final String title;
  final Widget message;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: message,
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            onConfirm();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
