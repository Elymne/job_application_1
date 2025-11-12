import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/app/modals/simple_choice_modal.dart';
import 'package:naxan_test/app/screens/home_screen/post_widget.dart';
import 'package:naxan_test/app/screens/home_screen/current_profile_notifier.dart';
import 'package:naxan_test/app/screens/home_screen/new_posts_notifier.dart';
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
    final postBundles = ref.watch(newPostNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // * Top-content.
                Builder(
                  builder: (context) {
                    if (currentProfilAsync.isLoading) {
                      return SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 6),
                      );
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
                                  "Bonjour, ${currentProfilAsync.value!.firstname} 👋",
                                  textAlign: TextAlign.start,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  "Fil d'actualités",
                                  textAlign: TextAlign.start,
                                  style: theme.textTheme.headlineLarge,
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              image: NetworkImage("$serverImagesUrl/${currentProfilAsync.value!.imageId}"),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
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
                  child: Text("Récents", textAlign: TextAlign.start, style: theme.textTheme.bodyLarge),
                ),
                const SizedBox(height: 10),

                // * ListView.
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (postBundles.isLoading) {
                        return Center(
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 6),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: postBundles.value!.length,
                        itemBuilder: (context, index) {
                          final postBundle = postBundles.value![index];

                          return Padding(
                            padding: const EdgeInsetsGeometry.only(top: 10),
                            child: PostWidget(
                              post: postBundle.postModel,
                              profile: postBundle.profileModel,
                              onMore: () async {
                                if (postBundle.postModel.profileId == postBundle.profileModel.id) {
                                  if (await showSimpleChoiceModal(context, "Supprimer la publication ?") ?? false) {
                                    await _newPostsNotifier.deleteById(postBundle.postModel.id);
                                  }
                                  return;
                                }

                                if (await showSimpleChoiceModal(context, "Signaler la publication ?") ?? false) {
                                  await _newPostsNotifier.reportById(postBundle.postModel.id);
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
                padding: const EdgeInsetsGeometry.all(40),
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
                  child: const Icon(Icons.add, color: Colors.black, size: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
