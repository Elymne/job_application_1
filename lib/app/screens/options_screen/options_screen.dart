import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/app/modals/modal_select.dart';
import 'package:naxan_test/app/notifiers/current_profile_notifier.dart';
import 'package:naxan_test/app/screens/options_screen/option_item.dart';
import 'package:naxan_test/core/constants.dart';

@RoutePage()
class OptionsScreen extends ConsumerStatefulWidget {
  const OptionsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<OptionsScreen> {
  late final _currentProfileNotifier = ref.read(currentProfileNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _currentProfileNotifier.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(currentProfileNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (profileAsync.isLoading) {
              return const Center(child: SizedBox(height: 60, width: 60, child: CircularProgressIndicator()));
            }

            if (profileAsync.hasError) {
              return const Center(child: Text("Une erreur s'est produite…"));
            }

            final profile = profileAsync.value;
            if (profile == null) {
              return const Center(child: Text("Vous n'avez pas de profil…"));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsGeometry.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          final modalResult = await showSimpleModalSelect(context, [
                            {
                              "code": "logout",
                              "text": Text(
                                "Se déconnecter",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: const Color.fromARGB(255, 255, 0, 0),
                                ),
                              ),
                            },
                            {
                              "code": "delete",
                              "text": Text(
                                "Supprimer mon profil",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: const Color.fromARGB(255, 255, 0, 0),
                                ),
                              ),
                            },
                          ]);

                          if (modalResult == "logout") {
                            await _currentProfileNotifier.logout();
                            if (!context.mounted) return;
                            AutoRouter.of(context).replacePath("/login");
                            return;
                          }

                          if (modalResult == "delete") {
                            await _currentProfileNotifier.deleteAccount();
                            if (!context.mounted) return;
                            AutoRouter.of(context).replacePath("/login");
                          }
                        },
                        child: Icon(Icons.more_horiz, size: 40, color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: NetworkImage("$serverImagesUrl/${profile.imageId}"),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("${profile.firstname} ${profile.surname}", style: theme.textTheme.displayMedium),
                    Text(profile.email, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 10),

                    // * Divider.
                    Container(height: 1, color: const Color.fromARGB(255, 199, 199, 199)),
                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mon compte", style: theme.textTheme.displaySmall),
                        const SizedBox(height: 10),
                        OptionItem(
                          prefix: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              image: NetworkImage("$serverImagesUrl/${profile.imageId}"),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          firstText: "${profile.firstname} ${profile.surname}",
                          lastText: profile.email,
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () => AutoRouter.of(context).pushPath("/options/profile"),
                        ),
                        const SizedBox(height: 10),

                        OptionItem(
                          prefix: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: theme.colorScheme.primary,
                              padding: const EdgeInsets.all(15),
                              child: const Icon(Icons.lock_open_outlined, size: 30, color: Colors.white),
                            ),
                          ),
                          firstText: "Sécurité",
                          lastText: "Mot de passe, email…",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () => AutoRouter.of(context).pushPath("/options/security"),
                        ),
                        const SizedBox(height: 20),

                        Text("Paramètres", style: theme.textTheme.displaySmall),
                        const SizedBox(height: 10),

                        OptionItem(
                          prefix: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: theme.colorScheme.primary,
                              padding: const EdgeInsets.all(15),
                              child: const Icon(Icons.notification_add_outlined, size: 30, color: Colors.white),
                            ),
                          ),
                          firstText: "Notifications push",
                          lastText: "Activées",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                        ),
                        const SizedBox(height: 20),

                        Text("Autres", style: theme.textTheme.displaySmall),
                        const SizedBox(height: 10),

                        OptionItem(
                          prefix: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: theme.colorScheme.primary,
                              padding: const EdgeInsets.all(15),
                              child: const Icon(Icons.help_outline, size: 30, color: Colors.white),
                            ),
                          ),
                          firstText: "Aide",
                          lastText: "Contactez-nous par email",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),

                        OptionItem(
                          prefix: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: theme.colorScheme.primary,
                              padding: const EdgeInsets.all(15),
                              child: const Icon(Icons.share, size: 30, color: Colors.white),
                            ),
                          ),
                          firstText: "Partager l'app",
                          lastText: "Soutenez-nous en partageant l'app",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () {},
                        ),
                        const SizedBox(height: 20),

                        Text("Liens", style: theme.textTheme.displaySmall),
                        const SizedBox(height: 10),

                        OptionItem(
                          firstText: "Politique de confidentialité",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),

                        OptionItem(
                          firstText: "Conditions générales de ventes et d'utilisation",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),

                        OptionItem(
                          firstText: "Mentions légales",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),

                        OptionItem(
                          firstText: "A propos",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () {},
                        ),
                        const SizedBox(height: 20),

                        Text("Réseaux sociaux", style: theme.textTheme.displaySmall),
                        const SizedBox(height: 10),

                        OptionItem(
                          prefix: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: Colors.blueAccent,
                              padding: const EdgeInsets.all(15),
                              child: const Icon(Icons.facebook, size: 30, color: Colors.white),
                            ),
                          ),
                          firstText: "Notre page facebook",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),

                        OptionItem(
                          prefix: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: Colors.purple,
                              padding: const EdgeInsets.all(15),
                              child: const Icon(Icons.insert_page_break_rounded, size: 30, color: Colors.white),
                            ),
                          ),
                          firstText: "Notre Instagram",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),

                        OptionItem(
                          prefix: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: Colors.blue,
                              padding: const EdgeInsets.all(15),
                              child: const Icon(Icons.animation_outlined, size: 30, color: Colors.white),
                            ),
                          ),
                          firstText: "Notre Twitter",
                          sufixe: const Icon(Icons.h_mobiledata, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),

                        OptionItem(
                          prefix: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: Colors.yellow,
                              padding: const EdgeInsets.all(10),
                              child: const Icon(Icons.group_sharp, size: 40, color: Colors.white),
                            ),
                          ),
                          firstText: "Notre Snapchat",
                          sufixe: const Icon(Icons.arrow_forward_ios_sharp, color: Color.fromARGB(255, 165, 165, 165)),
                          onTap: () {},
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text("Edité par ", style: theme.textTheme.bodyLarge),
                            Text(
                              "kosmos-digital.com",
                              style: theme.textTheme.bodyLarge?.copyWith(decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
