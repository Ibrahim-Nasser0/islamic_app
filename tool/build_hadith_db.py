"""Builds the pre-indexed, FTS5-enabled, gzipped Hadith SQLite catalog."""

import gzip
import json
import pathlib
import re
import sqlite3

ROOT = pathlib.Path(__file__).resolve().parent.parent
ASSETS_DIR = ROOT / 'assets' / 'hadith'
SCRATCH = pathlib.Path(
    r'C:\Users\IBRAHIM\.gemini\antigravity\brain\40315766-fe5c-457f-a3c1-1f962ee75f9d\scratch'
)

DIACRITICS = re.compile(r'[\u064B-\u065F\u0670\u0640\u06D6-\u06ED]')
PUNCT = re.compile(r'[^\w\s]')

NAWAWI_SAHIH_MAP = {
    1: 'muttafaq', 2: 'sahih', 3: 'muttafaq', 4: 'muttafaq', 5: 'muttafaq',
    6: 'muttafaq', 7: 'sahih', 8: 'muttafaq', 9: 'muttafaq', 10: 'sahih',
    13: 'sahih', 14: 'muttafaq', 15: 'muttafaq', 16: 'sahih', 17: 'sahih',
    20: 'sahih', 21: 'sahih', 22: 'sahih', 23: 'sahih', 24: 'sahih',
    25: 'sahih', 26: 'muttafaq', 34: 'sahih', 35: 'sahih', 36: 'sahih',
    37: 'muttafaq', 38: 'sahih', 40: 'sahih',
}


def normalize_arabic(text: str) -> str:
    cleaned = DIACRITICS.sub('', text)
    cleaned = re.sub(r'[أإآٱ]', 'ا', cleaned)
    cleaned = cleaned.replace('ة', 'ه').replace('ى', 'ي')
    return ' '.join(PUNCT.sub(' ', cleaned).split())


def build_fts_tokens(text: str) -> str:
    base = normalize_arabic(text)
    extra: list[str] = []
    seen = set(base.split())
    for tok in list(seen):
        if len(tok) >= 4 and tok[0] in ('و', 'ف', 'ب', 'ك', 'ل'):
            stripped = tok[1:]
            if stripped not in seen:
                seen.add(stripped)
                extra.append(stripped)
        if len(tok) >= 5 and tok.startswith('ال'):
            root_tok = tok[2:]
            if root_tok not in seen:
                seen.add(root_tok)
                extra.append(root_tok)
    return f'{base} {" ".join(extra)}' if extra else base


def classify_grade(book_id: str, number: int, arabic_text: str) -> tuple[str, str, str, int]:
    if book_id in ('bukhari', 'muslim'):
        return ('sahih', 'صحيح ثابت', 'Authentic (Sahih)', 4)

    if book_id == 'nawawi' and number in NAWAWI_SAHIH_MAP:
        tier = NAWAWI_SAHIH_MAP[number]
        if tier == 'muttafaq':
            return ('muttafaq', 'صحيح • متفق عليه', 'Sahih • Agreed Upon', 4)
        return ('sahih', 'صحيح ثابت', 'Authentic (Sahih)', 4)

    n = normalize_arabic(arabic_text)
    if 'متفق عليه' in n or ('البخاري' in n and 'مسلم' in n) or 'صحيحيهما' in n:
        return ('muttafaq', 'صحيح • متفق عليه', 'Sahih • Agreed Upon', 4)
    if (
        'رواه البخاري' in n
        or 'رواه مسلم' in n
        or 'حديث صحيح' in n
        or 'اسناد صحيح' in n
        or 'باسناد صحيح' in n
        or 'البخاري' in n
        or 'مسلم' in n
    ):
        return ('sahih', 'صحيح', 'Authentic (Sahih)', 4)
    if 'حسن صحيح' in n:
        return ('hasan_sahih', 'حسن صحيح', 'Hasan Sahih', 4)
    if 'حديث حسن' in n or 'اسناد حسن' in n or 'باسناد حسن' in n or 'حسن' in n.split('رواه')[-1]:
        return ('hasan', 'حديث حسن', 'Good (Hasan)', 3)
    return ('needs_verification', 'تخريج الحديث في المتن', 'Citation In Text', 2)


