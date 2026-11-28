/// Pure Arabic normalization and book-ID mapping helpers for Hadith Drift queries.
class HadithSearchHelper {
  HadithSearchHelper._();

  static final RegExp _diacritics = RegExp(
    r'[\u064B-\u065F\u0670\u0640\u06D6-\u06ED]',
  );
  static final RegExp _alefVariants = RegExp(r'[أإآٱ]');
  static final RegExp _nonWord = RegExp(r'[^\w\s\u0621-\u064A0-9]');
  static final RegExp _multiSpace = RegExp(r'\s+');

  /// Maps UI route/preference IDs (`nawawi_forty`, `sahih_bukhari`, ...) to
  /// canonical catalog database IDs (`nawawi`, `bukhari`, `muslim`, `riyad`).
  static String canonicalBookId(String bookId) => switch (bookId) {
        'nawawi_forty' || 'nawawi' => 'nawawi',
        'sahih_bukhari' || 'bukhari' => 'bukhari',
        'sahih_muslim' || 'muslim' => 'muslim',
        'riyad_assalihin' || 'riyad' => 'riyad',
        _ => bookId,
      };

  /// Maps canonical catalog book IDs back to EasyLocalization UI keys.
  static String translationKeyForBook(String bookId) => switch (bookId) {
        'nawawi' || 'nawawi_forty' => 'nawawi_forty',
        'bukhari' || 'sahih_bukhari' => 'sahih_bukhari',
        'muslim' || 'sahih_muslim' => 'sahih_muslim',
        'riyad' || 'riyad_assalihin' => 'riyad_assalihin',
        _ => 'nawawi_forty',
      };

  /// Strips diacritics and unifies Alef/Taa/Alef-Maqsura identically to the
  /// Python pre-indexer (`tool/build_hadith_db.py`).
  static String normalizeArabic(String input) {
    if (input.trim().isEmpty) return '';
    return input
        .replaceAll(_diacritics, '')
        .replaceAll(_alefVariants, 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll(_nonWord, ' ')
        .replaceAll(_multiSpace, ' ')
        .trim();
  }

  /// Builds a safe SQLite FTS5 `MATCH` expression supporting proclitic/prefix variants.
  static String? buildFtsMatchExpression(String rawQuery) {
    final normalized = normalizeArabic(rawQuery);
    if (normalized.isEmpty) return null;
    final tokens = normalized
        .split(' ')
        .map((t) => t.replaceAll('"', '').trim())
        .where((t) => t.isNotEmpty)
        .toList();
    if (tokens.isEmpty) return null;
    return tokens.map(_expandTokenGroup).join(' AND ');
  }

  static String _expandTokenGroup(String tok) {
    final variants = <String>{tok};
    if (tok.length >= 4 && 'وبفكل'.contains(tok[0])) {
      final stripped = tok.substring(1);
      variants.add(stripped);
      if (stripped.length >= 5 && stripped.startsWith('ال')) {
        variants.add(stripped.substring(2));
      }
    }
    if (tok.length >= 5 && tok.startsWith('ال')) {
      variants.add(tok.substring(2));
    }
    if (variants.length == 1) return '"$tok"*';
    return '(${variants.map((v) => '"$v"*').join(' OR ')})';
  }
}
