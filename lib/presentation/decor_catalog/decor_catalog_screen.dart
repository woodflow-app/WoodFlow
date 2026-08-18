// Decor Catalogue screen (v10 migration) — EGGER + Kronospan decors
// with colour swatches, a product-type filter (Board/Worktop/Edging),
// and a link to the manufacturer's official decor photo.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/decor_catalog_entry.dart';
import '../../domain/repositories/decor_catalog_repository.dart';
import '../../l10n/app_localizations.dart';

// --- Kolory marki WoodFlow (patrz assumption #4 powyżej) -------------------
class _WoodFlowColors {
  static const forest = Color(0xFF1F4D3D);
  static const amber = Color(0xFFC8853D);
  static const cream = Color(0xFFF7F4EE);
  static const ink = Color(0xFF20221E);
  static const muted = Color(0xFF5B5A54);
  static const faint = Color(0xFF8A887E);
  static const hairline = Color(0xFFEAE6DC);
  static const chipBg = Color(0xFFEAE6DC);
}

/// Typ produktu — musi odpowiadać wartościom kolumny `product_type`
/// w tabeli `decors` (migracja v10): 'Board' | 'Worktop' | 'Edging'.
enum DecorProductType { all, board, worktop, edging }

extension on DecorProductType {
  String? get dbValue => switch (this) {
        DecorProductType.all => null,
        DecorProductType.board => 'Board',
        DecorProductType.worktop => 'Worktop',
        DecorProductType.edging => 'Edging',
      };

  String label(AppLocalizations l10n) => switch (this) {
        DecorProductType.all => l10n.decorFilterAll,
        DecorProductType.board => l10n.decorFilterBoard,
        DecorProductType.worktop => l10n.decorFilterWorktop,
        DecorProductType.edging => l10n.decorFilterEdging,
      };
}

class DecorCatalogScreen extends StatefulWidget {
  const DecorCatalogScreen({super.key});

  @override
  State<DecorCatalogScreen> createState() => _DecorCatalogScreenState();
}

class _DecorCatalogScreenState extends State<DecorCatalogScreen> {
  final DecorCatalogRepository _decors = sl<DecorCatalogRepository>();
  final _searchController = TextEditingController();
  DecorProductType _filter = DecorProductType.all;

  bool _loading = true;
  String? _error;
  List<DecorCatalogEntry> _allDecors = const [];

  @override
  void initState() {
    super.initState();
    _loadDecors();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDecors() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _decors.getAll();
    if (!mounted) return;
    if (result.isSuccess) {
      setState(() {
        _allDecors = result.data;
        _loading = false;
      });
    } else {
      setState(() {
        _error = result.failure.message;
        _loading = false;
      });
    }
  }

  List<DecorCatalogEntry> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    return _allDecors.where((d) {
      final matchesQuery = query.isEmpty ||
          d.code.toLowerCase().contains(query) ||
          d.name.toLowerCase().contains(query);
      final matchesFilter =
          _filter == DecorProductType.all || d.productType == _filter.dbValue;
      return matchesQuery && matchesFilter;
    }).toList();
  }

  void _openDetail(DecorCatalogEntry decor) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _DecorDetailSheet(decor: decor),
    );
  }

  Future<void> _openImage(DecorCatalogEntry decor) async {
    final l10n = AppLocalizations.of(context)!;
    final urlString = decor.imageUrl;
    if (urlString == null || urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.decorNoImageLinkSnackbar)),
      );
      return;
    }
    final uri = Uri.tryParse(urlString);
    if (uri == null || !await canLaunchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.decorFailedToOpenLinkSnackbar)),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _WoodFlowColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              searchController: _searchController,
              resultCount: _filtered.length,
              totalCount: _allDecors.length,
            ),
            _FilterChips(
              selected: _filter,
              onSelected: (f) => setState(() => _filter = f),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: _WoodFlowColors.forest),
      );
    }
    if (_error != null) {
      return _ErrorState(message: _error!, onRetry: _loadDecors);
    }
    final items = _filtered;
    if (items.isEmpty) {
      return _EmptyState(query: _searchController.text.trim());
    }
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: _WoodFlowColors.hairline),
      itemBuilder: (context, index) {
        final decor = items[index];
        return _DecorRow(
          decor: decor,
          onTap: () => _openDetail(decor),
          onImageTap: () => _openImage(decor),
        );
      },
    );
  }
}

