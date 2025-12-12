class PageViewHelper {
  /// Groups a list of Ayahs (from JSON) into a Map where Key is Page Number and Value is List of Ayahs.
  static Map<int, List<dynamic>> groupAyahsByPage(List<dynamic> ayahs) {
    Map<int, List<dynamic>> pages = {};
    for (var ayah in ayahs) {
      int page = ayah['page'];
      if (!pages.containsKey(page)) {
        pages[page] = [];
      }
      pages[page]!.add(ayah);
    }
    return pages;
  }
}
