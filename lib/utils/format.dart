import 'package:flutter/material.dart';

const List<String> mesesCortos = [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
];

const List<String> mesesLargos = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

const List<String> diasCortos = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

String money(num value) => 'S/ ${value.toStringAsFixed(2)}';

String fechaCorta(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')} ${mesesCortos[date.month - 1]} ${date.year}';

String fechaLarga(DateTime date) =>
    '${date.day} de ${mesesLargos[date.month - 1]} de ${date.year}';

String horaTexto(TimeOfDay time) {
  final h = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final m = time.minute.toString().padLeft(2, '0');
  final suffix = time.period == DayPeriod.am ? 'a. m.' : 'p. m.';
  return '${h.toString().padLeft(2, '0')}:$m $suffix';
}

String horaCorta(TimeOfDay time) {
  final h = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final m = time.minute.toString().padLeft(2, '0');
  final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '${h.toString().padLeft(2, '0')}:$m $suffix';
}

bool mismoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String iniciales(String nombre) {
  final partes = nombre.trim().split(RegExp(r'\s+'));
  if (partes.isEmpty) return '?';
  if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
  return (partes.first.substring(0, 1) + partes.last.substring(0, 1))
      .toUpperCase();
}

String relativa(DateTime date) {
  final now = DateTime.now();
  final hoy = DateTime(now.year, now.month, now.day);
  final dia = DateTime(date.year, date.month, date.day);
  final diff = dia.difference(hoy).inDays;
  if (diff == 0) return 'Hoy';
  if (diff == 1) return 'Mañana';
  if (diff == -1) return 'Ayer';
  if (diff > 1 && diff < 7) return 'En $diff días';
  if (diff < -1 && diff > -7) return 'Hace ${diff.abs()} días';
  return fechaCorta(date);
}

String fechaHora(DateTime date) {
  final h = date.hour.toString().padLeft(2, '0');
  final m = date.minute.toString().padLeft(2, '0');
  return '${fechaCorta(date)} · $h:$m';
}
