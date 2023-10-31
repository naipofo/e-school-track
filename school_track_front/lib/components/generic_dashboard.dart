import 'package:flutter/material.dart';

const double mediumWidthBreakpoint = 1000;

class GenericDashboard extends StatelessWidget {
  const GenericDashboard({
    super.key,
    required this.body,
    this.aside,
    this.alerts,
  });

  final List<Widget>? alerts;
  final List<Widget>? aside;
  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var separateColumns = constraints.maxWidth >= mediumWidthBreakpoint;
        return ListView(
          children: [
            if (alerts != null && alerts!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: alerts!),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              ),
              const SizedBox(height: 8.0)
            ],
            if (aside != null)
              separateColumns
                  ? Row(
                      children: [
                        const SizedBox(width: 8.0),
                        panel(aside!, 2),
                        const SizedBox(width: 8.0),
                        panel(body, 7),
                        const SizedBox(width: 8.0),
                      ],
                    )
                  : Column(children: [...aside!, ...body])
          ],
        );
      },
    );
  }

  Expanded panel(List<Widget> children, int flex) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
