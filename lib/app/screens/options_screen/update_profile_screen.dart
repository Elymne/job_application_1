import 'package:naxan_test/app/modals/simple_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:naxan_test/app/notifiers/current_profile_notifier.dart';
import 'package:naxan_test/app/screens/options_screen/update_profile_notifier.dart';

@RoutePage()
class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<UpdateProfileScreen> {
  late final _currentProfileNotifier = ref.read(currentProfileNotifierProvider.notifier);
  late final _updateProfileNotifier = ref.read(updateProfileNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentProfileNotifier.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(updateProfileNotifierProvider.selectAsync((state) => state.success), (previous, next) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AutoRouter.of(context).replacePath('/options');
      });
    });

    ref.listen(updateProfileNotifierProvider.selectAsync((state) => state.errorStack), (previous, next) async {
      final errorStack = await next;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSimpleModal(context, "Oups…", errorStack.last);
      });
    });

    ref.listen(currentProfileNotifierProvider, (previous, next) async {
      if (next.isLoading || next.hasError) return;

      final profile = next.value;
      if (profile == null) return;

      _updateProfileNotifier.updateFirstname(profile.firstname);
      _updateProfileNotifier.updateSurname(profile.surname);
    });

    final profileAsync = ref.watch(currentProfileNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Builder(
        builder: (context) {
          if (profileAsync.isLoading) {
            return Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 6),
              ),
            );
          }

          if (profileAsync.hasError) {
            return const Center(child: Text("Une erreur s'est produite…"));
          }

          final profile = profileAsync.value;
          if (profile == null) {
            return const Center(child: Text("Vous n'avez pas de profil…"));
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsGeometry.all(40),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                    // * Main Text *
                    Text(
                      'Infos Personnelles',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium,
                    ),
                    const SizedBox(height: 40),

                    /// * Login Form *
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prénon*', style: theme.textTheme.labelMedium),
                        TextFormField(
                          initialValue: profile.firstname,
                          keyboardType: TextInputType.name,
                          onChanged: _updateProfileNotifier.updateFirstname,
                          decoration: const InputDecoration(hintText: "Ex.John"),
                        ),
                        const SizedBox(height: 40),
                        Text('Nom*', style: theme.textTheme.labelMedium),
                        TextFormField(
                          initialValue: profile.surname,
                          decoration: const InputDecoration(hintText: "Ex.Doe"),
                          keyboardType: TextInputType.name,
                          onChanged: _updateProfileNotifier.updateSurname,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    /// * Submit button *
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _updateProfileNotifier.submit();
                        },
                        child: const Text('Enregistrer'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
