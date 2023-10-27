import 'package:flutter/material.dart';

class ThinForm extends StatelessWidget {
  const ThinForm({
    super.key,
    this.errorMessage,
    required this.children,
  });

  final String? errorMessage;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            children: [
              ...children,
              const SizedBox(height: 8),
              if (errorMessage != null)
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 0,
                    color: theme.colorScheme.error,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Error: ${errorMessage!}",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.colorScheme.onError),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
