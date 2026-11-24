import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/membre.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';
import '../widgets/famille_skeleton.dart';
import 'membre_form_page.dart';

class FamillePage extends StatefulWidget {
  const FamillePage({super.key});
  @override
  State<FamillePage> createState() => _FamillePageState();
}

class _FamillePageState extends State<FamillePage> {
  final _api = ApiService();
  late Future<List<Membre>> _future;

  @override
  void initState() { super.initState(); _reload(); }

  void _reload() {
    final future = _api.getMembres();
    setState(() {
      _future = future;
    });
  }

  Future<void> _openForm({Membre? membre}) async {
    final changed = await Navigator.push<bool>(context,
      MaterialPageRoute(builder: (_) => MembreFormPage(membre: membre)));
    if (changed == true) _reload();
  }

  Future<void> _confirmDelete(Membre m) async {
    final ok = await showModalBottomSheet<bool>(context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: context.c.surface,
          borderRadius: BorderRadius.circular(24)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 56, height: 56,
            decoration: BoxDecoration(
              color: context.c.error.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(Icons.delete_outline, color: context.c.error, size: 28)),
          const SizedBox(height: 14),
          Text('Supprimer ce membre ?', style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: context.c.onSurface)),
          const SizedBox(height: 6),
          Text('${m.nomComplet} sera définitivement supprimé.',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.c.onSurfaceVariant)),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Annuler'))),
            const SizedBox(width: 12),
            Expanded(child: FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: context.c.error,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('Supprimer'))),
          ]),
        ]),
      ),
    );
    if (ok != true) return;
    try {
      await _api.deleteMembre(m.id!);
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 140, pinned: true,
            backgroundColor: AppColors.primary, foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Ma Famille',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              titlePadding: const EdgeInsets.only(left: 56, bottom: 14),
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.heroGradient)),
            ),
          ),
          _buildSliverBody(),
        ]),
        Positioned(right: 20, bottom: 20,
          child: GestureDetector(
            onTap: () => _openForm(),
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 24, offset: const Offset(0, 10))],
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add_rounded, color: Colors.white),
                SizedBox(width: 6),
                Text('Ajouter', style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildSliverBody() {
    return FutureBuilder<List<Membre>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          // ✨ Shimmer skeleton
          return const SliverFillRemaining(child: FamilleSkeleton());
        }
        if (snap.hasError) {
          return SliverFillRemaining(hasScrollBody: false,
            child: EmptyState(
              icon: Icons.cloud_off_rounded, title: 'Connexion impossible',
              subtitle: '${snap.error}'.replaceFirst('Exception: ', ''),
              actionLabel: 'Réessayer', onAction: _reload));
        }
        final membres = snap.data ?? [];
        if (membres.isEmpty) {
          return SliverFillRemaining(hasScrollBody: false,
            child: EmptyState(
              icon: Icons.group_add_outlined, title: 'Aucun membre enregistré',
              subtitle: 'Commence par ajouter un membre de ta famille.',
              actionLabel: 'Ajouter un membre', onAction: () => _openForm()));
        }
        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14,
              childAspectRatio: 0.82),
            delegate: SliverChildBuilderDelegate((context, i) {
              final m = membres[i];
              return FadeSlideIn(
                delay: Duration(milliseconds: 40 * i),
                child: _MembreCard(
                  membre: m,
                  gradient: AppColors.cardGradients[i % AppColors.cardGradients.length],
                  onTap: () => _openForm(membre: m),
                  onDelete: () => _confirmDelete(m),
                ),
              );
            }, childCount: membres.length),
          ),
        );
      },
    );
  }
}

class _MembreCard extends StatelessWidget {
  final Membre membre; final Gradient gradient;
  final VoidCallback onTap, onDelete;
  const _MembreCard({required this.membre, required this.gradient,
    required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final initials = [
      membre.nom.isNotEmpty ? membre.nom[0] : '',
      membre.prenom.isNotEmpty ? membre.prenom[0] : '',
    ].join().toUpperCase();

    return Material(color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.35),
              blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.4)),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: (membre.imageUrl !=null && membre.imageUrl!.isNotEmpty)
                          ? MemoryImage(base64Decode(membre.imageUrl!)) as ImageProvider
                          : null,
                      child: (membre.imageUrl == null || membre.imageUrl!.isEmpty)
                        ? Text(membre.prenom.isNotEmpty ? membre.prenom[0] : '?')
                        : null,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(onTap: onDelete,
                    child: Container(padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 16))),
                ]),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20)),
                  child: Text(membre.parente, style: const TextStyle(
                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 8),
                Text(membre.nomComplet, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 15,
                    fontWeight: FontWeight.w700, height: 1.2)),
                const SizedBox(height: 4),
                Text('Né(e) le ${membre.dateNaissance}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 11.5)),
              ]),
            ),
            Positioned(right: -30, top: -30,
              child: Container(width: 100, height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08)))),
          ]),
        ),
      ),
    );
  }
}
