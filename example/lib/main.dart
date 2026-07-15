import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myanmar_kit/myanmar_kit.dart';

enum FontPairPreset {
  robotoNotoSansMyanmar(
    'Roboto + Noto Sans Myanmar',
    'Roboto',
    'Noto Sans Myanmar',
  ),
  openSansNotoSansMyanmar(
    'Open Sans + Noto Sans Myanmar',
    'Open Sans',
    'Noto Sans Myanmar',
  ),
  sourceSansNotoSerifMyanmar(
    'Source Sans 3 + Noto Serif Myanmar',
    'Source Sans 3',
    'Noto Serif Myanmar',
  );

  const FontPairPreset(this.label, this.latinFamily, this.myanmarFamily);

  final String label;
  final String latinFamily;
  final String myanmarFamily;
}

enum NewsTab { home, topics, saved, lab }

void main() {
  runApp(const MyanmarKitExampleApp());
}

class MyanmarKitExampleApp extends StatefulWidget {
  const MyanmarKitExampleApp({super.key});

  @override
  State<MyanmarKitExampleApp> createState() => _MyanmarKitExampleAppState();
}

class _MyanmarKitExampleAppState extends State<MyanmarKitExampleApp> {
  FontPairPreset _preset = FontPairPreset.robotoNotoSansMyanmar;
  double _minScale = 0.9;
  double _maxScale = 1.0;
  final Set<String> _bookmarkedIds = <String>{'2', '4'};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: GoogleFonts.pendingFonts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final latinFont = _fontFamilyFor(_preset.latinFamily);
        final myanmarFont = _fontFamilyFor(_preset.myanmarFamily);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F6D7A),
              brightness: Brightness.light,
              surface: const Color(0xFFF7F3EC),
            ),
            scaffoldBackgroundColor: const Color(0xFFF7F3EC),
            textTheme: _textThemeFor(latinFont),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            extensions: [
              MMTextTheme(
                myanmarFont: myanmarFont,
                latinFont: latinFont,
                minScale: _minScale,
                maxScale: _maxScale,
              ),
            ],
            appBarTheme: const AppBarTheme(
              centerTitle: false,
              scrolledUnderElevation: 0,
              backgroundColor: Color(0xFFF7F3EC),
              surfaceTintColor: Colors.transparent,
            ),
          ),
          home: _NewsShell(
            articles: sampleArticles,
            selectedPreset: _preset,
            minScale: _minScale,
            maxScale: _maxScale,
            bookmarkedIds: _bookmarkedIds,
            onPresetChanged: (preset) {
              setState(() {
                _preset = preset;
              });
            },
            onMinScaleChanged: (value) {
              setState(() {
                _minScale = value;
              });
            },
            onMaxScaleChanged: (value) {
              setState(() {
                _maxScale = value;
              });
            },
            onToggleBookmark: (articleId) {
              setState(() {
                if (_bookmarkedIds.contains(articleId)) {
                  _bookmarkedIds.remove(articleId);
                } else {
                  _bookmarkedIds.add(articleId);
                }
              });
            },
          ),
        );
      },
    );
  }

  String _fontFamilyFor(String family) {
    return switch (family) {
      'Roboto' => GoogleFonts.roboto().fontFamily ?? 'Roboto',
      'Open Sans' => GoogleFonts.openSans().fontFamily ?? 'Open Sans',
      'Source Sans 3' =>
        GoogleFonts.sourceSans3().fontFamily ?? 'Source Sans 3',
      'Noto Sans Myanmar' =>
        GoogleFonts.notoSansMyanmar().fontFamily ?? 'Noto Sans Myanmar',
      'Noto Serif Myanmar' =>
        GoogleFonts.notoSerifMyanmar().fontFamily ?? 'Noto Serif Myanmar',
      _ => family,
    };
  }

  TextTheme _textThemeFor(String family) {
    return switch (family) {
      'Roboto' => GoogleFonts.robotoTextTheme(),
      'Open Sans' => GoogleFonts.openSansTextTheme(),
      'Source Sans 3' => GoogleFonts.sourceSans3TextTheme(),
      _ => GoogleFonts.robotoTextTheme(),
    };
  }
}

class _NewsShell extends StatefulWidget {
  const _NewsShell({
    required this.articles,
    required this.selectedPreset,
    required this.minScale,
    required this.maxScale,
    required this.bookmarkedIds,
    required this.onPresetChanged,
    required this.onMinScaleChanged,
    required this.onMaxScaleChanged,
    required this.onToggleBookmark,
  });

