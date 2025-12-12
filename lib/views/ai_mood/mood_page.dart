import 'package:flutter/material.dart';
import 'package:hafzon/core/color_manager.dart';

import 'package:provider/provider.dart';
import 'package:hafzon/provider/settings_provider.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  // Mapping moods to verses
  final List<Map<String, String>> moods = [
    {
      'mood': 'حزين', // Sad
      'emoji': '😢',
      'surah': 'الضحى',
      'ayah': 'وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ', // Duha: 5
      'desc': 'رسالة أمل: الله يخبئ لك العوض الجميل.'
    },
    {
      'mood': 'قلق', // Anxious
      'emoji': '😰',
      'surah': 'الرعد',
      'ayah': 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ', // Rad: 28
      'desc': 'الطمأنينة الحقيقية تكمن في ذكر الله.'
    },
    {
      'mood': 'سعيد', // Happy
      'emoji': '😊',
      'surah': 'إبراهيم',
      'ayah': 'لَئِن شَكَرْتُمْ لَأَزِيدَنَّكُمْ', // Ibrahim: 7
      'desc': 'بالشكر تدوم النعم وتزيد.'
    },
    {
      'mood': 'خائف', // Fearful
      'emoji': '😨',
      'surah': 'التوبة',
      'ayah': 'لَا تَحْزَنْ إِنَّ اللَّهَ مَعَنَا', // Tawbah: 40
      'desc': 'معية الله هي الأمان المطلق.'
    },
    {
      'mood': 'ضعيف', // Weak
      'emoji': '😞',
      'surah': 'النساء',
      'ayah': 'وَخُلِقَ الْإِنسَانُ ضَعِيفًا', // Nisa: 28
      'desc': 'الله يعلم ضعفك وسيعينك عليه.'
    },
    {
      'mood': 'غاضب', // Angry
      'emoji': '😡',
      'surah': 'آل عمران',
      'ayah':
          'وَالْكَاظِمِينَ الْغَيْظَ وَالْعَافِينَ عَنِ النَّاسِ', // Al-Imran: 134
      'desc': 'العفو وكظم الغيظ من شيم المحسنين.'
    },
    {
      'mood': 'مهموم', // Worried
      'emoji': '😔',
      'surah': 'الشرح',
      'ayah': 'إِنَّ مَعَ الْعُسْرِ يُسْرًا', // Ash-Sharh: 6
      'desc': 'كل عسر يتبعه يسر، وعد رباني.'
    },
    {
      'mood': 'وحيد', // Lonely
      'emoji': '🚶',
      'surah': 'ق',
      'ayah': 'وَنَحْنُ أَقْرَبُ إِلَيْهِ مِنْ حَبْلِ الْوَرِيدِ', // Qaf: 16
      'desc': 'لست وحدك، الله أقرب إليك من نفسك.'
    },
  ];

  Map<String, String>? selectedMood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "آية لقلبك",
          style: TextStyle(color: Color(0xffee8f8b)),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading:
            BackButton(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "بماذا تشعر اليوم؟",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5,
                ),
                itemCount: moods.length,
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  final isSelected = selectedMood == mood;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = mood;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorManager.orangeColor
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        border: isSelected
                            ? Border.all(
                                color: ColorManager.orangeColor, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mood['emoji']!,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mood['mood']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (selectedMood != null) ...[
              const Divider(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.orangeColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "سورة ${selectedMood!['surah']}",
                      style: TextStyle(
                        color: ColorManager.orangeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Consumer<SettingsProvider>(
                      builder: (context, settings, child) {
                        return Text(
                          selectedMood!['ayah']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: settings.arabicFont,
                            fontSize: 28,
                            height: 1.5,
                          ),
                          textDirection: TextDirection.rtl,
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    Text(
                      selectedMood!['desc']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