// --- Header -----------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.searchController,
    required this.resultCount,
    required this.totalCount,
  });

  final TextEditingController searchController;
  final int resultCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: _WoodFlowColors.forest,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                color: const Color(0xFFB9CFC3),
                padding: EdgeInsets.zero,
              ),
              Text(
                l10n.decorCatalogBreadcrumb,
                style: const TextStyle(color: Color(0xFFB9CFC3), fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.decorCatalogTitle,
            style: const TextStyle(
              color: _WoodFlowColors.cream,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.search, size: 18, color: Color(0xFFB9CFC3)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                      color: _WoodFlowColors.cream,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.decorCatalogSearchHint,
                      hintStyle: const TextStyle(color: Color(0xFFB9CFC3)),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Filter chips -------------------------------------------------------

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelected});

  final DecorProductType selected;
  final ValueChanged<DecorProductType> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: DecorProductType.values.map((type) {
          final active = type == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(type.label(l10n)),
              selected: active,
              onSelected: (_) => onSelected(type),
              selectedColor: _WoodFlowColors.forest,
              backgroundColor: _WoodFlowColors.chipBg,
              labelStyle: TextStyle(
                color: active ? _WoodFlowColors.cream : _WoodFlowColors.muted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide.none,
              shape: const StadiumBorder(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// --- List row -------------------------------------------------------------

class _DecorRow extends StatelessWidget {
  const _DecorRow({
    required this.decor,
    required this.onTap,
    required this.onImageTap,
  });

  final DecorCatalogEntry decor;
  final VoidCallback onTap;
  final VoidCallback onImageTap;

  Color get _swatchColor => _parseHex(decor.swatchColor) ?? _WoodFlowColors.chipBg;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _swatchColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          decor.code,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _WoodFlowColors.ink,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (decor.texture != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            decor.texture!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      decor.name,
                      style: const TextStyle(
                        fontSize: 13,
                        color: _WoodFlowColors.muted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _ManufacturerBadge(manufacturer: decor.manufacturer),
                  const SizedBox(height: 4),
                  _TypeChip(type: decor.productType),
                ],
              ),
              const SizedBox(width: 4),
              _ImageButton(onTap: onImageTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageButton extends StatelessWidget {
  const _ImageButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _WoodFlowColors.chipBg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 32,
          height: 32,
          child: Icon(Icons.image_outlined, size: 16, color: _WoodFlowColors.muted),
        ),
      ),
    );
  }
}

class _ManufacturerBadge extends StatelessWidget {
  const _ManufacturerBadge({required this.manufacturer});

  final String manufacturer;

  @override
  Widget build(BuildContext context) {
    final isEgger = manufacturer.toUpperCase() == 'EGGER';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isEgger ? const Color(0xFF1F2A22) : const Color(0xFF2E3A6E),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        manufacturer.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: _WoodFlowColors.cream,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final String type; // 'Board' | 'Worktop' | 'Edging'

  ({Color bg, Color fg}) get _style => switch (type) {
        'Board' => (bg: const Color(0xFFEAF2ED), fg: _WoodFlowColors.forest),
        'Worktop' => (bg: const Color(0xFFFBF1E4), fg: _WoodFlowColors.amber),
        'Edging' => (bg: const Color(0xFFF0F6E7), fg: const Color(0xFF5C7A2F)),
        _ => (bg: _WoodFlowColors.chipBg, fg: _WoodFlowColors.muted),
      };

  String _label(AppLocalizations l10n) => switch (type) {
        'Board' => l10n.decorTypeBoard,
        'Worktop' => l10n.decorTypeWorktop,
        'Edging' => l10n.decorTypeEdging,
        _ => type,
      };

  @override
  Widget build(BuildContext context) {
    final s = _style;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: s.bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        _label(l10n),
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: s.fg),
      ),
    );
  }
}

// --- Detail bottom sheet ---------------------------------------------------

class _DecorDetailSheet extends StatelessWidget {
  const _DecorDetailSheet({required this.decor});

  final DecorCatalogEntry decor;

  Color get _swatchColor => _parseHex(decor.swatchColor) ?? _WoodFlowColors.chipBg;

  Future<void> _openImage(BuildContext context) async {
    final urlString = decor.imageUrl;
    if (urlString == null || urlString.isEmpty) return;
    final uri = Uri.tryParse(urlString);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEgger = decor.manufacturer.toUpperCase() == 'EGGER';
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: _WoodFlowColors.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _swatchColor,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.decorApproxColorLabel,
                  style: const TextStyle(fontSize: 10, color: _WoodFlowColors.ink),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _ManufacturerBadge(manufacturer: decor.manufacturer),
                const SizedBox(width: 6),
                _TypeChip(type: decor.productType),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              decor.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _WoodFlowColors.ink,
              ),
            ),
            Text(
              decor.texture != null
                  ? '${decor.code} · ${decor.texture}'
                  : decor.code,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'monospace',
                color: _WoodFlowColors.faint,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openImage(context),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(l10n.decorSeeRealPhoto),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _WoodFlowColors.forest,
                  foregroundColor: _WoodFlowColors.cream,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                l10n.decorImageSourceNote(isEgger ? "egger.com" : "kronospan.com"),
                style: const TextStyle(fontSize: 11, color: _WoodFlowColors.faint),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Empty / error states --------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final message = query.isEmpty
        ? l10n.decorEmptyNoData
        : l10n.decorEmptyNoResults(query);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: _WoodFlowColors.faint),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: _WoodFlowColors.muted),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: _WoodFlowColors.forest,
                foregroundColor: _WoodFlowColors.cream,
              ),
              child: Text(AppLocalizations.of(context)!.decorRetry),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helpers ----------------------------------------------------------

Color? _parseHex(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  var value = hex.replaceAll('#', '');
  if (value.length == 6) value = 'FF$value';
  final intValue = int.tryParse(value, radix: 16);
  return intValue != null ? Color(intValue) : null;
}
