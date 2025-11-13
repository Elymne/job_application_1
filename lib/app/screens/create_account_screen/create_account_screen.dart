import 'package:naxan_test/app/screens/create_account_screen/create_account_notifier.dart';
import 'package:naxan_test/app/modals/simple_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/app/modals/modal_cgu.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<CreateAccountScreen> {
  late final _createAccountNotifier = ref.read(createAccountNotifierProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // * Listener: validation création du compte.
    ref.listen(createAccountNotifierProvider.selectAsync((state) => state.isCreated), (previous, next) async {
      await showSimpleModal(
        context,
        "Vérifier votre boîte mail",
        "Un email de vérification vous a été envoyé à votre adresse email",
      );

      if (!context.mounted) return;
      AutoRouter.of(context).replacePath('/login');
    });

    // * Listener: erreur formulaire ou server.
    ref.listen(createAccountNotifierProvider.selectAsync((state) => state.errorStack), (previous, next) async {
      final errorMessage = await next;

      if (!context.mounted) return;
      showSimpleModal(context, "Oops…", errorMessage.last);
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

                // * Title*
                Text(
                  'Créer un compte.',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium,
                ),
                const SizedBox(height: 40),

                // * Email field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Adresse email', style: theme.textTheme.labelMedium),
                    TextField(
                      decoration: const InputDecoration(hintText: "joe@gmail.com"),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: _createAccountNotifier.updateEmail,
                    ),
                    const SizedBox(height: 40),

                    // * Password field
                    Text('Mot de passe', style: theme.textTheme.labelMedium),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Mot de passe",
                        suffixIcon: Icon(Icons.remove_red_eye_rounded),
                      ),
                      obscureText: true,
                      onChanged: _createAccountNotifier.updatePassword,
                    ),
                    const SizedBox(height: 40),

                    // * Password confirm field
                    Text('Confirmation Mot de passe', style: theme.textTheme.labelMedium),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Mot de passe",
                        suffixIcon: Icon(Icons.remove_red_eye_rounded),
                      ),
                      obscureText: true,
                      onChanged: _createAccountNotifier.updateConfirmPwd,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                /// * Continue button *
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await showModalCgu(context, _createAccountNotifier) != "submit") return;
                      _createAccountNotifier.submit();
                    },
                    child: const Text('Continuer'),
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
