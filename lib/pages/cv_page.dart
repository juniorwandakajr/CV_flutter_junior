import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 260, pinned: true,
          backgroundColor: AppColors.primary, foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white,
                          boxShadow: [BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: AppColors.primary,
                          backgroundImage: AssetImage('assets/profil.jpg'),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text('Junior Kambale Wandaka', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      const Text('Gestionnaire et Informaticien',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('Goma, RDC  •  juniorwandaka7@gmail.com  •  +243 984 506 008',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                    ]),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          sliver: SliverList(delegate: SliverChildListDelegate([
            FadeSlideIn(child: SectionCard(
              title: 'Profil', icon: Icons.person_outline_rounded,
              child: Text(
                "Professionnel motivé et polyvalent, doté d'une solide éthique de travail et d'une capacité à s'adapter rapidement à de nouveaux environnements. Reconnu pour sa rigueur, son sens de l'organisation et sa capacité à travailler efficacement en équipe.",
                style: TextStyle(color: context.c.onSurfaceVariant, height: 1.6)),
            )),
            FadeSlideIn(delay: const Duration(milliseconds: 80), child: SectionCard(
              title: 'Formation', icon: Icons.school_outlined, accent: AppColors.secondary,
              child: Column(children: const [
                _TimelineItem(icon: Icons.school, title: '3ème année Licence - Informatique appliquée à la gestion des entreprises',
                  subtitle: 'Institut Supérieur d\'Informatique et de Gestion (ISIG), Goma • nov. 2023 à ce jour', accent: AppColors.secondary),
                _TimelineItem(icon: Icons.workspace_premium, title: 'Diplôme en Technique Commerciale et Gestion',
                  subtitle: 'Institut Himbi, Goma • sept. 2022 à juil. 2023', accent: AppColors.secondary),
                _TimelineItem(icon: Icons.school, title: 'Études secondaires',
                  subtitle: 'Institut Majengo, Goma • sept. 2017 à juil. 2022', accent: AppColors.secondary),
                _TimelineItem(icon: Icons.school, title: 'Certificat de fin d\'études primaires',
                  subtitle: 'EP. Virunga-Nord, Goma • sept. 2010 à juil. 2017', accent: AppColors.secondary, isLast: true),
              ]),
            )),
            FadeSlideIn(delay: const Duration(milliseconds: 160), child: SectionCard(
              title: 'Expérience', icon: Icons.work_outline, accent: AppColors.accent,
              child: Column(children: const [
                _TimelineItem(icon: Icons.computer, title: 'Stagiaire informaticien en observation',
                  subtitle: 'CPTS-Goma, Goma • juil. 2026', accent: AppColors.accent),
                _TimelineItem(icon: Icons.local_pharmacy, title: 'Gérant',
                  subtitle: 'Pharmacie Germando, Goma • août 2025 à mars 2026', accent: AppColors.accent),
                _TimelineItem(icon: Icons.local_pharmacy, title: 'Stagiaire de gestion',
                  subtitle: 'Pharmacie Germando, Goma • août 2024 à mars 2026', accent: AppColors.accent),
                _TimelineItem(icon: Icons.code, title: 'Stagiaire informatique',
                  subtitle: 'Office Congolais de Contrôle, Goma • mai 2024 à juin 2024', accent: AppColors.accent),
                _TimelineItem(icon: Icons.local_hospital, title: 'Stagiaire de gestion',
                  subtitle: 'Hôpital Général de Référence Virunga, Goma • juil. 2022 à août 2022', accent: AppColors.accent, isLast: true),
              ]),
            )),
            FadeSlideIn(delay: const Duration(milliseconds: 240), child: SectionCard(
              title: 'Compétences', icon: Icons.auto_awesome_outlined, accent: AppColors.teal,
              child: Column(children: const [
                _SkillBar(label: 'Gestion administrative', value: 0.9, color: AppColors.teal),
                _SkillBar(label: 'Comptabilité / Gestion des stocks', value: 0.85, color: AppColors.primary),
                _SkillBar(label: 'Programmation / Informatique', value: 0.8, color: AppColors.secondary),
                _SkillBar(label: 'Bureautique', value: 0.9, color: AppColors.accent),
                _SkillBar(label: 'Rédaction professionnelle', value: 0.85, color: AppColors.pink),
              ]),
            )),
            FadeSlideIn(delay: const Duration(milliseconds: 320), child: SectionCard(
              title: 'Langues', icon: Icons.translate_rounded, accent: AppColors.pink,
              child: Wrap(spacing: 8, runSpacing: 8, children: const [
                _Pill(label: 'Français', level: 'Courant'),
                _Pill(label: 'Kiswahili', level: 'Maternelle'),
                _Pill(label: 'Lingala', level: 'Courant'),
                _Pill(label: 'Anglais', level: 'Level 1 - avec mention'),
              ]),
            )),
            FadeSlideIn(delay: const Duration(milliseconds: 400), child: SectionCard(
              title: 'Références', icon: Icons.contacts_outlined, accent: AppColors.primary,
              child: Column(children: const [
                _TimelineItem(icon: Icons.person, title: 'François Muhindo',
                  subtitle: 'Germando Pharma, Goma • +243 993 448 099', accent: AppColors.primary),
                _TimelineItem(icon: Icons.person, title: 'Samy Kyakwa',
                  subtitle: 'Hôpital Général de Référence Virunga, Goma', accent: AppColors.primary),
                _TimelineItem(icon: Icons.person, title: 'Kakuke Kasereka',
                  subtitle: 'Institut Himbi, Goma • +243 998 676 513', accent: AppColors.primary, isLast: true),
              ]),
            )),
          ])),
        ),
      ]),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData icon; final String title, subtitle; final Color accent; final bool isLast;
  const _TimelineItem({required this.icon, required this.title,
    required this.subtitle, required this.accent, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              accent.withValues(alpha: 0.25), accent.withValues(alpha: 0.08)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: accent, size: 18),
        ),
        if (!isLast) Expanded(child: Container(width: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: accent.withValues(alpha: 0.2))),
      ]),
      const SizedBox(width: 12),
      Expanded(child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 14, top: 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w600,
            fontSize: 14.5, color: context.c.onSurface)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(
            color: context.c.onSurfaceVariant, fontSize: 12.5)),
        ]),
      )),
    ]));
  }
}

class _SkillBar extends StatelessWidget {
  final String label; final double value; final Color color;
  const _SkillBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500,
            fontSize: 13.5, color: context.c.onSurface)),
          Text('${(value * 100).round()}%',
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12.5)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value, minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation(color))),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label, level;
  const _Pill({required this.label, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppColors.pink.withValues(alpha: 0.12), AppColors.pink.withValues(alpha: 0.04)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.pink.withValues(alpha: 0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600,
          fontSize: 13, color: context.c.onSurface)),
        const SizedBox(height: 2),
        Text(level, style: TextStyle(
          color: context.c.onSurfaceVariant, fontSize: 11)),
      ]),
    );
  }
}
