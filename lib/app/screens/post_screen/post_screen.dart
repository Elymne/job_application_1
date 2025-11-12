import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:naxan_test/app/screens/post_screen/post_screen_notifier.dart';
import 'package:naxan_test/core/constants.dart';

@RoutePage()
class PostScreen extends ConsumerStatefulWidget {
  final String id;

  const PostScreen({super.key, @PathParam('id') required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<PostScreen> {
  late final _postScreenNotifier = ref.read(postScreenNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _postScreenNotifier.load(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final postBundleAsync = ref.watch(postScreenNotifierProvider);

    if (postBundleAsync.isLoading) {
      return Center(
        child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 6),
        ),
      );
    }

    if (postBundleAsync.hasError) {
      return Center(child: Text(postBundleAsync.error.toString()));
    }

    final postBundle = postBundleAsync.value;
    if (postBundle == null) {
      return const Center(child: Text("Le post n'existe pas…"));
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: NetworkImage("$serverImagesUrl/${postBundle.postModel.imageId}"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsetsGeometry.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: NetworkImage("$serverImagesUrl/${postBundle.profileModel.imageId}"),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${postBundle.profileModel.firstname} ${postBundle.profileModel.surname}",
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(postBundle.postModel.createdAt)).inMinutes} min",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Text(postBundle.postModel.description, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
