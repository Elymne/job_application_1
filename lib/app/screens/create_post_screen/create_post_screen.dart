import 'package:naxan_test/app/modals/simple_modal.dart';
import 'package:naxan_test/app/screens/create_post_screen/create_post_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<CreatePostScreen> {
  late final _createPostNotifier = ref.read(createPostNotifierProvider.notifier);
  late final _pageController = PageController(initialPage: 0);
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // * Listener: validation création du post.
    ref.listen(createPostNotifierProvider.selectAsync((state) => state.isCreated), (previous, next) async {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Post publié !"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
        ),
      );
      AutoRouter.of(context).replacePath('/home');
    });

    // * Listener: erreur formulaire ou server.
    ref.listen(createPostNotifierProvider.selectAsync((state) => state.errorStack), (previous, next) async {
      final errorStack = await next;

      if (!context.mounted) return;
      showSimpleModal(context, "Oops…", errorStack.last);
    });

    // * Watcher for each buttons (activated or not).
    final filepath = ref.watch(createPostNotifierProvider.select((state) => state.value?.filepath));
    final imageName = filepath?.split("/").last;

    final description = ref.watch(createPostNotifierProvider.select((state) => state.value?.description));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(40),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    // * Page 1
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Choisissez une image', style: theme.textTheme.headlineLarge),
                        const SizedBox(height: 40),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                              _createPostNotifier.updateFilePath(pickedFile?.path ?? "");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                border: BoxBorder.all(color: Colors.black),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.download, size: 40, color: Colors.grey),
                                  imageName == null
                                      ? Text("Appuyez pour choisir une photo", style: theme.textTheme.bodyMedium)
                                      : Text("Photo sélectionnée: $imageName", style: theme.textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: filepath == null || filepath.isEmpty
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();
                                    _pageController.animateToPage(
                                      1,
                                      duration: const Duration(milliseconds: 200),
                                      curve: Curves.bounceInOut,
                                    );
                                  },
                            child: const Text('Suivant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ],
                    ),

                    // * Page 2
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajouter une description',
                          textAlign: TextAlign.start,
                          style: theme.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 40),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(labelText: 'Décrivez votre post…'),
                            onChanged: _createPostNotifier.updateDescription,
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: description == null || description.isEmpty
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();
                                    _createPostNotifier.submit();
                                  },
                            child: const Text('Publier', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
