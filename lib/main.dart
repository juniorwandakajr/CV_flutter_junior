import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV Junior Kambale Wandaka',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const LoginPage(),
    );
  }
}

// PAGE 1 : CONNEXION - SANS MOT DE PASSE
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _identifiant = TextEditingController();

  void _seConnecter() {
    if (_identifiant.text.isNotEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Remplis ton identifiant')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CircleAvatar(radius: 55, backgroundColor: Colors.blue, child: Text('JW', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              const Text('Bienvenue', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const Text('Junior Kambale Wandaka', style: TextStyle(fontSize: 18, color: Colors.blue)),
              const Text('Connectez-vous pour voir mon CV'),
              const SizedBox(height: 30),
              TextField(controller: _identifiant, decoration: const InputDecoration(labelText: 'Identifiant', prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _seConnecter, child: const Text('Se connecter', style: TextStyle(fontSize: 18)))),
            ],
          ),
        ),
      ),
    );
  }
}

// NAVIGATION
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final List<Widget> _pages = const [CvPage(), FamillePage(), ContactPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CV - Junior Kambale Wandaka')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(decoration: BoxDecoration(color: Colors.blue), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/profil1.jpg')), SizedBox(height: 10), Text('Junior Kambale Wandaka', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), Text('Gestionnaire et Informaticien', style: TextStyle(color: Colors.white70))])),
            ListTile(leading: const Icon(Icons.person), title: const Text('Mon CV'), onTap: () { setState(() => _index = 0); Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.family_restroom), title: const Text('Ma Famille'), onTap: () { setState(() => _index = 1); Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.contact_mail), title: const Text('Contact'), onTap: () { setState(() => _index = 2); Navigator.pop(context); }),
            ListTile(leading: const Icon(Icons.logout), title: const Text('Deconnexion'), onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())); }),
          ],
        ),
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(currentIndex: _index, onTap: (i) => setState(() => _index = i), items: const [BottomNavigationBarItem(icon: Icon(Icons.person), label: 'CV'), BottomNavigationBarItem(icon: Icon(Icons.family_restroom), label: 'Famille'), BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Contact')]),
    );
  }
}

