import 'package:flutter/material.dart';

/// Modal d'alerte basique (erreur ou validation).
Future<String?> showSimpleModalSelect(BuildContext context, Map<String, String> options) async {
  final theme = Theme.of(context);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Que souhaitez-vous faire', maxLines: 1, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
          ListView.builder(
            itemBuilder: (context, index) {
              return SizedBox();
            },
          ),
          Text('Annuler', maxLines: 1, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        ],
      );
    },
  );
}
