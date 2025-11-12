import 'package:flutter/material.dart';

/// Modal d'alerte basique (erreur ou validation).
Future<String?> showSimpleModal(BuildContext context, String title, String message) async {
  final theme = Theme.of(context);

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title, maxLines: 2, textAlign: TextAlign.center, style: theme.textTheme.headlineLarge),
      content: Text(message, textAlign: TextAlign.center, style: theme.textTheme.headlineMedium),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
        ),
      ],
    ),
  );
}