// PAGE 2 : CV AVEC TA PHOTO
class CvPage extends StatelessWidget {
  const CvPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Center(child: Column(children: [CircleAvatar(radius: 60, backgroundImage: AssetImage('assets/profil1.jpg')), SizedBox(height: 12), Text('JUNIOR KAMBALE WANDAKA', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center), Text('Gestionnaire et Informaticien', style: TextStyle(fontSize: 16, color: Colors.blue)), SizedBox(height: 4), Text('Ne le 22 janvier 2006 a Goma - Congolais - Celibataire', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center)])),
        const SizedBox(height: 16),
        const Text('Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        const Card(child: Padding(padding: EdgeInsets.all(12), child: Text('Professionnel motive et polyvalent, dote d\'une solide ethique de travail et d\'une capacite a s\'adapter rapidement. Reconnu pour ma rigueur, mon sens de l\'organisation et ma capacite a travailler efficacement en equipe.'))),
        const SizedBox(height: 12),
        const Text('Formation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        const Card(child: ListTile(title: Text('Etudes universitaires - 2eme annee Licence'), subtitle: Text('Nov. 2023 a ce jour\nInstitut Superieur d\'Informatique et de Gestion, Goma\nInformatique appliquee a la gestion des entreprises'))),
        const Card(child: ListTile(title: Text('Etudes secondaires - Institut Himbi, Goma'), subtitle: Text('Sept. 2022 - Juil. 2023\nDiplome en Technique Commerciale et Gestion'))),
        const Card(child: ListTile(title: Text('Etudes secondaires - Institut Majengo, Goma'), subtitle: Text('Sept. 2017 - Juil. 2022'))),
        const Card(child: ListTile(title: Text('Etudes primaires - EP Virunga-Nord, Goma'), subtitle: Text('Sept. 2010 - Juil. 2017\nCertificat de fin d\'etudes primaires'))),
        const SizedBox(height: 12),
        const Text('Experience Professionnelle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        const Card(child: ListTile(title: Text('Gerant - Pharmacie Germando, Goma'), subtitle: Text('Aout 2025 a ce jour\nGestion de la pharmacie, gestion des stocks'))),
        const Card(child: ListTile(title: Text('Stagiaire de gestion - Pharmacie Germando'), subtitle: Text('Aout 2024 a ce jour'))),
        const Card(child: ListTile(title: Text('Stagiaire informatique - Office Congolais de Controle'), subtitle: Text('Mai 2024 - Juin 2024, Goma'))),
        const Card(child: ListTile(title: Text('Stagiaire de gestion - Hopital General de Reference Virunga'), subtitle: Text('Juil. 2022 - Aout 2022, Goma'))),
        const SizedBox(height: 12),
        const Text('Competences Techniques', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        const Wrap(spacing: 8, runSpacing: 8, children: [Chip(label: Text('Gestion administrative')), Chip(label: Text('Comptabilite')), Chip(label: Text('Gestion des stocks')), Chip(label: Text('Programmation')), Chip(label: Text('Bureautique')), Chip(label: Text('Flutter / Dart')), Chip(label: Text('Redaction professionnelle'))]),
        const SizedBox(height: 12),
        const Text('Langues', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        const Card(child: ListTile(title: Text('Francais - Courant'))),
        const Card(child: ListTile(title: Text('Kiswahili - Courant'))),
        const Card(child: ListTile(title: Text('Lingala - Courant'))),
        const Card(child: ListTile(title: Text('Anglais - Level 1 - Certificat Dec. 2025'))),
        const SizedBox(height: 12),
        const Text('Qualites', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        const Text('• Adaptabilite  • Empathie  • Sens de l\'organisation\n• Creativite  • Leadership  • Esprit d\'equipe'),
        const SizedBox(height: 12),
        const Text('Centres d\'interet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        const Text('• Lecture  • Photographie  • Jeux video\n• Football  • Voyage  • Musique\n• Apprentissage des langues'),
        const SizedBox(height: 12),
        const Text('References', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
        const Card(child: ListTile(title: Text('Francois Muhindo'), subtitle: Text('Germando Pharma, Goma\n+243 993 448 099'))),
        const Card(child: ListTile(title: Text('Samy Kyakwa'), subtitle: Text('Hopital General de Reference Virunga, Goma'))),
        const Card(child: ListTile(title: Text('Kakuke Kasereka'), subtitle: Text('Institut Himbi, Goma\n+243 998 676 513'))),
      ]),
    );
  }
}

// PAGE 3 : FAMILLE
class FamillePage extends StatelessWidget {
  const FamillePage({super.key});
  @override
  Widget build(BuildContext context) {
    final famille = [
      {'nom': 'Francois Muhindo', 'lien': 'Pere', 'job': 'Infirmier', 'initiales': 'FM', 'couleur': Colors.blue},
      {'nom': 'Furaha Soki', 'lien': 'Mere', 'job': 'Sans profession', 'initiales': 'FS', 'couleur': Colors.pink},
      {'nom': 'Jonathan Wandaka', 'lien': 'Frere', 'job': 'Eleve', 'initiales': 'JW', 'couleur': Colors.green},
      {'nom': 'Laureintine Wandaka', 'lien': 'Soeur', 'job': 'Eleve', 'initiales': 'LW', 'couleur': Colors.orange},
    ];
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Ma Famille', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      const Text('Les personnes les plus importantes pour moi', style: TextStyle(color: Colors.grey)),
      const SizedBox(height: 16),
      for (var m in famille) Card(elevation: 3, margin: const EdgeInsets.only(bottom: 12), child: ListTile(leading: CircleAvatar(radius: 28, backgroundColor: m['couleur'] as Color, child: Text(m['initiales'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), title: Text(m['nom'] as String, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${m['lien']} - ${m['job']}'), trailing: const Icon(Icons.favorite, color: Colors.red))),
    ]);
  }
}

// PAGE 4 : CONTACT
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: const [
      Text('Mes Coordonnees', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      SizedBox(height: 16),
      Card(child: ListTile(leading: Icon(Icons.phone, color: Colors.green), title: Text('Telephone'), subtitle: Text('+243 984 506 008'))),
      Card(child: ListTile(leading: Icon(Icons.email, color: Colors.red), title: Text('E-mail'), subtitle: Text('juniorwandaka7@gmail.com'))),
      Card(child: ListTile(leading: Icon(Icons.location_on, color: Colors.blue), title: Text('Adresse'), subtitle: Text('Q. Mabanga-Nord, Av. Salongo 1, N°64 Goma'))),
      Card(child: ListTile(leading: Icon(Icons.cake, color: Colors.purple), title: Text('Date de naissance'), subtitle: Text('22 janvier 2006 - Goma'))),
      Card(child: ListTile(leading: Icon(Icons.link), title: Text('LinkedIn'), subtitle: Text('linkedin.com/in/juniorwandaka'))),
      Card(child: ListTile(leading: Icon(Icons.code), title: Text('GitHub'), subtitle: Text('github.com/juniorwandaka'))),
      Card(child: ListTile(leading: Icon(Icons.camera_alt, color: Colors.purple), title: Text('Facebook'), subtitle: Text('Junior Wandaka'))),
      Card(child: ListTile(leading: Icon(Icons.camera_alt, color: Colors.pink), title: Text('Instagram'), subtitle: Text('junior_wandaka'))),
      SizedBox(height: 20),
      Center(child: Text('Merci de me contacter !', style: TextStyle(fontSize: 16))),
    ]);
  }
}
