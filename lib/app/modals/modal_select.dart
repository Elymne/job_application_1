import 'package:flutter/material.dart';

/// Modal d'alerte basique (erreur ou validation).
Future<String?> showSimpleModalSelect(BuildContext context, List<Map<String, dynamic>> options) async {
  final theme = Theme.of(context);

  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(220),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Text(
                'Que souhaitez-vous faire',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),

            ...List.generate(options.length, (index) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, options[index]["code"]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(220),
                      // borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: SizedBox(child: options[index]["text"]),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => Navigator.pop(context, null),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  'Annuler',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
