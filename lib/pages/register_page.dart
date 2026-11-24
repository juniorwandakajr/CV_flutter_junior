import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await AuthService().register(_emailCtrl.text.trim(), _passCtrl.text,
        passwordConfirmation: _confirmCtrl.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte créé ✅ Connecte-toi maintenant.')));
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(children: [
                IconButton(onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white)),
                const Text('Créer un compte', style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              ]),
            ),
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeSlideIn(
                child: Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: context.c.surface,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 40, offset: const Offset(0, 20))],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Text('Rejoins-nous 🚀', style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700, color: context.c.onSurface)),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email', prefixIcon: Icon(Icons.alternate_email)),
                        validator: (v) => (v == null || !v.contains('@')) ? 'Email invalide' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passCtrl, obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe', prefixIcon: Icon(Icons.key_outlined)),
                        validator: (v) =>
                          (v == null || v.length < 6) ? '6 caractères minimum' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _confirmCtrl, obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          prefixIcon: Icon(Icons.lock_outline)),
                        validator: (v) =>
                          v != _passCtrl.text ? 'Les mots de passe ne correspondent pas' : null,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        Text(_error!, style: TextStyle(color: context.c.error, fontSize: 13)),
                      ],
                      const SizedBox(height: 22),
                      SizedBox(width: double.infinity, child: GradientButton(
                        label: "S'inscrire", icon: Icons.person_add_alt_1_rounded,
                        loading: _loading, onPressed: _submit)),
                    ]),
                  ),
                ),
              ),
            )),
          ]),
        ),
      ),
    );
  }
}
