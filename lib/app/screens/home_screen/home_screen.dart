import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/app/modals/modal_select.dart';
import 'package:naxan_test/app/screens/home_screen/post_widget.dart';
import 'package:naxan_test/app/notifiers/current_profile_notifier.dart';
import 'package:naxan_test/app/notifiers/new_posts_notifier.dart';
import 'package:naxan_test/core/constants.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<HomeScreen> {
  late final _currentProfileNotifier = ref.read(currentProfileNotifierProvider.notifier);
  late final _newPostsNotifier = ref.read(newPostNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _currentProfileNotifier.load();
      _newPostsNotifier.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentProfilAsync = ref.watch(currentProfileNotifierProvider);
    final postBundlesAsync = ref.watch(newPostNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // todo: En faire un widget à part.
                Builder(
                  builder: (context) {
                    if (currentProfilAsync.isLoading) {
                      return SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 6),
                      );
                    }

                    if (currentProfilAsync.hasError) {
                      return const Text("Erreur de profil…");
                    }

                    final currentProfile = currentProfilAsync.value;
                    if (currentProfile == null) {
                      return const Text("Pas de profil™");
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bonjour, ${currentProfile.firstname} 👋",
                                  textAlign: TextAlign.start,
                                  style: theme.textTheme.titleMedium,
                                ),
                                Text("Fil d'actualités", textAlign: TextAlign.start, style: theme.textTheme.titleLarge),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              AutoRouter.of(context).pushPath("/options");
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image(
                                image: NetworkImage("$serverImagesUrl/${currentProfile.imageId}"),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // * Divider.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(height: 1, color: const Color.fromARGB(255, 199, 199, 199)),
                ),
                const SizedBox(height: 10),

                // * Title.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text("Récents", textAlign: TextAlign.start, style: theme.textTheme.titleSmall),
                ),
                const SizedBox(height: 10),

                // * ListView.
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (postBundlesAsync.isLoading) {
                        return Center(
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 6),
                          ),
                        );
                      }

                      if (postBundlesAsync.hasError) {
                        return const Text("Erreur de profil…");
                      }

                      final postBundles = postBundlesAsync.value;
                      if (postBundles == null) {
                        return const Text("Pas de posts il semblerait");
                      }

                      return ListView.builder(
                        itemCount: postBundles.length,
                        itemBuilder: (context, index) {
                          final postBundle = postBundles[index];
                          return Padding(
                            padding: const EdgeInsetsGeometry.only(top: 10),
                            child: PostWidget(
                              post: postBundle.postModel,
                              profile: postBundle.profileModel,
                              onClick: () {
                                AutoRouter.of(context).pushPath("/post/${postBundle.postModel.id}");
                              },
                              onMore: () async {
                                if (postBundle.postModel.profileId == currentProfilAsync.value?.id) {
                                  final res = await showSimpleModalSelect(context, [
                                    {
                                      "code": "delete",
                                      "text": Text(
                                        "Supprimer cette publication",
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          color: const Color.fromARGB(255, 255, 0, 0),
                                        ),
                                      ),
                                    },
                                  ]);
                                  if (res == 'delete') {
                                    await _newPostsNotifier.deleteById(postBundle.postModel.id);
                                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),

                                          content: const Text("Post supprimé !"),
                                          backgroundColor: const Color.fromARGB(255, 228, 15, 15),
                                          duration: const Duration(seconds: 2),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                      );
                                    });
                                  }
                                  return;
                                }

                                final res = await showSimpleModalSelect(context, [
                                  {
                                    "code": "report",
                                    "text": Text(
                                      "Signaler cette publication",
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.titleSmall?.copyWith(
                                        color: const Color.fromARGB(255, 255, 0, 0),
                                      ),
                                    ),
                                  },
                                ]);

                                if (res == 'report') {
                                  await _newPostsNotifier.reportById(postBundle.postModel.id);
                                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),

                                        content: const Text("Post signalé !"),
                                        backgroundColor: const Color.fromARGB(255, 228, 15, 15),
                                        duration: const Duration(seconds: 2),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    );
                                  });
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            // * Add button
            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: Padding(
                padding: const EdgeInsetsGeometry.all(20),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(100),
                      side: BorderSide.none,
                    ),
                  ),
                  onPressed: () async {
                    await AutoRouter.of(context).pushPath("/create-post");
                  },
                  child: const Icon(Icons.add, color: Colors.black, size: 60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
