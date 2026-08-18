import 'package:flutter/material.dart';

void main() {
  runApp(const PostHunterApp());
}

class PostHunterApp extends StatelessWidget {
  const PostHunterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'صائد البوستات',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7CFF00),
          brightness: Brightness.dark,
        ),
      ),
      home: const HunterHomePage(),
    );
  }
}

class HunterHomePage extends StatefulWidget {
  const HunterHomePage({super.key});

  @override
  State<HunterHomePage> createState() => _HunterHomePageState();
}

class _HunterHomePageState extends State<HunterHomePage> {
  final controller = TextEditingController();

  final examples = [
    'محتاج نقاش',
    'نقاش شاطر',
    'صنايعي نقاش',
    'دهان شقة',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'صائد البوستات',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.radar_rounded,
              size: 80,
              color: Color(0xFF7CFF00),
            ),
            const SizedBox(height: 15),
            const Text(
              'لقط البوست المطلوب بسرعة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'اكتب الخدمة أو الطلب اللي بتدور عليه...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 55,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        controller.text.isEmpty
                            ? 'اكتب كلمة للبحث الأول'
                            : 'البحث عن: ${controller.text}',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.radar),
                label: const Text(
                  'ابدأ الصيد',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'أمثلة سريعة',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...examples.map(
              (example) => Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.bolt,
                    color: Color(0xFF7CFF00),
                  ),
                  title: Text(example),
                  onTap: () {
                    controller.text = example;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
