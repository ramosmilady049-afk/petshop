import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

class ClientsAdminPage extends StatelessWidget {
  const ClientsAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      builder: (context) {
        final state = AppState.instance;
        return AdminContent(
          children: [
            PageHeader(
              eyebrow: 'Clientes',
              title: 'Gestión de clientes',
              subtitle:
                  'Cartera de clientes, mascotas asociadas y compras.',
              action: Pill(
                text: '${state.clientes.length} clientes',
                icon: Icons.group_outlined,
              ),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 760) {
                  return Column(
                    children: [
                      for (final c in state.clientes)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _ClienteCardMobile(cliente: c),
                        ),
                    ],
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.bg,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: _th('Cliente')),
                            Expanded(flex: 2, child: _th('Contacto')),
                            Expanded(flex: 3, child: _th('Mascotas')),
                            Expanded(flex: 2, child: _th('Compras')),
                            Expanded(flex: 2, child: _th('Total gastado')),
                            Expanded(flex: 2, child: _th('Registro')),
                          ],
                        ),
                      ),
                      for (var i = 0; i < state.clientes.length; i++) ...[
                        _ClienteRow(cliente: state.clientes[i]),
                        if (i != state.clientes.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _th extends StatelessWidget {
  const _th(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: AppColors.inkMuted,
      ),
    );
  }
}

class _ClienteRow extends StatelessWidget {
  const _ClienteRow({required this.cliente});
  final Cliente cliente;
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final mascotas = state.mascotas.where((m) => m.idCliente == cliente.id).toList();
    final compras = state.ventas.where((v) => v.idCliente == cliente.id).toList();
    final total = compras.fold(0.0, (sum, v) => sum + v.total);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      iniciales(cliente.nombre),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cliente.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        cliente.id,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cliente.telefono,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.inkSoft,
                  ),
                ),
                Text(
                  cliente.correo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final m in mascotas)
                  Pill(
                    text: m.nombre,
                    color: AppColors.inkSoft,
                    background: AppColors.bg,
                  ),
                if (mascotas.isEmpty)
                  const Text(
                    'Sin mascotas',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${compras.length} compras',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              money(total),
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              fechaCorta(cliente.fechaRegistro),
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClienteCardMobile extends StatelessWidget {
  const _ClienteCardMobile({required this.cliente});
  final Cliente cliente;
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final mascotas = state.mascotas
        .where((m) => m.idCliente == cliente.id)
        .toList();
    final compras = state.ventas
        .where((v) => v.idCliente == cliente.id)
        .length;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    iniciales(cliente.nombre),
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cliente.nombre,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      cliente.correo,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final m in mascotas)
                Pill(
                  text: m.nombre,
                  color: AppColors.inkSoft,
                  background: AppColors.bg,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$compras compras · Registrado ${fechaCorta(cliente.fechaRegistro)}',
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}
