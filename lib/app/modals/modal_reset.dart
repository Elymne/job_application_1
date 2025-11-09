import 'package:flutter/material.dart';
import 'package:naxan_test/app/screens/login_screen/reset_password_notifier.dart';

Future<String?> showModalReset(BuildContext context, ResetPasswordNotifier resetNotifier) {
  final theme = Theme.of(context);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 20, right: 20, top: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Réinitialiser mot de passe',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Entrez l'adresse email associée à votre compte. Nous vous enverrons un email de réinitialisation sur celle-ci",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Adresse email', style: theme.textTheme.labelLarge),
              ),
              TextField(
                decoration: const InputDecoration(hintText: "john.doe@gmail.com"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  resetNotifier.updateEmail(text);
                },
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'submit');
                  },
                  child: const Text('Réinitialiser'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    },
  );
}
