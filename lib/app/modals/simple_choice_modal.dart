import 'package:flutter/material.dart';

/// Modal faite à la vavite.
Future<bool?> showSimpleChoiceModal(BuildContext context, String title) async {
  final theme = Theme.of(context);

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title, maxLines: 2, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
      actions: [
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Oui")),
        ElevatedButton(onPressed: () => Navigator.pop(context, false), child: const Text("Non")),
      ],
    ),
  );
}