  final List<NewsArticle> articles;
  final FontPairPreset selectedPreset;
  final double minScale;
  final double maxScale;
  final Set<String> bookmarkedIds;
  final ValueChanged<FontPairPreset> onPresetChanged;
  final ValueChanged<double> onMinScaleChanged;
  final ValueChanged<double> onMaxScaleChanged;
  final ValueChanged<String> onToggleBookmark;

  @override
  State<_NewsShell> createState() => _NewsShellState();
}

class _NewsShellState extends State<_NewsShell> {
  NewsTab _tab = NewsTab.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleForTab(_tab)),
        actions: [
          if (_tab == NewsTab.home)
            IconButton(
              tooltip: 'Today',
              icon: const Icon(Icons.wb_sunny_outlined),
              onPressed: () {},
            ),
          if (_tab == NewsTab.lab)
            IconButton(
              tooltip: 'Typography',
              icon: const Icon(Icons.tune),
              onPressed: () {},
            ),
        ],
      ),
      body: IndexedStack(
        index: _tab.index,
        children: [
          NewsFeedTab(
            articles: widget.articles,
            bookmarkedIds: widget.bookmarkedIds,
            onOpenArticle: (article) => _openArticle(article),
            onToggleBookmark: widget.onToggleBookmark,
          ),
          TopicsTab(
            articles: widget.articles,
            onOpenArticle: (article) => _openArticle(article),
            bookmarkedIds: widget.bookmarkedIds,
            onToggleBookmark: widget.onToggleBookmark,
          ),
          SavedTab(
            articles: widget.articles,
            bookmarkedIds: widget.bookmarkedIds,
            onOpenArticle: (article) => _openArticle(article),
            onToggleBookmark: widget.onToggleBookmark,
          ),
          TypographyLabTab(
            selectedPreset: widget.selectedPreset,
            minScale: widget.minScale,
            maxScale: widget.maxScale,
            onPresetChanged: widget.onPresetChanged,
            onMinScaleChanged: widget.onMinScaleChanged,
            onMaxScaleChanged: widget.onMaxScaleChanged,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab.index,
        onDestinationSelected: (value) {
          setState(() {
            _tab = NewsTab.values[value];
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Topics',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Lab',
          ),
        ],
      ),
    );
  }

  String _titleForTab(NewsTab tab) {
    return switch (tab) {
      NewsTab.home => 'Mingalaba News',
      NewsTab.topics => 'Topics',
      NewsTab.saved => 'Saved stories',
      NewsTab.lab => 'Typography lab',
    };
  }

  Future<void> _openArticle(NewsArticle article) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return NewsArticleDetailPage(
            article: article,
            isBookmarked: widget.bookmarkedIds.contains(article.id),
            onToggleBookmark: () => widget.onToggleBookmark(article.id),
            onOpenArticle: (relatedArticle) => _openArticle(relatedArticle),
            relatedArticles: widget.articles
                .where((candidate) => article.relatedIds.contains(candidate.id))
                .toList(growable: false),
          );
        },
      ),
    );
  }
}

class NewsFeedTab extends StatefulWidget {
  const NewsFeedTab({
    super.key,
    required this.articles,
    required this.bookmarkedIds,
    required this.onOpenArticle,
    required this.onToggleBookmark,
  });

  final List<NewsArticle> articles;
  final Set<String> bookmarkedIds;
  final ValueChanged<NewsArticle> onOpenArticle;
  final ValueChanged<String> onToggleBookmark;

  @override
  State<NewsFeedTab> createState() => _NewsFeedTabState();
}

