import 'package:flutter/material.dart';
import '../models/account.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';
import 'cv_page.dart';
import 'famille_page.dart';
import 'contact_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final Account account;
  const HomePage({super.key, required this.account});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final _pages = const [CvPage(), FamillePage(), ContactPage()];

  Future<void> _logout() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: context.c.surface,
          indicatorColor: AppColors.primary.withValues(alpha: 0.15),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final sel = states.contains(WidgetState.selected);
            return TextStyle(fontSize: 12,
              fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
              color: sel ? AppColors.primary : context.c.onSurfaceVariant);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final sel = states.contains(WidgetState.selected);
            return IconThemeData(
              color: sel ? AppColors.primary : context.c.onSurfaceVariant, size: 24);
          }),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.description_outlined),
              selectedIcon: Icon(Icons.description), label: 'CV'),
            NavigationDestination(icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups), label: 'Famille'),
            NavigationDestination(icon: Icon(Icons.contact_mail_outlined),
              selectedIcon: Icon(Icons.contact_mail), label: 'Contact'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final isDark = context.isDark;
    return Drawer(
      backgroundColor: context.c.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
        topRight: Radius.circular(24), bottomRight: Radius.circular(24))),
      child: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
          decoration: const BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(28))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 68, height: 68,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2)),
              child: const Center(child: Text('JK',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 14),
            const Text('Junior Kambale', style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(widget.account.email,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 12),
        _drawerItem(context, Icons.description_outlined, 'Mon CV', 0),
        _drawerItem(context, Icons.groups_outlined, 'Ma Famille', 1),
        _drawerItem(context, Icons.contact_mail_outlined, 'Contact', 2),
        const Spacer(),
        const Divider(),
        // ⬇️ Toggle thème
        AnimatedBuilder(
          animation: themeController,
          builder: (_, __) => SwitchListTile(
            value: isDark,
            onChanged: (_) => themeController.toggle(),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.accent),
            title: Text(isDark ? 'Mode sombre' : 'Mode clair',
              style: TextStyle(fontWeight: FontWeight.w500, color: context.c.onSurface)),
            activeTrackColor: AppColors.primary,
          ),
        ),
        _drawerItem(context, Icons.logout, 'Déconnexion', -1, destructive: true),
        const SizedBox(height: 12),
      ]),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String label, int idx,
      {bool destructive = false}) {
    final sel = idx == _index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: sel ? AppColors.primary.withValues(alpha: 0.08) : null,
        leading: Icon(icon,
          color: destructive ? context.c.error
            : sel ? AppColors.primary : context.c.onSurfaceVariant),
        title: Text(label, style: TextStyle(
          fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
          color: destructive ? context.c.error
            : sel ? AppColors.primary : context.c.onSurface)),
        onTap: () {
          Navigator.pop(context);
          if (destructive) { _logout(); } else { setState(() => _index = idx); }
        },
      ),
    );
  }
}
