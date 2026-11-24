import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/membre.dart';
import '../services/api_service.dart';

class MembreFormPage extends StatefulWidget {
  final dynamic membre;
  const MembreFormPage({super.key, this.membre});
  @override
  State<MembreFormPage> createState() => _MembreFormPageState();
}

class _MembreFormPageState extends State<MembreFormPage> {
  final _nom = TextEditingController();
  final _postnom = TextEditingController();
  final _prenom = TextEditingController();
  final _lieu = TextEditingController();
  DateTime? _date;
  String _parente = 'Moi';
  bool _saving = false;
  String? _photoBase64;
  final _parentes = ['Moi', 'Père', 'Mère', 'Frère', 'Soeur', 'Fils', 'Fille', 'Autre'];

  @override
  void initState() {
    super.initState();
    if (widget.membre != null) {
      final m = widget.membre as Membre;
      _nom.text = m.nom;
      _postnom.text = m.postnom;
      _prenom.text = m.prenom;
      _lieu.text = m.lieuNaissance;
      _parente = m.parente;
      _date = DateTime.tryParse(m.dateNaissance);
      _photoBase64 = m.imageUrl;
    }
  }

  Future<void> _pickPhoto() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (img != null) {
      final bytes = await img.readAsBytes();
      setState(() => _photoBase64 = base64Encode(bytes));
    }
  }

  Future<void> _save() async {
    if (_nom.text.trim().isEmpty || _prenom.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nom et Prénom sont obligatoires')));
      return;
    }
    setState(() => _saving = true);
    final membre = Membre(
      id: widget.membre != null ? (widget.membre as Membre).id : DateTime.now().millisecondsSinceEpoch,
      nom: _nom.text.trim(),
      postnom: _postnom.text.trim(),
      prenom: _prenom.text.trim(),
      lieuNaissance: _lieu.text.trim(),
      dateNaissance: (_date ?? DateTime.now()).toIso8601String().split('T')[0],
      parente: _parente,
      imageUrl: _photoBase64,
    );
    try {
      if (widget.membre != null) {
        await ApiService().updateMembre(membre);
      } else {
        await ApiService().createMembre(membre);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.membre == null ? 'Ajouter un membre' : 'Modifier un membre')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickPhoto,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: _photoBase64 != null && _photoBase64!.isNotEmpty
                    ? MemoryImage(base64Decode(_photoBase64!)) as ImageProvider
                    : null,
                child: _photoBase64 == null ? const Icon(Icons.camera_alt, size: 40) : null,
              ),
            ),
            const Text('Touche la photo pour changer', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            TextField(controller: _nom, decoration: const InputDecoration(labelText: 'Nom *')),
            const SizedBox(height: 12),
            TextField(controller: _postnom, decoration: const InputDecoration(labelText: 'Postnom')),
            const SizedBox(height: 12),
            TextField(controller: _prenom, decoration: const InputDecoration(labelText: 'Prénom *')),
            const SizedBox(height: 12),
            TextField(controller: _lieu, decoration: const InputDecoration(labelText: 'Lieu de naissance')),
            const SizedBox(height: 12),
            ListTile(
              title: Text(_date == null ? 'Choisir la date' : _date!.toIso8601String().split('T')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
                if (d != null) setState(() => _date = d);
              },
            ),
            DropdownButtonFormField<String>(
              value: _parente,
              items: _parentes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _parente = v!),
              decoration: const InputDecoration(labelText: 'Parenté'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'Enregistrement...' : 'Enregistrer')),
            ),
          ],
        ),
      ),
    );
  }
}