class _NewsFeedTabState extends State<NewsFeedTab> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.articles
        .where((article) {
          final haystack = [
            article.section,
            article.title,
            article.deck,
            article.bodyParagraphs.join(' '),
          ].join(' ').toLowerCase();
          return haystack.contains(_query.toLowerCase());
        })
        .toList(growable: false);

    final featured = filtered.isNotEmpty
        ? filtered.first
        : widget.articles.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _TopBanner(
          featured: featured,
          bookmarked: widget.bookmarkedIds.contains(featured.id),
          onOpenArticle: widget.onOpenArticle,
          onToggleBookmark: widget.onToggleBookmark,
          searchController: _searchController,
          onSearchChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: 'Top stories',
          subtitle:
              'Mixed-language reporting, live updates, and daily reading.',
        ),
        const SizedBox(height: 12),
        for (final article in filtered.take(4)) ...[
          _StoryCard(
            article: article,
            bookmarked: widget.bookmarkedIds.contains(article.id),
            onTap: () => widget.onOpenArticle(article),
            onToggleBookmark: () => widget.onToggleBookmark(article.id),
          ),
          const SizedBox(height: 12),
        ],
        _SectionHeader(
          title: 'Latest updates',
          subtitle:
              'Realistic news-card layout with mixed Myanmar and Latin text.',
        ),
        const SizedBox(height: 12),
        for (final article in filtered.skip(1).take(3)) ...[
          _CompactStoryRow(
            article: article,
            bookmarked: widget.bookmarkedIds.contains(article.id),
            onTap: () => widget.onOpenArticle(article),
            onToggleBookmark: () => widget.onToggleBookmark(article.id),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class TopicsTab extends StatelessWidget {
  const TopicsTab({
    super.key,
    required this.articles,
    required this.bookmarkedIds,
    required this.onOpenArticle,
    required this.onToggleBookmark,
  });

  final List<NewsArticle> articles;
  final Set<String> bookmarkedIds;
  final ValueChanged<NewsArticle> onOpenArticle;
  final ValueChanged<String> onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    final sections = articles.map((article) => article.section).toSet().toList()
      ..sort();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _SectionHeader(
          title: 'Browse by topic',
          subtitle: 'Tap a story to open a dedicated article page.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final section in sections)
              _TopicChip(
                label: section,
                count: articles
                    .where((article) => article.section == section)
                    .length,
              ),
          ],
        ),
        const SizedBox(height: 20),
        for (final section in sections) ...[
          _SectionHeader(
            title: section,
            subtitle: 'Stories currently on the front page.',
          ),
          const SizedBox(height: 12),
          for (final article
              in articles
                  .where((article) => article.section == section)
                  .take(2)) ...[
            _StoryCard(
              article: article,
              bookmarked: bookmarkedIds.contains(article.id),
              onTap: () => onOpenArticle(article),
              onToggleBookmark: () => onToggleBookmark(article.id),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class SavedTab extends StatelessWidget {
  const SavedTab({
    super.key,
    required this.articles,
    required this.bookmarkedIds,
    required this.onOpenArticle,
    required this.onToggleBookmark,
  });

  final List<NewsArticle> articles;
  final Set<String> bookmarkedIds;
  final ValueChanged<NewsArticle> onOpenArticle;
  final ValueChanged<String> onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    final savedArticles = articles
        .where((article) => bookmarkedIds.contains(article.id))
        .toList(growable: false);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _SectionHeader(
          title: 'Saved stories',
          subtitle: 'A realistic bookmark shelf for later reading.',
        ),
        const SizedBox(height: 12),
        if (savedArticles.isEmpty)
          _EmptyState(
            title: 'No saved stories yet',
            subtitle:
                'Bookmark a story from the feed to keep it in this dedicated screen.',
          )
        else
          for (final article in savedArticles) ...[
            _StoryCard(
              article: article,
              bookmarked: true,
              onTap: () => onOpenArticle(article),
              onToggleBookmark: () => onToggleBookmark(article.id),
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class TypographyLabTab extends StatefulWidget {
  const TypographyLabTab({
    super.key,
    required this.selectedPreset,
    required this.minScale,
    required this.maxScale,
    required this.onPresetChanged,
    required this.onMinScaleChanged,
    required this.onMaxScaleChanged,
  });

  final FontPairPreset selectedPreset;
  final double minScale;
  final double maxScale;
  final ValueChanged<FontPairPreset> onPresetChanged;
  final ValueChanged<double> onMinScaleChanged;
  final ValueChanged<double> onMaxScaleChanged;

  @override
  State<TypographyLabTab> createState() => _TypographyLabTabState();
}

class _TypographyLabTabState extends State<TypographyLabTab> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(
      text: 'Yangon commute update and မြို့တော် notice draft.',
    );
    _noteController.addListener(_onNoteChanged);
  }

  @override
  void dispose() {
    _noteController.removeListener(_onNoteChanged);
    _noteController.dispose();
    super.dispose();
  }

  void _onNoteChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final config = MMTextConfig.of(context);
    final scale = config.scaleFor(weight: FontWeight.normal);
    final boldScale = config.scaleFor(weight: FontWeight.w700);
    final preview = sampleArticles.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _SectionHeader(
          title: 'MMTextConfig settings',
          subtitle:
              'Change the ambient text configuration and watch the news app update immediately.',
        ),
        const SizedBox(height: 12),
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Font pair', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              DropdownButtonFormField<FontPairPreset>(
                initialValue: widget.selectedPreset,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: FontPairPreset.values
                    .map(
                      (preset) => DropdownMenuItem(
                        value: preset,
                        child: Text(preset.label),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value != null) {
                    widget.onPresetChanged(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Min scale floor: ${widget.minScale.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: widget.minScale,
                min: 0.70,
                max: 1.00,
                divisions: 30,
                label: widget.minScale.toStringAsFixed(2),
                onChanged: widget.onMinScaleChanged,
              ),
              Text(
                'Max scale ceiling: ${widget.maxScale.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: widget.maxScale,
                min: 1.00,
                max: 1.20,
                divisions: 20,
                label: widget.maxScale.toStringAsFixed(2),
                onChanged: widget.onMaxScaleChanged,
              ),
              Text(
                'Computed scale for normal body text: ${scale.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Computed scale for bold text: ${boldScale.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionHeader(
          title: 'Mixed-script article preview',
          subtitle:
              'This compares stock Flutter text with MMText.rich using the same news copy.',
        ),
        const SizedBox(height: 12),
        _ComparisonCard(
          title: 'Stock Text',
          child: Text.rich(
            _newsArticleSpan(
              baseStyle: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontSize: 18, height: 1.35),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _ComparisonCard(
          title: 'MMText.rich',
          child: MMText.rich(
            _newsArticleSpan(
              baseStyle: const TextStyle(fontSize: 18, height: 1.35),
            ),
            fontSize: 18,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 16),
        _SectionHeader(
          title: 'Built-in field support',
          subtitle: 'MMTextField accepts the same common Flutter text fields.',
        ),
        const SizedBox(height: 12),
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MMTextField(
                controller: _noteController,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: const InputDecoration(
                  labelText: 'Reporter note',
                  hintText: 'Type mixed Myanmar + English',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              MMText(text: 'Live note: ${_noteController.text}', fontSize: 16),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionHeader(
          title: 'Article excerpt',
          subtitle: 'The package is meant to improve the actual reading flow.',
        ),
        const SizedBox(height: 12),
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MMText(
                text: preview.title,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 8),
              MMText(text: preview.deck, fontSize: 16, height: 1.45),
            ],
          ),
        ),
      ],
    );
  }
}

class NewsArticleDetailPage extends StatefulWidget {
  const NewsArticleDetailPage({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.onToggleBookmark,
    required this.onOpenArticle,
    required this.relatedArticles,
  });

  final NewsArticle article;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;
  final ValueChanged<NewsArticle> onOpenArticle;
  final List<NewsArticle> relatedArticles;

  @override
  State<NewsArticleDetailPage> createState() => _NewsArticleDetailPageState();
}

class _NewsArticleDetailPageState extends State<NewsArticleDetailPage> {
  late bool _bookmarked;

  @override
  void initState() {
    super.initState();
    _bookmarked = widget.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: widget.article.accent.withValues(alpha: 0.08),
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: _ArticleHero(article: widget.article),
            ),
            actions: [
              IconButton(
                tooltip: _bookmarked ? 'Remove bookmark' : 'Save story',
                icon: Icon(
                  _bookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: () {
                  setState(() {
                    _bookmarked = !_bookmarked;
                  });
                  widget.onToggleBookmark();
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ArticleMetaRow(article: widget.article),
                  const SizedBox(height: 18),
                  MMText(
                    text: widget.article.title,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1.08,
                  ),
                  const SizedBox(height: 12),
                  MMText(text: widget.article.deck, fontSize: 17, height: 1.5),
                  const SizedBox(height: 18),
                  _BodyLabel(
                    text: 'Today’s report mixes English and Myanmar inline.',
                  ),
                  const SizedBox(height: 10),
                  for (final paragraph in widget.article.bodyParagraphs) ...[
                    MMText(text: paragraph, fontSize: 18, height: 1.5),
                    const SizedBox(height: 14),
                  ],
                  _CalloutCard(
                    child: MMText.rich(
                      TextSpan(
                        style: const TextStyle(fontSize: 17, height: 1.5),
                        children: [
                          const TextSpan(
                            text: 'Officials said the trial will be ',
                          ),
                          TextSpan(
                            text: 'measured week by week',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const TextSpan(
                            text:
                                ', while မြို့နယ် teams collect rider feedback and adjust service windows.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader(
                    title: 'Related stories',
                    subtitle: 'More articles from the same newsroom feed.',
                  ),
                  const SizedBox(height: 12),
                  for (final related in widget.relatedArticles) ...[
                    _CompactStoryRow(
                      article: related,
                      bookmarked: false,
                      onTap: () => widget.onOpenArticle(related),
                      onToggleBookmark: () {},
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBanner extends StatelessWidget {
  const _TopBanner({
    required this.featured,
    required this.bookmarked,
    required this.onOpenArticle,
    required this.onToggleBookmark,
    required this.searchController,
    required this.onSearchChanged,
  });

  final NewsArticle featured;
  final bool bookmarked;
  final ValueChanged<NewsArticle> onOpenArticle;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onToggleBookmark;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [featured.accent.withValues(alpha: 0.18), Colors.white],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: featured.accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Badge(label: featured.section, color: featured.accent),
              const Spacer(),
              MMText(
                text: featured.publishedLabel,
                fontSize: 13,
                color: Colors.black54,
              ),
            ],
          ),
          const SizedBox(height: 14),
          MMText(
            text: featured.title,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.12,
          ),
          const SizedBox(height: 10),
          MMText(text: featured.deck, fontSize: 16, height: 1.45),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: MMTextField(
                  controller: searchController,
                  fontSize: 15,
                  decoration: const InputDecoration(
                    hintText: 'Search headlines',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: onSearchChanged,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => onOpenArticle(featured),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Read'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => onToggleBookmark(featured.id),
              icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border),
              label: Text(bookmarked ? 'Saved' : 'Save story'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.article,
    required this.bookmarked,
    required this.onTap,
    required this.onToggleBookmark,
  });

  final NewsArticle article;
  final bool bookmarked;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: article.accent.withValues(alpha: 0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Badge(label: article.section, color: article.accent),
                  const Spacer(),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: onToggleBookmark,
                    icon: Icon(
                      bookmarked ? Icons.bookmark : Icons.bookmark_border,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              MMText(
                text: article.title,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                height: 1.18,
              ),
              const SizedBox(height: 8),
              MMText(text: article.deck, fontSize: 15.5, height: 1.4),
              const SizedBox(height: 14),
              Row(
                children: [
                  MMText(
                    text: article.publishedLabel,
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                  const Spacer(),
                  TextButton(onPressed: onTap, child: const Text('Open story')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactStoryRow extends StatelessWidget {
  const _CompactStoryRow({
    required this.article,
    required this.bookmarked,
    required this.onTap,
    required this.onToggleBookmark,
  });

  final NewsArticle article;
  final bool bookmarked;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10,
                height: 64,
                decoration: BoxDecoration(
                  color: article.accent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MMText(
                      text: article.title,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    const SizedBox(height: 6),
                    MMText(
                      text: article.deck,
                      fontSize: 14.5,
                      height: 1.35,
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 8),
                    MMText(
                      text: article.publishedLabel,
                      fontSize: 12.5,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onToggleBookmark,
                icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleHero extends StatelessWidget {
  const _ArticleHero({required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            article.accent.withValues(alpha: 0.25),
            article.accent.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              _Badge(label: article.section, color: article.accent),
              const SizedBox(height: 10),
              MMText(
                text: article.title,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.08,
              ),
              const SizedBox(height: 8),
              MMText(text: article.deck, fontSize: 15.5, height: 1.4),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleMetaRow extends StatelessWidget {
  const _ArticleMetaRow({required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _MetaPill(icon: Icons.schedule, text: article.publishedLabel),
        _MetaPill(icon: Icons.timelapse, text: article.readTime),
        _MetaPill(icon: Icons.person_outline, text: article.byline),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      side: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: child,
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _CalloutCard extends StatelessWidget {
  const _CalloutCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(22),
      ),
      child: child,
    );
  }
}

class _BodyLabel extends StatelessWidget {
  const _BodyLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Colors.black87,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label · $count'),
      avatar: const Icon(Icons.tag, size: 16),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.section,
    required this.title,
    required this.deck,
    required this.publishedLabel,
    required this.readTime,
    required this.byline,
    required this.accent,
    required this.bodyParagraphs,
    required this.relatedIds,
  });

  final String id;
  final String section;
  final String title;
  final String deck;
  final String publishedLabel;
  final String readTime;
  final String byline;
  final Color accent;
  final List<String> bodyParagraphs;
  final List<String> relatedIds;
}

const sampleArticles = <NewsArticle>[
  NewsArticle(
    id: '1',
    section: 'City',
    title: 'Yangon transit update expands morning service across downtown',
    deck:
        'City officials (မြို့တော်စည်ပင်) မှ ဒီကနေ့မှာ ရန်ကုန်မြို့တွင်း ဘတ်စ်ကားပြေးဆွဲမှု အစီအစဉ်သစ်ကို စတင်စမ်းသပ်လိုက်ပြီဖြစ်ကြောင်း ကြေညာလိုက်ပါတယ်။ Commuters can expect more frequent buses on main corridors.',
    publishedLabel: '8:15 AM',
    readTime: '3 min read',
    byline: 'By The City Desk',
    accent: Color(0xFF2563EB),
    bodyParagraphs: [
      'Yangon, July 15 — မြို့တော်စည်ပင်အဖွဲ့မှ တာဝန်ရှိသူများက the new transit plan is designed to reduce delays for ရုံးသွားရုံးပြန်ဝန်ထမ်းများ (office workers), ကျောင်းသားကျောင်းသူများ (students), နှင့် မနက် ၉ နာရီမတိုင်မီ မြို့တွင်းသို့ ဖြတ်သန်းသွားလာကြသော ခရီးသည်များအတွက် ရည်ရွယ်သည်ဟု ပြောကြားခဲ့ပါသည်။',
      'The announcement also noted that မြို့နယ်အဆင့် တာဝန်ရှိသူများ (township teams) က ကားမှတ်တိုင်များတွင် ယာဉ်ကြောပိတ်ဆို့မှု (traffic) အခြေအနေကို စောင့်ကြည့်သွားမည်ဖြစ်ပြီး၊ English notices များကို မြန်မာဘာသာဖြင့် ရေးသားထားသော updates များဘေးတွင် ယှဉ်တွဲပြသထားမည်ဖြစ်ရာ ခရီးသည်များအနေဖြင့် ပြောင်းလဲမှုများကို အလွယ်တကူ သိရှိနိုင်မည်ဖြစ်သည်။',
      'အနော်ရထာလမ်းမကြီးတစ်လျှောက် (Anawrahta Road) နေထိုင်သူများကမူ ယခုပြောင်းလဲလိုက်သော new schedule သည် ယခင် ပြေးဆွဲနေသည့် လမ်းကြောင်း (route map) အတိုင်းပင်ဖြစ်သော်လည်း ရုံးဆင်းရုံးတက်အချိန် (rush-hour window) တွင် ဘတ်စ်ကားများ ပိုမိုမကြာခဏ လာရောက်မည်ဖြစ်သောကြောင့် ပိုမိုအဆင်ပြေမည်ဟု ဆိုကြသည်။',
    ],
    relatedIds: ['2', '4'],
  ),
  NewsArticle(
    id: '2',
    section: 'Culture',
    title: 'Weekend market fair in Mandalay blends music, food, and language',
    deck:
        'မန္တလေးမြို့ရဲ့ စနေ၊ တနင်္ဂနွေ ဈေးပွဲတော် (weekend market fair) ဟာ ဒေသခံပြည်သူတွေနဲ့ နိုင်ငံခြားသား ဧည့်သည်တွေအတွက် a vibrant mix of live music, traditional food stalls, နှင့် bilingual signs တွေကို စီစဉ်ထားပါတယ်။',
    publishedLabel: '9:05 AM',
    readTime: '4 min read',
    byline: 'By Arts & Culture',
    accent: Color(0xFFB45309),
    bodyParagraphs: [
      'Mandalay, July 15 — ဧရာဝတီမြစ်ကမ်းဘေး (riverside) တွင် ကျင်းပမည့် ဈေးပွဲတော်ကို လက်ဖက်သုပ် (tea-leaf salad)၊ လက်မှုပညာ အသုံးအဆောင်များ (handmade notebooks) နှင့် အသေးစား လက်မှုပစ္စည်း (small crafts) ဆိုင်တန်းများစွာဖြင့် ဖွင့်လှစ်သွားမည်ဖြစ်ပြီး၊ ပစ္စည်းများအားလုံးကို အင်္ဂလိပ်နှင့် မြန်မာ နှစ်ဘာသာဖြင့် အမည်တပ်ထားမည်ဖြစ်သည်။',
      'Organizers said the stage program will mix live interviews with short cultural segments. အစီအစဉ်တင်ဆက်သူ (the host) က နိုင်ငံခြားသား ကမ္ဘာလှည့်ခရီးသည်များ (tourists) နှင့် ဒေသခံ မိသားစုများအားလုံး အလွယ်တကူ နားလည်နိုင်စေရန် နှစ်ဘာသာစလုံးကို လှည့်လည်အသုံးပြုသွားမည်ဟု ဆိုသည်။',
      'မြောက်ဘက်ဂိတ် (north gate) အနီးရှိ ဈေးသည်တစ်ဦးက the fair feels easier to navigate when the signboards include မြို့နယ်အမည်များ၊ လမ်းအမည်များ (street names)၊ နှင့် English route markers များကို တစ်နေရာတည်းတွင် တွဲဖက်ပြသထားသောကြောင့် လမ်းရှာရ ပိုမိုလွယ်ကူလာသည်ဟု မှတ်ချက်ပြုခဲ့သည်။',
    ],
    relatedIds: ['1', '5'],
  ),
  NewsArticle(
    id: '3',
    section: 'Weather',
    title: 'Heavy rain watch remains in place for the evening commute',
    deck:
        'မိုးလေဝသ ပညာရှင်များ (Meteorologists) က ညနေ ၅ နာရီနောက်ပိုင်းတွင် မိုးသက်လေပြင်း (brief storms) များ ကျရောက်နိုင်ကြောင်း ခန့်မှန်းထားပြီး၊ မြစ်ကမ်းနံဘေး ရပ်ကွက်များအတွက် မြန်မာဘာသာဖြင့် သတိပေးချက် (advisory) ကိုလည်း ထုတ်ပြန်ထားပါတယ်။',
    publishedLabel: '10:20 AM',
    readTime: '2 min read',
    byline: 'By Weather Team',
    accent: Color(0xFF0EA5E9),
    bodyParagraphs: [
      'Nay Pyi Taw, July 15 — မိုးလေဝသခန့်မှန်းချက်များအရ နေ့လည်ပိုင်းမှစတင်၍ တိမ်ဖုံးလွှမ်းမှု (cloud cover) ပိုမိုများပြားလာနိုင်ပြီး၊ ညနေခင်း ရုံးဆင်းချိန် (evening commute) အတွင်း အချိန်တိုအတွင်း မိုးသည်းထန်စွာ ရွာသွန်းနိုင်ခြေ (short bursts of rain) ရှိကြောင်း သိရသည်။',
      'သတိပေးချက် (The advisory) တွင် ဒေသခံပြည်သူများအနေဖြင့် ထီး (umbrellas) ဆောင်ထားကြရန်၊ လမ်းပန်းဆက်သွယ်ရေး အခြေအနေ (road conditions) ကို ကြိုတင်စစ်ဆေးရန်နှင့်၊ ရေနုတ်မြောင်းများ (drainage system) အလွယ်တကူ ပြည့်လျှံနိုင်သော မြေနိမ့်ပိုင်းလမ်းများ (low-lying streets) တွင် ရေကြီးရေလျှံမှုများ (localized flooding) ကို သတိပြုကြရန် တိုက်တွန်းထားပါသည်။',
      'In local bulletins, မိုးလေဝသဌာန (the weather office) မှ တိုတောင်းသော မြန်မာစာသား (a short မြန်မာ note) ကိုပါ ထည့်သွင်းထားသောကြောင့် အင်္ဂလိပ်နှင့် မြန်မာစာဖတ်သူများ (both English and Myanmar readers) အနေဖြင့် မျက်နှာပြင်ပြောင်းစရာမလိုဘဲ အချိန်ကိုက်သတင်းကို အလွယ်တကူ နားလည်နိုင်မည်ဖြစ်သည်။',
    ],
    relatedIds: ['1', '4'],
  ),
  NewsArticle(
    id: '4',
    section: 'Business',
    title: 'Startup adds fintech support for shop owners in downtown Yangon',
    deck:
        'The new service lets ဈေးဆိုင်ပိုင်ရှင်များ (merchants) track payments, ဖတ်ရလွယ်ကူသော dashboards များကို အသုံးပြုနိုင်ပြီး၊ account alerts များကို အင်္ဂလိပ်နှင့် မြန်မာ နှစ်ဘာသာဖြင့် ကြည့်ရှုနိုင်မည်ဖြစ်ပါတယ်။',
    publishedLabel: '11:40 AM',
    readTime: '5 min read',
    byline: 'By Business Desk',
    accent: Color(0xFF7C3AED),
    bodyParagraphs: [
      'Yangon, July 15 — ကုမ္ပဏီ၏ ပြောကြားချက်အရ ၎င်းတို့၏ mobile dashboard သည် ဈေးဆိုင်ပိုင်ရှင်များအား ရောင်းရငွေစုစုပေါင်း (sales totals)၊ ဝန်ဆောင်ခများ (fees)၊ နှင့် လက်ကျန်ငွေပြောင်းလဲမှုများ (balance changes) ကို app များစွာ ဖွင့်စရာမလိုဘဲ တစ်နေရာတည်းတွင် အလွယ်တကူ ကြည့်ရှုနိုင်ရန် ကူညီပေးမည်ဖြစ်သည်။',
      'A product manager ကပြောကြားရာတွင် the team tested copy that alternates between English guidance and Myanmar explanations ဘာကြောင့်လဲဆိုတော့ ကုန်သည်များစွာ (many merchants) သည် ဖတ်ရှုမှုပုံစံ နှစ်မျိုးစလုံးကို ကိုင်တွယ်နိုင်သော မျက်နှာပြင်တစ်ခုတည်း (one screen) ကို ပိုမိုသဘောကျသောကြောင့်ဖြစ်သည်ဟု ဆိုသည်။',
      'The startup အနေဖြင့် စနေ၊ တနင်္ဂနွေ အလုပ်ရုံဆွေးနွေးပွဲ (weekend workshop) တစ်ခုကိုလည်း စီစဉ်ထားပြီး၊ ကုန်သည်များ (traders) သည် ၎င်းတို့၏ ဖုန်းများကို ယူဆောင်လာကာ app ကို စမ်းသပ်အသုံးပြုနိုင်ပြီး၊ မိမိတို့အတွက် အဆင်ပြေဆုံးဖြစ်မည့် မည်သည့်ဘာသာစကားဖြင့်မဆို (in whichever language feels most natural) မေးခွန်းများ မေးမြန်းနိုင်မည်ဖြစ်သည်။',
    ],
    relatedIds: ['2', '5'],
  ),
  NewsArticle(
    id: '5',
    section: 'Education',
    title:
        'Reading drive sends new books to school libraries across the region',
    deck:
        'ဆရာ၊ ဆရာမများ (Teachers) အနေဖြင့် ကျောင်းသားများ စာအုပ်ရှာဖွေရာတွင် ပိုမိုလွယ်ကူစေရန် (easier browsing) အင်္ဂလိပ် ခေါင်းစဉ်များ (English titles) နှင့် မြန်မာလို အညွှန်းစာများ (မြန်မာ descriptions) ယှဉ်တွဲပြသထားသော library signs များကို ပိုမိုအသုံးပြုလိုကြပါတယ်။',
    publishedLabel: '1:30 PM',
    readTime: '3 min read',
    byline: 'By Education Desk',
    accent: Color(0xFF059669),
    bodyParagraphs: [
      'Mandalay, July 15 — ပညာရေးလုပ်အားပေးများ (education volunteers) သည် နှစ်ဘာသာသုံး စာအုပ်စာတမ်းများ (bilingual materials) ပိုမိုလိုအပ်နေသော စာသင်ကျောင်းများသို့ စာအုပ်သစ်များ (new books)၊ ဗလာစာအုပ်များ (notebooks)၊ နှင့် စာဖတ်ရန် လှုံ့ဆော်သော ပိုစတာများ (reading posters) ပါဝင်သော သေတ္တာများကို သွားရောက်ပို့ဆောင်ပေးခဲ့ကြသည်။',
      'ဆရာမတစ်ဦး၏ ပြောကြားချက်အရ ကလေးများ (the children) သည် တိုတောင်းသော အင်္ဂလိပ် ခေါင်းစဉ်ငယ်များ (short English headings) ကို အရင်ဖတ်ပြီး အောက်တွင်ရေးသားထားသော မြန်မာရှင်းလင်းချက် (Myanmar explanation) ကို ဆက်လက်ဖတ်ရှုခြင်းကို သဘောကျကြပြီး၊ အထူးသဖြင့် ဘာသာစကား နှစ်ခုစလုံးကို အနီးကပ်ယှဉ်တွဲ (keeps both languages close together) ထားသောအခါ ပို၍စိတ်ဝင်စားကြသည်ဟု ဆိုသည်။',
      'ယခုအစီအစဉ် (The program) သည် ဤလတစ်လလုံး ဆက်လက်လုပ်ဆောင်သွားမည်ဖြစ်ပြီး၊ လုပ်အားပေးများက ဤကဲ့သို့ ဘာသာစကား ရောနှောထားသော အညွှန်းစာများ (mixed-language labels) သည် ကျောင်းသားများ မှန်ကန်သော စာအုပ်စင် (right shelf) ကို ရှာဖွေရာတွင် မည်မျှအထိ အထောက်အကူပြုကြောင်း အကြံပြုချက်များ (feedback) ကို ကောက်ယူသွားမည်ဖြစ်ကြောင်း ပြောကြားခဲ့သည်။',
    ],
    relatedIds: ['2', '4'],
  ),
];

InlineSpan _newsArticleSpan({required TextStyle baseStyle}) {
  return TextSpan(
    style: baseStyle,
    children: const [
      TextSpan(text: 'Yangon, July 15 — '),
      TextSpan(text: 'မြို့တော် စည်ပင်သာယာရေးအဖွဲ့က '),
      TextSpan(
        text: 'said the new transit update will improve service for commuters ',
      ),
      TextSpan(text: 'ခရီးသည်များအတွက် '),
      TextSpan(text: 'traveling across downtown, while '),
      TextSpan(text: 'မြန်မာ notices'),
      TextSpan(text: ' will continue to appear alongside English updates.'),
    ],
  );
}
