import 'package:flutter/material.dart';
import 'package:naxan_test/core/themes/custom_color.dart';

void showModalResetSuccess(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Vérifier votre boite mail',
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: customBlue,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: const Text(
        'Vous avez reçu un email afin de réinitialiser votre mot de passe.',
        textAlign: TextAlign.center,
        style: TextStyle(color: customGrey, fontSize: 20),
      ),
      actions: [
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
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Fermer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    ),
  );
}
