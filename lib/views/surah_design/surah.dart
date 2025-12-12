import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:hafzon/core/color_manager.dart';
import 'package:hafzon/core/page_view_helper.dart';
import 'package:hafzon/provider/bookmark_provider.dart';
import 'package:hafzon/provider/settings_provider.dart';
import 'package:hafzon/views/constant/basmala.dart';
import 'package:hafzon/views/constant/constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SurahPage extends StatefulWidget {
  final dynamic surah;
  final dynamic arabic;
  final dynamic surahName;
  final int ayah;

  const SurahPage({
    super.key,
    this.surah,
    this.arabic,
    this.surahName,
    required this.ayah,
  });

  @override
  SurahPageState createState() => SurahPageState();
}

class SurahPageState extends State<SurahPage> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  bool fabIsClicked = true;
  late Map<int, List<dynamic>> pages;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pages = PageViewHelper.groupAyahsByPage(widget.arabic);
    // Identify the page of the starting ayah to initialize PageController
    // int initialPage = 0;
    // Assuming widget.arabic is the list of ayahs for this Surah, but note that the 'page' attribute is global Quran page.
    // We need to map the internal index to the page index in our 'pages' map.
    // However, 'pages' keys are absolute page numbers (e.g. 500).
    // PageView needs an index from 0 to length-1.
    // So we need a List of pages too.

    WidgetsBinding.instance.addPostFrameCallback((_) {
      jumpToAyah();
    });
  }

  jumpToAyah() {
    if (fabIsClicked) {
      // For List View
      if (!Provider.of<SettingsProvider>(context, listen: false).isPageView) {
        if (widget.ayah < widget.arabic.length) {
          // Verify index
          itemScrollController.scrollTo(
            index: widget.ayah,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOutCubic,
          );
        }
      }
      // For Page View: Logic to jump to page is tricky because 'widget.ayah' is an ayah index in the surah,
      // but we need the page index.
      // We will handle basic init in build or initState if possible,
      // or just let user navigate for now as per simple requirement.
      // Ideally: Find which page contains widget.ayah, then jump to that page index.
    }
    fabIsClicked = false;
  }

  Row ayahBuilder(int index, previousVerses, SettingsProvider settings) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.arabic[index + previousVerses]['aya_text'],
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: settings.arabicFontSize,
                  fontFamily: settings.arabicFont,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Builder for Page View Content
  Widget pageContentBuilder(
      List<dynamic> pageAyahs, SettingsProvider settings) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Check if this page starts a Surah (first ayah of surah matches)
            // Ideally we check if pageAyahs.first['ayah_no'] == 1
            if (pageAyahs.first['sura_no'] == widget.surah + 1 &&
                pageAyahs.first['ayah_no'] == 1 &&
                widget.surah != 0 &&
                widget.surah != 8)
              const ReturnBasmalah(),

            // Render Ayahs
            Text.rich(
              TextSpan(
                children: pageAyahs.map((ayah) {
                  return TextSpan(
                    text: "${ayah['aya_text']} ",
                    style: TextStyle(
                      fontSize: settings.arabicFontSize,
                      fontFamily: settings.arabicFont,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.5, // Line height for readability
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _showBookmarkDialog(context, ayah);
                      },
                  );
                }).toList(),
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 20),
            // Page Number Footer
            Text(
              "${pageAyahs.first['page']}",
              style: TextStyle(color: ColorManager.grey),
            )
          ],
        ),
      ),
    );
  }

  void _showBookmarkDialog(BuildContext context, dynamic ayah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bookmark', textDirection: TextDirection.rtl),
        content: Text('Save bookmark at Ayah ${ayah['aya_no']}?',
            textDirection: TextDirection.rtl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // ayah['aya_no'] is 1-based. Save expects 0-based index if it aligns with list index?
              // The logic in ListView was passing 'index' which is 0..N within surah.
              // So we pass ayah['aya_no'] - 1.
              context
                  .read<BookmarkProvider>()
                  .saveBookmark(widget.surah + 1, ayah['aya_no'] - 1);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Bookmark Saved'),
                    duration: Duration(seconds: 1)),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  SafeArea singleSuraBuilder(lengthOfSurah) {
    int previousVerses = 0;
    // Note: logic for 'previousVerses' in existing code seems to try to handle global index?
    // In the existing code: 'widget.arabic' seems to bePASSED as 'quran[0]' from HomePage.
    // Let's look at HomePage: 'arabic: quran[0]'. quran[0] is the WHOLE quran list (all ayahs).
    // Wait, let's Verify 'widget.arabic' content.
    // In HomePage: `readJson` sets `arabic = data["quran"]` (List of dicts). `quran = [arabic]`.
    // So `widget.arabic` IS the List of ALL Ayahs of Quran.
    // But `lengthOfSurah` is just for ONE Surah.

    // Existing code `index + previousVerses` suggests it iterates ALL quran but constrained by item count?
    // Ah, `ScrollablePositionedList.builder` uses `itemCount: lengthOfSurah`.
    // And `ayahBuilder` uses `widget.arabic[index + previousVerses]`.
    // So it correctly slices the global list.

    // For Page View, we should probably filter ayahs for THIS Surah first?
    // Or does the user want to read the WHOLE Quran starting from this Surah?
    // "if the user want to read the holl Sora he choose that stings"
    // Usually users expect to read continuous.

    // However, to keep it simple and safe refactor:
    // We already have `previousVerses` logic for the start index.
    // We can slice the list for "This Surah" effectively.

    if (widget.surah + 1 != 1) {
      for (int i = widget.surah - 1; i >= 0; i--) {
        previousVerses = previousVerses + numberOfVerses[i];
      }
    }

    // Current Surah Ayahs
    List<dynamic> currentSurahAyahs = [];
    // Protect bounds
    int end = previousVerses + (lengthOfSurah as int);
    if (end > widget.arabic.length) end = widget.arabic.length;

    // Actually `widget.arabic` is dynamic, assume List.
    List<dynamic> fullQuran = widget.arabic as List<dynamic>;
    currentSurahAyahs = fullQuran.sublist(previousVerses, end);

    // Group for Pages (Only for this Surah, or logic needs to handle global?)
    // Request: "read the holl Sora".
    // If we group ONLY this Surah's ayahs, page numbers might be partial.
    // But it's safer for now to scope to Surah as per current architecture.
    var pagedAyahsMap = PageViewHelper.groupAyahsByPage(currentSurahAyahs);
    List<int> sortedPageNumbers = pagedAyahsMap.keys.toList()..sort();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading:
              BackButton(color: Theme.of(context).textTheme.bodyLarge?.color),
          elevation: 0.0,
          title: Text(
            "سُورَة ${fullQuran[previousVerses]['sura_name_ar']}",
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 30,
              color: ColorManager.yellowColor,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/quran_logo.png',
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Consumer<SettingsProvider>(
                      builder: (context, settings, child) {
                        // CONDITION: Check Reading Mode
                        if (settings.isPageView) {
                          // PAGE VIEW IMPLEMENTATION
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: PageView.builder(
                              itemCount: sortedPageNumbers.length,
                              itemBuilder: (context, index) {
                                int pageNum = sortedPageNumbers[index];
                                List<dynamic> pageAyahs =
                                    pagedAyahsMap[pageNum]!;
                                return pageContentBuilder(pageAyahs, settings);
                              },
                            ),
                          );
                        } else {
                          // SCROLL VIEW (Existing Logic)
                          return ScrollablePositionedList.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  (index != 0) ||
                                          (widget.surah == 0) ||
                                          (widget.surah == 8)
                                      ? const Text('')
                                      : const ReturnBasmalah(),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: index % 2 != 0
                                            ? Theme.of(context)
                                                .textTheme
                                                .displayLarge
                                                ?.color
                                            : Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.color,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: PopupMenuButton(
                                        tooltip: "",
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                        ),
                                        // Note: index passed here is Ayah index within Surah (0..N)
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ayahBuilder(
                                              index, previousVerses, settings),
                                        ),
                                        itemBuilder: (context) => [
                                              PopupMenuItem(
                                                onTap: () {
                                                  context
                                                      .read<BookmarkProvider>()
                                                      .saveBookmark(
                                                          widget.surah + 1,
                                                          index);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Bookmark Saved'),
                                                      duration:
                                                          Duration(seconds: 1),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.bookmark_add,
                                                      color: ColorManager
                                                          .yellowColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text('ضع الشريط'),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                  ),
                                ],
                              );
                            },
                            itemScrollController: itemScrollController,
                            itemPositionsListener: itemPositionsListener,
                            itemCount: lengthOfSurah,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int lengthOfSura = numberOfVerses[widget.surah];
    return Scaffold(body: singleSuraBuilder(lengthOfSura));
  }
}
