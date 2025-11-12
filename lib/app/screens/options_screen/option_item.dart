import 'package:flutter/material.dart';

class OptionItem extends StatelessWidget {
  final Widget? prefix;
  final Widget? sufixe;
  final String? firstText;
  final String? lastText;
  final Function()? onClick;

  const OptionItem({super.key, this.prefix, this.sufixe, this.firstText, this.lastText, this.onClick});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          prefix ?? const SizedBox(),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              firstText != null
                  ? Text(firstText!, textAlign: TextAlign.start, style: theme.textTheme.bodyLarge)
                  : const SizedBox(),
              lastText != null
                  ? Text(lastText!, textAlign: TextAlign.start, style: theme.textTheme.bodyMedium)
                  : const SizedBox(),
            ],
          ),
          const Expanded(child: SizedBox()),
          sufixe ?? const SizedBox(),
        ],
      ),
    );
  }
}
