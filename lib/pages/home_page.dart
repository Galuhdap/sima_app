import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const Map<String, String> _menuRoutes = {
    'Data Invetaris': '/data_barang',
    'Data Santri': '/data_santri',
    'Riwayat': '/history',
    'Laporan': '/laporan',
  };

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.background.withOpacity(0.95),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Selamat Datang di SIMA App!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ).copyWith(
                      fontSize: textTheme.headlineMedium?.fontSize,
                      fontWeight: textTheme.headlineMedium?.fontWeight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sistem Informasi Manajemen Aset untuk memudahkan inventaris Anda.',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onBackground,
                    ).copyWith(
                      fontSize: textTheme.titleMedium?.fontSize,
                      fontWeight: textTheme.titleMedium?.fontWeight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 72,
                    color: Colors.indigo.shade400,
                    shadows: const [
                      Shadow(
                        color: Color.fromARGB(255, 0, 0, 0),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Flexible(
                    fit: FlexFit.loose,
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      children: _menuRoutes.entries.map((entry) {
                        return _buildMenuCard(entry.key, entry.value, context);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, String route, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    const Map<String, IconData> iconMapping = {
      'Data Invetaris': Icons.inventory_2_outlined,
      'Data Santri': Icons.school_outlined,
      'Riwayat': Icons.history_edu_outlined,
      'Laporan': Icons.insert_chart_outlined_rounded,
    };

    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: Theme.of(context).cardColor,
        elevation: 4,
        shadowColor: colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          splashColor: colorScheme.primary.withOpacity(0.1),
          hoverColor: colorScheme.primary.withOpacity(0.05),
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconMapping[title] ?? Icons.help_outline,
                  size: 44,
                  color: colorScheme.primary,
                  shadows: [
                    Shadow(
                      color: colorScheme.primary.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo.shade900,
                  ).copyWith(
                    color: colorScheme.primary,
                    fontSize: textTheme.titleMedium?.fontSize,
                    fontWeight: textTheme.titleMedium?.fontWeight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
