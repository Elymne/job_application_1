import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/app/screens/login_screen/modal_login_failure.dart';
import 'package:naxan_test/app/screens/login_screen/modal_reset.dart';
import 'package:naxan_test/app/screens/login_screen/modal_reset_failure.dart';
import 'package:naxan_test/app/screens/login_screen/modal_reset_success.dart';
import 'package:naxan_test/app/screens/login_screen/states/login_notifier.dart';
import 'package:naxan_test/app/screens/login_screen/states/reset.dart';
import 'package:naxan_test/app/screens/login_screen/states/reset_notifier.dart';
import 'package:naxan_test/core/themes/custom_color.dart';

@RoutePage()
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<LoginScreen> {
  late final _loginNotifier = ref.read(loginNotifierProvider.notifier);
  late final _resetNotifier = ref.read(resetNotifierProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).size.height * 0.1;

    // * Login state management.
    ref.listen(loginNotifierProvider, (previous, next) {
      if (next.asData?.value.status == LoginStatus.success) {
        // Next screen.
        return;
      }

      if (next.asData?.value.status == LoginStatus.failure) {
        showModalLoginFailure(
          context,
          next.asData?.value.errorMessage ?? "Erreur inconnue",
        );
        return;
      }
    });

    // * Reset state management.
    ref.listen(resetNotifierProvider, (previous, next) {
      if (next.asData?.value.state == ResetState.success) {
        Navigator.of(context).pop();
        _resetNotifier.reset();
        showModalResetSuccess(context);
        return;
      }

      if (next.asData?.value.state == ResetState.failure) {
        Navigator.of(context).pop();
        _resetNotifier.reset();
        showModalResetFailure(context);
        return;
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.all(40),
            child: Column(
              children: [
                SizedBox(height: topPadding),

                /// * Main Text *
                const Text(
                  'Connectez-vous ou créez un compte.',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: customBlue,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),

                /// * Login Form *
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Adresse email',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'john.doe@gmail.com',
                        labelStyle: TextStyle(color: customGrey),
                      ),
                      onChanged: _loginNotifier.updateEmail,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Mot de passe',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Mot de passe',
                        icon: Icon(
                          Icons.remove_red_eye_rounded,
                          color: customGrey,
                        ),
                        labelStyle: TextStyle(color: customGrey),
                      ),
                      obscureText: true,
                      onChanged: _loginNotifier.updatePwd,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                /// * Reset pwd text *
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Mot de passe oublié ? ',
                      style: TextStyle(color: customGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        // FocusScope.of(context).unfocus();
                        showModalReset(context, _resetNotifier);
                      },
                      child: const Text(
                        'Réinitialiser',
                        style: TextStyle(
                          color: customBlue,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                /// * Submit button *
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
                      _loginNotifier.submit();
                    },
                    child: const Text(
                      'Connexion',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