def build_database() -> None:
    db_path = SCRATCH / 'hadith_catalog_build.db'
    if db_path.exists():
        db_path.unlink()

    conn = sqlite3.connect(db_path)
    conn.execute('''
        CREATE TABLE hadith_books (
          id TEXT PRIMARY KEY NOT NULL,
          title_ar TEXT NOT NULL,
          title_en TEXT NOT NULL,
          total_count INTEGER NOT NULL,
          default_grade_ar TEXT NOT NULL
        )
    ''')
    conn.execute('''
        CREATE TABLE hadiths (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          book_id TEXT NOT NULL,
          number INTEGER NOT NULL,
          chapter_ar TEXT NOT NULL,
          title_ar TEXT NOT NULL,
          arabic_text TEXT NOT NULL,
          narrator TEXT NOT NULL,
          reference TEXT NOT NULL,
          benefit TEXT,
          grade_tier TEXT NOT NULL,
          grade_label_ar TEXT NOT NULL,
          grade_label_en TEXT NOT NULL,
          strength_score INTEGER NOT NULL,
          text_length INTEGER NOT NULL
        )
    ''')
    conn.execute('CREATE UNIQUE INDEX idx_hadiths_book_num ON hadiths(book_id, number)')
    conn.execute('CREATE INDEX idx_hadiths_grade ON hadiths(book_id, grade_tier)')
    conn.execute('CREATE INDEX idx_hadiths_daily_pool ON hadiths(grade_tier, text_length)')
    conn.execute('''
        CREATE VIRTUAL TABLE hadiths_fts USING fts5(
          search_normalized,
          content='',
          detail='none',
          tokenize='unicode61'
        )
    ''')

    hadith_rows: list[tuple] = []
    fts_rows: list[tuple[int, str]] = []

    def add_row(
        book_id: str,
        num: int,
        ch: str,
        title: str,
        ar: str,
        narrator: str,
        ref: str,
        benefit: str | None,
    ) -> None:
        tier, gar, gen, score = classify_grade(book_id, num, ar)
        row_id = len(hadith_rows) + 1
        hadith_rows.append((
            row_id, book_id, num, ch, title, ar, narrator, ref, benefit,
            tier, gar, gen, score, len(ar),
        ))
        fts_rows.append((row_id, build_fts_tokens(f'{num} {title} {ar} {ch}')))

    # 1. Nawawi 42 from extracted scratch source (or compressed asset if present)
    nawawi_src = SCRATCH / 'nawawi_src.json'
    if nawawi_src.exists():
        nawawi_items = json.loads(nawawi_src.read_text(encoding='utf-8'))
    else:
        nawawi_items = json.loads(
            gzip.decompress((ASSETS_DIR / 'nawawi.json.gz').read_bytes()).decode('utf-8')
        )
    for h in nawawi_items:
        add_row(
            'nawawi',
            int(h['number']),
            (h.get('chapter') or 'الأربعون النووية').strip(),
            h['title'].strip(),
            h['arabicText'].strip(),
            h.get('narrator', '').strip(),
            h.get('reference', '').strip(),
            h.get('benefit'),
        )

    books_meta = [
        ('nawawi', 'الأربعون النووية', 'Forty Nawawi', len(nawawi_items), 'صحيح وحسن'),
    ]

    sources = [
        ('bukhari', 'bukhari_src.json', 'صحيح البخاري', 'Sahih Al-Bukhari', 'صحيح ثابت'),
        ('muslim', 'muslim_src.json', 'صحيح مسلم', 'Sahih Muslim', 'صحيح ثابت'),
        ('riyad', 'riyad_src.json', 'رياض الصالحين', 'Riyad As-Salihin', 'متنوع الدرجات المخرّجة'),
    ]

    for bid, src_file, title_ar, title_en, def_grade in sources:
        raw = json.loads((SCRATCH / src_file).read_text(encoding='utf-8'))
        chapters = {c['id']: c['arabic'].strip() for c in raw.get('chapters', [])}
        count = 0
        for h in raw['hadiths']:
            ar = (h.get('arabic') or '').strip()
            if not ar:
                continue
            count += 1
            ch = chapters.get(h.get('chapterId'), title_ar).strip() or title_ar
            short_ch = ch.replace('كتاب ', '').strip() if ch.startswith('كتاب ') else ch
            htitle = f'حديث في {short_ch} #{count}' if short_ch else f'{title_ar} #{count}'
            eng = h.get('english')
            narrator = (eng.get('narrator') or '').strip() if isinstance(eng, dict) else ''
            if not narrator:
                narrator = 'صحابي جليل رضي الله عنه'
            ref = f'{title_ar} (حديث رقم {count})'
            add_row(bid, count, ch, htitle, ar, narrator, ref, f'من توجيهات النبوة في {ch}')
        books_meta.append((bid, title_ar, title_en, count, def_grade))

    conn.executemany(
        'INSERT INTO hadith_books(id, title_ar, title_en, total_count, default_grade_ar) VALUES (?,?,?,?,?)',
        books_meta,
    )
    conn.executemany(
        '''INSERT INTO hadiths(
            id, book_id, number, chapter_ar, title_ar, arabic_text, narrator,
            reference, benefit, grade_tier, grade_label_ar, grade_label_en,
            strength_score, text_length
        ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)''',
        hadith_rows,
    )
    conn.executemany(
        'INSERT INTO hadiths_fts(rowid, search_normalized) VALUES (?,?)',
        fts_rows,
    )
    conn.execute('PRAGMA user_version = 1')
    conn.commit()
    conn.execute('ANALYZE')
    conn.execute('VACUUM')

    # Verify FTS5 & daily pool queries work before compressing
    hits = conn.execute(
        '''SELECT h.book_id, h.number, h.grade_tier FROM hadiths h
           JOIN hadiths_fts f ON f.rowid = h.id
           WHERE hadiths_fts MATCH 'النيات' AND h.book_id = 'bukhari' '''
    ).fetchall()
    daily_count = conn.execute(
        "SELECT COUNT(*) FROM hadiths WHERE grade_tier IN ('muttafaq','sahih') AND text_length <= 420"
    ).fetchone()[0]
    conn.close()

    out_gz = ASSETS_DIR / 'hadith_catalog.db.gz'
    out_gz.write_bytes(gzip.compress(db_path.read_bytes(), compresslevel=9))
    print(
        f'Built {len(hadith_rows)} total hadiths -> {out_gz.name}: '
        f'raw={db_path.stat().st_size / 1024 / 1024:.2f} MB, '
        f'gz={out_gz.stat().st_size / 1024 / 1024:.2f} MB | '
        f'fts_hits={len(hits)} | daily_sahih_pool={daily_count}'
    )
    db_path.unlink()


if __name__ == '__main__':
    build_database()
