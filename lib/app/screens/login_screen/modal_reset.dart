import 'package:flutter/material.dart';
import 'package:naxan_test/app/screens/login_screen/states/reset_notifier.dart';
import 'package:naxan_test/core/themes/custom_color.dart';

void showModalReset(BuildContext context, ResetNotifier resetNotifier) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 60,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Réinitialiser mot de passe',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: customBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Entrez l'adresse email associée à votre compte. Nous vous enverrons un email de réinitialisation sur celle-ci",
                textAlign: TextAlign.center,
                style: TextStyle(color: customGrey, fontSize: 18),
              ),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Adresse email',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'john.doe@gmail.com',
                  labelStyle: TextStyle(color: customGrey),
                ),
                onChanged: (text) {
                  resetNotifier.updateEmail(text);
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: customBlue,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      side: BorderSide.none,
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    resetNotifier.submit();
                  },
                  child: const Text(
                    'Réinitialiser',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
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
