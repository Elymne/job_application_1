import 'package:flutter/material.dart';

class OptionItem extends StatelessWidget {
  final Widget? prefix;
  final Widget? sufixe;
  final String? firstText;
  final String? lastText;
  final Function()? onTap;

  const OptionItem({super.key, this.prefix, this.sufixe, this.firstText, this.lastText, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            prefix ?? const SizedBox(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  firstText != null
                      ? Text(
                          firstText!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary),
                        )
                      : const SizedBox(),
                  lastText != null
                      ? Text(
                          lastText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),

            sufixe ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}
