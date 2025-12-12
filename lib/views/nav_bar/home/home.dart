import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hafzon/core/color_manager.dart';
import 'package:hafzon/core/helper_methods.dart';
import 'package:hafzon/provider/bookmark_provider.dart';
import 'package:hafzon/views/constant/constants.dart';
import 'package:hafzon/views/constant/logo_name.dart';
import 'package:hafzon/views/surah_design/surah.dart';
import 'package:hafzon/views/ai_mood/mood_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Go to bookmark',
        backgroundColor: ColorManager.orangeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          var bookmark = context.read<BookmarkProvider>();
          navigateTo(
              page: SurahPage(
            arabic: quran[0],
            surah: bookmark.bookmarkedSurah - 1,
            surahName: arabicName[bookmark.bookmarkedSurah - 1]['name'],
            ayah: bookmark.bookmarkedAyah,
          ));
        },
        child: Icon(
          Icons.bookmark,
          color: Theme.of(context).scaffoldBackgroundColor,
          size: 50,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: readJson(),
          builder: (
            BuildContext context,
            AsyncSnapshot snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: ColorManager.orangeColor,
              ));
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('خطأ'); // Error
              } else if (snapshot.hasData) {
                return indexCreator(snapshot.data, context);
              } else {
                return const Text('لا توجد بيانات'); // Empty data
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }

  Widget indexCreator(quran, context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const LogoName(),
            // AI Mood Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  navigateTo(page: const MoodPage());
                },
                icon: const Icon(Icons.favorite, color: Colors.white),
                label: const Text(
                  "آية لقلبك", // Verse for your heart
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.orangeColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            // Search Bar
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).listTileTheme.tileColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: "ابحث عن سورة", // Search for Surah
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.7),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < 114; i++)
                    if (arabicName[i]['name'].contains(_searchQuery) ||
                        arabicName[i]['surah'].contains(_searchQuery))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).listTileTheme.tileColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: ColorManager.yellowColor,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: ColorManager.yellowColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        arabicName[i]['surah'],
                                        style: TextStyle(
                                          color: ColorManager.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    arabicName[i]['name'],
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                      fontFamily: 'quran',
                                    ),
                                    textDirection: TextDirection.rtl,
                                  ),
                                ],
                              ),
                              onPressed: () {
                                navigateTo(
                                  page: SurahPage(
                                    arabic: quran[0],
                                    surah: i,
                                    surahName: arabicName[i]['name'],
                                    ayah: 0,
                                  ),
                                );
                              }),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
