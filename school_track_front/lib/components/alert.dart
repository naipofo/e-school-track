import 'package:flutter/material.dart';

class WarningAlert extends StatelessWidget {
  const WarningAlert({
    super.key,
    required this.message,
    required this.buttonMessage,
    this.onAction,
  });

  final String message;
  final String buttonMessage;
  final void Function()? onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            TextButton(
              onPressed: onAction,
              child: Text(buttonMessage),
            )
          ],
        ),
      ),
    );
  }
}
