import 'package:flutter/material.dart';

import 'screens/store/store_shell.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.init();
  runApp(const PetShopApp());
}

class PetShopApp extends StatelessWidget {
  const PetShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Shop · Sistema de Gestión Integral',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const StoreShell(),
    );
  }
}