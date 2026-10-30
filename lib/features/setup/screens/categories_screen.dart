import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/app_card.dart';
import '../providers.dart';
import '../setup_actions.dart';

/// Other-work categories: add and rename (SPEC §8.8).
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final actions = SetupActions(ref);
    return Scaffold(
      appBar: AppBar(title: const Text('Other-work categories')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final category in categories) ...[
                  ListTile(
                    title: Text(category.name),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () => actions.renameCategory(context, category),
                  ),
                  const Divider(height: 1),
                ],
                TextButton.icon(
                  onPressed: () => actions.addCategory(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add a category'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
