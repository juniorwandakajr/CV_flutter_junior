import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/membre.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class MembreFormPage extends StatefulWidget {
  final Membre? membre;
  const MembreFormPage({super.key, this.membre});
  @override
  State<MembreFormPage> createState() => _MembreFormPageState();
}

class _MembreFormPageState extends State<MembreFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();
  final _nomCtrl = TextEditingController();
  final _postnomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _lieuCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _parenteCtrl = TextEditingController();
  File? _image;
  bool _loading = false;

  bool get _isEdit => widget.membre != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final m = widget.membre!;
      _nomCtrl.text = m.nom; _postnomCtrl.text = m.postnom;
      _prenomCtrl.text = m.prenom; _lieuCtrl.text = m.lieuNaissance;
      _dateCtrl.text = m.dateNaissance; _parenteCtrl.text = m.parente;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(context: context,
      initialDate: DateTime.tryParse(_dateCtrl.text) ?? DateTime(2000),
      firstDate: DateTime(1900), lastDate: DateTime.now());
    if (picked != null) _dateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 75);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  void _showImageOptions() {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: context.c.surface,
          borderRadius: BorderRadius.circular(24)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
            title: const Text('Depuis la galerie'),
            onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
          ListTile(leading: const Icon(Icons.camera_alt_outlined, color: AppColors.secondary),
            title: const Text('Prendre une photo'),
            onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
          if (_image != null)
            ListTile(leading: Icon(Icons.delete_outline, color: context.c.error),
              title: Text('Retirer la photo', style: TextStyle(color: context.c.error)),
              onTap: () { Navigator.pop(context); setState(() => _image = null); }),
        ]),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final membre = Membre(
        id: widget.membre?.id,
        nom: _nomCtrl.text.trim(), postnom: _postnomCtrl.text.trim(),
        prenom: _prenomCtrl.text.trim(), lieuNaissance: _lieuCtrl.text.trim(),
        dateNaissance: _dateCtrl.text.trim(), parente: _parenteCtrl.text.trim(),
        imageUrl: widget.membre?.imageUrl,
      );
      if (_isEdit) {
        if (_image != null) { await _api.updateMembreWithImage(membre, _image!); }
        else { await _api.updateMembre(membre); }
      } else { await _api.createMembre(membre, image: _image); }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.membre;
    final ImageProvider? bgImage = _image != null
      ? FileImage(_image!)
      : (m?.imageUrl != null && m!.imageUrl!.isNotEmpty ? NetworkImage(m.imageUrl!) : null);

    return Scaffold(
      body: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 50, 8, 24),
          decoration: const BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
          child: Column(children: [
            Row(children: [
              IconButton(onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white)),
              Expanded(child: Text(_isEdit ? 'Modifier le membre' : 'Nouveau membre',
                style: const TextStyle(color: Colors.white,
                  fontSize: 18, fontWeight: FontWeight.w600))),
            ]),
            const SizedBox(height: 8),
            GestureDetector(onTap: _showImageOptions,
              child: Stack(children: [
                Container(padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: CircleAvatar(radius: 46, backgroundColor: AppColors.primary,
                    backgroundImage: bgImage,
                    child: bgImage == null
                      ? const Icon(Icons.person, color: Colors.white, size: 42) : null)),
                Positioned(bottom: 0, right: 0,
                  child: Container(padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                      boxShadow: [BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15), blurRadius: 10)]),
                    child: const Icon(Icons.camera_alt_rounded,
                      color: AppColors.primary, size: 18))),
              ]),
            ),
            const SizedBox(height: 8),
            Text('Toucher pour changer la photo',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12)),
          ]),
        ),
        Expanded(child: Form(key: _formKey, child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _field(_nomCtrl, 'Nom', Icons.badge_outlined),
            _field(_postnomCtrl, 'Postnom', Icons.badge_outlined),
            _field(_prenomCtrl, 'Prénom', Icons.person_outline),
            _field(_lieuCtrl, 'Lieu de naissance', Icons.location_on_outlined),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: TextFormField(
                controller: _dateCtrl, readOnly: true, onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Date de naissance',
                  prefixIcon: Icon(Icons.calendar_today_outlined)),
                validator: (v) => (v == null || v.isEmpty) ? 'Champ requis' : null,
              ),
            ),
            _field(_parenteCtrl, 'Lien de parenté (père, mère…)',
              Icons.family_restroom_outlined),
            const SizedBox(height: 12),
            GradientButton(
              label: _isEdit ? 'Enregistrer les modifications' : 'Créer le membre',
              icon: Icons.check_rounded, loading: _loading, onPressed: _save),
          ],
        )),
      ),
    ]);
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon) {
    return Padding(padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ requis' : null,
      ),
    );
  }
}
