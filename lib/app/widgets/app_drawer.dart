import 'package:flutter/material.dart';
import '../app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              color: Colors.black,
              child: const Text(
                'RINGO',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Itens de navegação
            _DrawerItem(
              icon: Icons.home,
              label: 'Início',
              route: AppRoutes.home,
              isActive: currentRoute == AppRoutes.home,
            ),
            _DrawerItem(
              icon: Icons.search,
              label: 'Buscar',
              route: AppRoutes.search,
              isActive: currentRoute == AppRoutes.search,
            ),
            _DrawerItem(
              icon: Icons.favorite,
              label: 'Favoritos',
              route: AppRoutes.favorites,
              isActive: currentRoute == AppRoutes.favorites,
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isActive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Colors.red : Colors.white70,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.red : Colors.white70,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isActive ? Colors.red.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        Navigator.pop(context); // fecha o drawer
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}