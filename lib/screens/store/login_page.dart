import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _correo = TextEditingController(text: 'ana.torres@correo.com');
  final _clave = TextEditingController(text: '123456');
  final _nombre = TextEditingController();
  final _telefono = TextEditingController();
  final _direccion = TextEditingController();

  int _modo = 0;
  bool _verClave = false;
  String? _error;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    _nombre.dispose();
    _telefono.dispose();
    _direccion.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final state = AppState.instance;
    setState(() => _error = null);
    String? error;
    if (_modo == 0) {
      error = await state.login(_correo.text, _clave.text);
    } else {
      error = state.registrarCuenta(
        nombre: _nombre.text,
        correo: _correo.text,
        telefono: _telefono.text,
        direccion: _direccion.text,
        clave: _clave.text,
      );
    }
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(true);
  }

  void _entrarDemo({required bool admin}) {
    final state = AppState.instance;
    if (admin) {
      state.loginDemoAdmin();
    } else {
      state.loginDemoCliente();
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          return Row(
            children: [
              if (wide) const Expanded(flex: 5, child: _PanelMarca()),
              Expanded(
                flex: wide ? 6 : 1,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: wide ? 48 : 20,
                      vertical: 24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!wide) ...[
                              const AppLogo(size: 36),
                              const SizedBox(height: 24),
                            ],
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      Navigator.of(context).maybePop(),
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    size: 20,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Pill(
                                  text: 'Área de clientes',
                                  icon: Icons.lock_outline_rounded,
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            Text(
                              _modo == 0
                                  ? 'Bienvenido de nuevo'
                                  : 'Crea tu cuenta',
                              style: AppText.h1,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _modo == 0
                                  ? 'Ingresa para comprar, revisar tus compras y '
                                        'gestionar las citas de tus mascotas.'
                                  : 'Registra tus datos y empieza a cuidar a tu '
                                        'mascota con nosotros.',
                              style: AppText.body,
                            ),
                            const SizedBox(height: 22),
                            _Selector(
                              modo: _modo,
                              onCambio: (value) => setState(() {
                                _modo = value;
                                _error = null;
                              }),
                            ),
                            const SizedBox(height: 22),
                            if (_error != null) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.dangerSoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      size: 17,
                                      color: AppColors.danger,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _error!,
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          height: 1.4,
                                          color: AppColors.danger,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                            if (_modo == 1) ...[
                              const FieldLabel('Nombre completo'),
                              TextField(
                                controller: _nombre,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'Ana Torres',
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    size: 19,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              const FieldLabel('Teléfono'),
                              TextField(
                                controller: _telefono,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: '987 654 321',
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    size: 19,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              const FieldLabel('Dirección'),
                              TextField(
                                controller: _direccion,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'Av. Los Jardines 245, San Miguel',
                                  prefixIcon: Icon(
                                    Icons.location_on_outlined,
                                    size: 19,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],
                            const FieldLabel('Correo electrónico'),
                            TextField(
                              controller: _correo,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: 'tucorreo@ejemplo.com',
                                prefixIcon: Icon(
                                  Icons.mail_outline_rounded,
                                  size: 19,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const FieldLabel('Contraseña'),
                            TextField(
                              controller: _clave,
                              obscureText: !_verClave,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                hintText: 'Mínimo 6 caracteres',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  size: 19,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                    () => _verClave = !_verClave,
                                  ),
                                  icon: Icon(
                                    _verClave
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 19,
                                  ),
                                ),
                              ),
                            ),
                            if (_modo == 0) ...[
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    showToast(
                                      context,
                                      'Usa las credenciales de demostración '
                                      'para ingresar.',
                                    );
                                  },
                                  child: const Text('¿Olvidaste tu contraseña?'),
                                ),
                              ),
                            ] else
                              const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: _submit,
                                child: Text(
                                  _modo == 0
                                      ? 'Iniciar sesión'
                                      : 'Crear mi cuenta',
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    'ACCESO RÁPIDO DEMO',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.9,
                                      color: AppColors.inkMuted,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        _entrarDemo(admin: false),
                                    icon: const Icon(
                                      Icons.person_outline_rounded,
                                      size: 17,
                                    ),
                                    label: const Text('Cliente demo'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _entrarDemo(admin: true),
                                    icon: const Icon(
                                      Icons.admin_panel_settings_outlined,
                                      size: 17,
                                    ),
                                    label: const Text('Admin demo'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.cream,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Credenciales de demostración',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.inkSoft,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Cliente · ana.torres@correo.com / 123456\n'
                                    'Admin · admin@petshop.com / admin123',
                                    style: TextStyle(
                                      fontSize: 11,
                                      height: 1.6,
                                      color: AppColors.inkMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Center(
                              child: Text(
                                'Al continuar aceptas los términos y la política '
                                'de privacidad de Pet Shop.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Selector extends StatelessWidget {
  const _Selector({required this.modo, required this.onCambio});

  final int modo;
  final ValueChanged<int> onCambio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(child: _tab('Iniciar sesión', 0)),
          Expanded(child: _tab('Crear cuenta', 1)),
        ],
      ),
    );
  }

  Widget _tab(String label, int value) {
    final activo = modo == value;
    return GestureDetector(
      onTap: () => onCambio(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: activo ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: activo ? Colors.white : AppColors.inkMuted,
          ),
        ),
      ),
    );
  }
}

class _PanelMarca extends StatelessWidget {
  const _PanelMarca();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFFFF8CA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -50,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            right: 40,
            child: Icon(
              Icons.pets_rounded,
              size: 120,
              color: Colors.white.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            top: 130,
            left: 36,
            child: Icon(
              Icons.pets_rounded,
              size: 46,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.pets_rounded,
                        color: AppColors.primary,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: 11),
                    const Text(
                      'PET SHOP',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Cada huella merece\nel mejor cuidado.',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    height: 1.12,
                    letterSpacing: -1.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Compra alimentos, juguetes y accesorios, y agenda baño, '
                  'corte o consulta veterinaria para tu mascota en un solo lugar.',
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.6,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 30),
                const _Bullet(texto: 'Compra en línea con envío el mismo día'),
                const SizedBox(height: 12),
                const _Bullet(texto: 'Agenda citas y revisa su historial'),
                const SizedBox(height: 12),
                const _Bullet(texto: 'Atención veterinaria de confianza'),
                const Spacer(),
                Text(
                  'Sistema de Gestión Integral · Pet Shop',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 12,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
