import 'package:naxan_test/app/screens/create_profile_screen/create_profile_notifier.dart';
import 'package:naxan_test/app/modals/simple_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<CreateProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  late final _createProfileNotifier = ref.read(createProfileNotifierProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // * Listener: validation création du profil.
    ref.listen(createProfileNotifierProvider.selectAsync((state) => state.isCreated), (previous, next) async {
      final isCreated = await next;
      if (!isCreated) return;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        AutoRouter.of(context).replacePath('/home');
      });
    });

    // * Listener: erreur formulaire ou server.
    ref.listen(createProfileNotifierProvider.selectAsync((state) => state.errorStack), (previous, next) async {
      final errorStack = await next;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSimpleModal(context, "Oops…", errorStack.last);
      });
    });

    final filepath = ref.watch(createProfileNotifierProvider.select((state) => state.value?.filepath));
    final imageName = filepath?.split("/").last;

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
                  'Créer votre profil.',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 40),

                // * Nom
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nom*', style: theme.textTheme.bodyLarge),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Petit'),
                      keyboardType: TextInputType.name,
                      onChanged: _createProfileNotifier.updateSurname,
                    ),
                    const SizedBox(height: 40),

                    // * Prénom
                    Text('Prénom*', style: theme.textTheme.bodyLarge),
                    TextField(
                      decoration: const InputDecoration(hintText: 'Jean'),
                      keyboardType: TextInputType.name,
                      onChanged: _createProfileNotifier.updateFirstname,
                    ),
                    const SizedBox(height: 40),

                    // * Picker image de profil.
                    Text('Photo de profil*', style: theme.textTheme.bodyLarge),
                    GestureDetector(
                      onTap: () async {
                        final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                        _createProfileNotifier.updateFilepath(pickedFile?.path ?? "");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.download, size: 40, color: Colors.grey),
                            Text(
                              imageName == null || imageName.isEmpty
                                  ? "Appuyez pour choisir une photo"
                                  : "Image stocké: $imageName",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                /// * Continue button *
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _createProfileNotifier.submit();
                    },
                    child: const Text('Continuer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  ),
                ),
                const SizedBox(height: 10),
                Text('*Les champs marqués sont obligatoires', style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
