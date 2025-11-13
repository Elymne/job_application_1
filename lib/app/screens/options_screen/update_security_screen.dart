import 'package:naxan_test/app/screens/options_screen/update_security_notifier.dart';
import 'package:naxan_test/app/modals/simple_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class UpdateSecurityScreen extends ConsumerStatefulWidget {
  const UpdateSecurityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<UpdateSecurityScreen> {
  late final _updateSecurityNotifier = ref.read(updateSecurityNotifierProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(updateSecurityNotifierProvider.selectAsync((state) => state.success), (previous, next) async {
      await showSimpleModal(context, "Modification", "Votre mot de passe a bien été modifié");

      if (!context.mounted) return;
      AutoRouter.of(context).replacePath('/options');
    });

    ref.listen(updateSecurityNotifierProvider.selectAsync((state) => state.errorStack), (previous, next) async {
      final errorStack = await next;

      if (!context.mounted) return;
      showSimpleModal(context, "Oups…", errorStack.last);
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.all(40),
            child: Column(
              children: [
                // * Main Text *
                Text('Mot de passe', maxLines: 2, textAlign: TextAlign.center, style: theme.textTheme.displayMedium),
                const SizedBox(height: 40),

                /// * Login Form *
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mot de passe actuel*', style: theme.textTheme.labelMedium),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Mot de passe"),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      onChanged: _updateSecurityNotifier.updatePassword,
                    ),
                    const SizedBox(height: 40),
                    Text('Nouveau mot de passe*', style: theme.textTheme.labelMedium),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Nouveau mot de passe"),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      onChanged: _updateSecurityNotifier.updateNewPassword,
                    ),
                    const SizedBox(height: 40),
                    Text('Confirmez nouveau mot de passe*', style: theme.textTheme.labelMedium),
                    TextFormField(
                      decoration: const InputDecoration(hintText: "Confirmez nouveau mot de passe"),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      onChanged: _updateSecurityNotifier.updateNewPasswordConfirm,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                /// * Submit button *
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _updateSecurityNotifier.submit(),
                    child: const Text('Modifier'),
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
