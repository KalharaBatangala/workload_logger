import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router.dart';
import '../theme/tokens.dart';

/// Shell for the four main tabs: ground background + the bottom bar with the
/// raised gold Log button (SPEC §8.0).
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goToBranch(int index) {
    // Tapping the active tab again returns it to its first screen.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body runs behind the bar so the raised Log button can overlap it.
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: AppBottomBar(
        currentIndex: navigationShell.currentIndex,
        onTabSelected: _goToBranch,
        onLogPressed: () => context.push(AppRoutes.log),
      ),
    );
  }
}

/// The five-slot bottom bar: Today · History · Log · Summary · Setup.
/// [currentIndex] is the shell branch index (0–3); Log is not a branch.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onLogPressed,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onLogPressed;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final barHeight = AppNavBar.height + bottomInset;

    Widget tab(int index, IconData icon, String label) => Expanded(
      child: _TabItem(
        icon: icon,
        label: label,
        selected: currentIndex == index,
        onTap: () => onTabSelected(index),
      ),
    );

    return SizedBox(
      height: barHeight + AppNavBar.logButtonLift,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: barHeight,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    tab(0, Icons.home_outlined, 'Today'),
                    tab(1, Icons.access_time_rounded, 'History'),
                    const Expanded(child: _LogLabel()),
                    tab(2, Icons.bar_chart_rounded, 'Summary'),
                    tab(3, Icons.tune_rounded, 'Setup'),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(child: _LogButton(onPressed: onLogPressed)),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.navy : AppColors.navInactive;
    return Semantics(
      container: true,
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: selected ? AppText.tabLabelActive : AppText.tabLabel,
            ),
          ],
        ),
      ),
    );
  }
}

/// The "Log" caption under the raised button, aligned with the other labels.
class _LogLabel extends StatelessWidget {
  const _LogLabel();

  @override
  Widget build(BuildContext context) {
    return const ExcludeSemantics(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Log', style: AppText.tabLabelActive),
          SizedBox(height: AppSpacing.m),
        ],
      ),
    );
  }
}

class _LogButton extends StatelessWidget {
  const _LogButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadii.logButton);
    return Semantics(
      container: true,
      button: true,
      label: 'Log work',
      excludeSemantics: true,
      child: Tooltip(
        message: 'Log work',
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: shape,
            boxShadow: AppShadows.logButton,
          ),
          child: Material(
            color: AppColors.gold,
            borderRadius: shape,
            child: InkWell(
              key: const Key('logButton'),
              borderRadius: shape,
              onTap: onPressed,
              child: const SizedBox.square(
                dimension: AppNavBar.logButtonSize,
                child: Icon(Icons.add_rounded, size: 32, color: AppColors.navy),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
