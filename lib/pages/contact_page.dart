import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      _Data(Icons.phone_rounded, 'Téléphone', '+243 XXX XXX XXX', AppColors.tealGradient),
      _Data(Icons.email_rounded, 'Email', 'junior@example.com', AppColors.primaryGradient),
      _Data(Icons.location_on_rounded, 'Adresse', 'Goma, Nord-Kivu, RDC', AppColors.warmGradient),
      _Data(Icons.code_rounded, 'GitHub', 'github.com/juniorwandakajr', AppColors.primaryGradient),
      _Data(Icons.work_rounded, 'LinkedIn', 'linkedin.com/in/junior-kambale', AppColors.tealGradient),
    ];

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 140, pinned: true,
          backgroundColor: AppColors.primary, foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Contact',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            titlePadding: const EdgeInsets.only(left: 56, bottom: 14),
            background: Container(decoration: const BoxDecoration(gradient: AppColors.heroGradient)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            itemCount: contacts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => FadeSlideIn(
              delay: Duration(milliseconds: 60 * i),
              child: _Card(data: contacts[i])),
          ),
        ),
      ]),
    );
  }
}

class _Data {
  final IconData icon; final String title, value; final Gradient gradient;
  const _Data(this.icon, this.title, this.value, this.gradient);
}

class _Card extends StatelessWidget {
  final _Data data;
  const _Card({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: data.gradient.colors.first.withValues(alpha: 0.1),
          blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(children: [
        Container(width: 52, height: 52,
          decoration: BoxDecoration(
            gradient: data.gradient, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(
              color: data.gradient.colors.first.withValues(alpha: 0.35),
              blurRadius: 14, offset: const Offset(0, 6))]),
          child: Icon(data.icon, color: Colors.white, size: 24)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data.title, style: TextStyle(fontSize: 12,
            color: context.c.onSurfaceVariant, fontWeight: FontWeight.w500)),
          const SizedBox(height: 3),
          Text(data.value, style: TextStyle(fontSize: 14.5,
            color: context.c.onSurface, fontWeight: FontWeight.w600)),
        ])),
        Icon(Icons.arrow_forward_ios_rounded, size: 16, color: context.c.onSurfaceVariant),
      ]),
    );
  }
}
