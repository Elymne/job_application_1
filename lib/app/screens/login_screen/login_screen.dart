import 'package:naxan_test/app/screens/login_screen/login_notifier.dart';
import 'package:naxan_test/app/screens/login_screen/reset_password_notifier.dart';
import 'package:naxan_test/app/modals/modal_reset.dart';
import 'package:naxan_test/app/modals/simple_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<LoginScreen> {
  late final _loginNotifier = ref.read(loginNotifierProvider.notifier);
  late final _resetNotifier = ref.read(resetPasswordNotifierProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // * Ecouteur: Auth.
    ref.listen(loginNotifierProvider.selectAsync((state) => state.success), (previous, next) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AutoRouter.of(context).replacePath('/home');
      });
    });

    // * Ecouteur: Erreur Auth.
    ref.listen(loginNotifierProvider.selectAsync((state) => state.errorStack), (previous, next) async {
      final errorStack = await next;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSimpleModal(context, "Oups…", errorStack.last);
      });
    });

    // * Ecouteur: Password reset.
    ref.listen(resetPasswordNotifierProvider.selectAsync((state) => state.success), (previous, next) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSimpleModal(
          context,
          "Vérifier votre boîte mail",
          "Vous avez reçu un email afin de réinitialiser votre mot de passe.",
        );
      });
    });

    // * Ecouteur: Password reset error.
    ref.listen(resetPasswordNotifierProvider.selectAsync((state) => state.errorStack), (previous, next) async {
      final errorStack = await next;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSimpleModal(context, "Oups…", errorStack.last);
      });
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.all(40),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                // * Main Text *
                Text(
                  'Connectez-vous ou créez un compte.',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium,
                ),
                const SizedBox(height: 40),

                /// * Login Form *
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Adresse email', style: theme.textTheme.labelMedium),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: _loginNotifier.updateEmail,
                      decoration: const InputDecoration(hintText: "john.doe@gmail.com"),
                    ),
                    const SizedBox(height: 40),
                    Text('Mot de passe', style: theme.textTheme.labelMedium),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Mot de passe",
                        suffixIcon: Icon(Icons.remove_red_eye_rounded),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      onChanged: _loginNotifier.updatePassword,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                /// * Reset pwd text *
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mot de passe oublié ? ',
                      style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (await showModalReset(context, _resetNotifier) == "submit") {
                          _resetNotifier.submit();
                        }
                      },
                      child: Text(
                        'Réinitialiser',
                        style: theme.textTheme.labelMedium?.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// * Create new account *
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AutoRouter.of(context).pushPath('/create-account');
                      },
                      child: Text(
                        'Créer un compte',
                        style: theme.textTheme.labelMedium?.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                /// * Submit button *
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _loginNotifier.submit();
                    },
                    child: const Text('Connexion'),
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
