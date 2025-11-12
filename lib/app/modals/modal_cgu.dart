import 'package:flutter/material.dart';
import 'package:naxan_test/app/screens/create_account_screen/create_account_notifier.dart';

Future<String?> showModalCgu(BuildContext context, CreateAccountNotifier notifier) async {
  final theme = Theme.of(context);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) {
      bool checkboxValue = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 40,
              right: 40,
              top: 40,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'CGVU et politique de confidentialité',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 20),

                // Scrollbar
                SizedBox(
                  height: 400,
                  child: Scrollbar(
                    thumbVisibility: true, // always show the scroll bar
                    child: SingleChildScrollView(
                      child: Text(lorem + lorem + lorem + lorem + lorem, style: theme.textTheme.headlineMedium),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Checkbox
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: checkboxValue,
                      onChanged: (value) {
                        setState(() {
                          checkboxValue = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "J'accepte la politique de confidentialités et les conditions générales de ventes et d'utilisation.",
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: checkboxValue
                        ? () {
                            Navigator.pop(context, 'submit');
                          }
                        : null,
                    child: const Text('Continuer'),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      );
    },
  );
}

const lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique, tortor nec consequat gravida, libero turpis posuere justo, nec tincidunt libero lorem vel velit. Praesent euismod, justo nec facilisis faucibus, elit lorem efficitur enim, et tincidunt neque ligula vel mi. Integer finibus imperdiet metus, id tincidunt arcu. Suspendisse potenti. Nulla facilisi. Curabitur ac leo non nisl gravida rhoncus. Mauris euismod nunc sit amet lectus cursus, in dapibus mi hendrerit.";
