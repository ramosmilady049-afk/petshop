import 'package:flutter/material.dart';

/// Controla la pestaña activa de la tienda y el filtro de categorías.
class StoreNav {
  StoreNav._();

  static const int inicio = 0;
  static const int productos = 1;
  static const int citas = 2;
  static const int mascotas = 3;
  static const int compras = 4;
  static const int perfil = 5;

  static final ValueNotifier<int> tab = ValueNotifier<int>(inicio);
  static final ValueNotifier<String> categoria = ValueNotifier<String>(
    'Todos',
  );

  static void go(int index) {
    tab.value = index;
  }

  static void irA(BuildContext context, int index) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    tab.value = index;
  }
}
