import 'package:flutter/material.dart';

/// Modal d'alerte basique (erreur ou validation).
Future<String?> showSimpleModalSelect(BuildContext context, List<Map<String, dynamic>> options) async {
  final theme = Theme.of(context);
  final backgroundColor = const Color.fromARGB(255, 245, 245, 245);

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
                color: backgroundColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Text(
                'Que souhaitez-vous faire',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),

            ...List.generate(options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 1),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, options[index]["code"]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,

                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: options.length - 1 != index
                            ? BorderRadius.zero
                            : const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                      ),
                    ),
                    child: options[index]["text"],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 4,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                child: Text(
                  'Annuler',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
