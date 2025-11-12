import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naxan_test/app/screens/home_screen/current_profile_notifier.dart';
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
    final currentProfilAsync = ref.watch(currentProfileNotifierProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ref
            .watch(currentProfileNotifierProvider)
            .when(
              data: (data) {
                if (data == null) {
                  return const Center(child: Text("Vous n'avez pas de profil…"));
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsetsGeometry.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: NetworkImage("$serverImagesUrl/${currentProfilAsync.value!.imageId}"),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("${data.firstname} ${data.surname}", style: theme.textTheme.headlineLarge),
                        Text(data.email, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 10),

                        // * Divider.
                        Container(height: 1, color: const Color.fromARGB(255, 199, 199, 199)),
                        const SizedBox(height: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Mon compte", style: theme.textTheme.headlineLarge),
                            const SizedBox(height: 10),
                            OptionItem(
                              prefix: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                  image: NetworkImage("$serverImagesUrl/${currentProfilAsync.value!.imageId}"),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              firstText: "${data.firstname} ${data.surname}",
                              lastText: data.email,
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 10),

                            OptionItem(
                              prefix: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  color: theme.colorScheme.primary,
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(Icons.lock_open_outlined, size: 40, color: Colors.white),
                                ),
                              ),
                              firstText: "Sécurité",
                              lastText: "Mot de passe, email…",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 20),

                            Text("Paramètres", style: theme.textTheme.headlineLarge),
                            const SizedBox(height: 10),

                            OptionItem(
                              prefix: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  color: theme.colorScheme.primary,
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(Icons.notification_add_outlined, size: 40, color: Colors.white),
                                ),
                              ),
                              firstText: "Notifications push",
                              lastText: "Activées",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 20),

                            Text("Autres", style: theme.textTheme.headlineLarge),
                            const SizedBox(height: 10),

                            OptionItem(
                              prefix: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  color: theme.colorScheme.primary,
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(Icons.help_outline, size: 40, color: Colors.white),
                                ),
                              ),
                              firstText: "Aide",
                              lastText: "Contactez-nous par email",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 10),

                            OptionItem(
                              prefix: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  color: theme.colorScheme.primary,
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(Icons.share, size: 40, color: Colors.white),
                                ),
                              ),
                              firstText: "Partager l'app",
                              lastText: "Soutenez-nous en partageant l'app",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 20),

                            Text("Liens", style: theme.textTheme.headlineLarge),
                            const SizedBox(height: 10),

                            OptionItem(
                              firstText: "Politique de confidentialité",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 10),

                            OptionItem(
                              firstText: "Conditions générales de ventes et d'utilisation",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 10),

                            OptionItem(
                              firstText: "Mentions légales",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 10),

                            OptionItem(
                              firstText: "A propos",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 20),

                            Text("Réseaux sociaux", style: theme.textTheme.headlineLarge),
                            const SizedBox(height: 10),

                            OptionItem(
                              prefix: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  color: theme.colorScheme.primary,
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(Icons.facebook, size: 40, color: Colors.white),
                                ),
                              ),
                              firstText: "Notre page facebook",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 10),

                            OptionItem(
                              prefix: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  color: theme.colorScheme.primary,
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(Icons.insert_page_break_rounded, size: 40, color: Colors.white),
                                ),
                              ),
                              firstText: "Notre page facebook",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 10),

                            OptionItem(
                              prefix: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  color: theme.colorScheme.primary,
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(Icons.facebook, size: 40, color: Colors.white),
                                ),
                              ),
                              firstText: "Notre page facebook",
                              sufixe: const Icon(Icons.h_mobiledata, color: Color.fromARGB(255, 165, 165, 165)),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
                            ),
                            const SizedBox(height: 10),

                            OptionItem(
                              prefix: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  color: theme.colorScheme.primary,
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(Icons.donut_large, size: 40, color: Colors.white),
                                ),
                              ),
                              firstText: "Notre page facebook",
                              sufixe: const Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Color.fromARGB(255, 165, 165, 165),
                              ),
                              onClick: () {
                                print("OPTIONS MON GATé");
                              },
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
              loading: () {
                return Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 6),
                  ),
                );
              },
              error: (error, stackTrace) {
                return const Center(child: Text("Erreur de chargement des options…"));
              },
            ),
      ),
    );
  }
}
