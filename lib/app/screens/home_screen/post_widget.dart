import 'package:flutter/material.dart';
import 'package:naxan_test/core/constants.dart';
import 'package:naxan_test/domain/models/post_model.dart';
import 'package:naxan_test/domain/models/profile_model.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;
  final ProfileModel profile;
  final Function() onMore;
  final Function() onClick;
  const PostWidget({super.key, required this.post, required this.profile, required this.onClick, required this.onMore});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        height: 600,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(image: NetworkImage("$serverImagesUrl/${post.imageId}"), fit: BoxFit.cover),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withAlpha(250)],
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: NetworkImage("$serverImagesUrl/${profile.imageId}"),
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
                              Text("${profile.firstname} ${profile.surname}", style: theme.textTheme.bodyLarge),
                              const SizedBox(width: 20),
                              Text(
                                "${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(post.createdAt)).inMinutes} min",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Text(
                            post.description,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.topRight,
              child: Padding(
                padding: const EdgeInsetsGeometry.all(20),
                child: GestureDetector(
                  onTap: onMore,
                  child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
