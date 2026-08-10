import 'package:flutter/material.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/ai_query_answer.dart';
import '../../domain/entities/dashboard_snapshot.dart' show StaleItemType;
import '../../domain/services/ai_query_engine.dart';
import '../../l10n/app_localizations.dart';
import '../board/board_detail_screen.dart';
import '../offcut/offcut_detail_screen.dart';

class _HistoryEntry {
  final String query;
  final AiQueryAnswer answer;

  const _HistoryEntry({required this.query, required this.answer});
}

/// Krok 14 — deterministic AI query screen. Plain `get_it` +
/// `StatefulWidget`, same as every other screen in this app (no
/// Riverpod anywhere in this codebase). Session-only history list —
/// nothing here is persisted; a fresh app launch starts with an empty
/// conversation.
class AiQueryScreen extends StatefulWidget {
  const AiQueryScreen({super.key});

  @override
  State<AiQueryScreen> createState() => _AiQueryScreenState();
}

class _AiQueryScreenState extends State<AiQueryScreen> {
  final AiQueryEngine _engine = sl<AiQueryEngine>();
  final TextEditingController _controller = TextEditingController();
  final List<_HistoryEntry> _history = [];
  bool _isAsking = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isAsking) return;

    final languageCode = Localizations.localeOf(context).languageCode;
    setState(() {
      _isAsking = true;
      _error = null;
    });

    final result = await _engine.ask(text, languageCode);
    if (!mounted) return;

    result.when(
      success: (answer) {
        setState(() {
          _history.add(_HistoryEntry(query: text, answer: answer));
          _controller.clear();
          _isAsking = false;
        });
      },
      failure: (f) {
        setState(() {
          _error = f.message;
          _isAsking = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aiQueryTitle)),
      body: Column(
        children: [
          Expanded(
            child: _history.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(l10n.aiQueryInputHint, textAlign: TextAlign.center),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final entry = _history[_history.length - 1 - index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.query, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              _buildAnswer(entry.answer, l10n),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(l10n.errorPrefix(_error!), style: const TextStyle(color: Colors.red)),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: l10n.aiQueryInputHint,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _submit(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: _isAsking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    tooltip: l10n.aiQuerySendTooltip,
                    onPressed: _isAsking ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswer(AiQueryAnswer answer, AppLocalizations l10n) {
    return switch (answer) {
      StockQuantityAnswer a => Text(
          l10n.aiQueryStockAnswer(a.decor.code, a.decor.name, a.quantity),
        ),
      LocationAnswer a => _buildLocationAnswer(a, l10n),
      DimensionsAnswer a => _buildDimensionsAnswer(a, l10n),
      StaleMaterialsAnswer a => _buildStaleMaterialsAnswer(a, l10n),
      OffcutMatchAnswer a => _buildOffcutMatchAnswer(a, l10n),
      UnrecognizedQueryAnswer a => Text(l10n.aiQueryUnrecognized(a.rawText)),
    };
  }

  Widget _buildLocationAnswer(LocationAnswer answer, AppLocalizations l10n) {
    if (answer.locations.isEmpty) {
      return Text(l10n.aiQueryLocationEmpty);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aiQueryLocationHeader(answer.decor.code, answer.decor.name),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        for (final hit in answer.locations)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.crop_square),
            title: Text(hit.location.breadcrumb),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BoardDetailScreen(boardId: hit.boardId),
            )),
          ),
      ],
    );
  }

  Widget _buildDimensionsAnswer(DimensionsAnswer answer, AppLocalizations l10n) {
    if (answer.hits.isEmpty) {
      return Text(l10n.aiQueryDimensionsEmpty);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aiQueryDimensionsHeader(answer.decor.code, answer.decor.name),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        for (final hit in answer.hits)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(hit.type == StaleItemType.board ? Icons.crop_square : Icons.content_cut),
            title: Text(_dimensionsText(hit.lengthMm, hit.widthMm, hit.thicknessMm)),
            subtitle: Text(
              hit.type == StaleItemType.board ? l10n.aiQueryBoardTypeLabel : l10n.aiQueryOffcutTypeLabel,
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => hit.type == StaleItemType.board
                  ? BoardDetailScreen(boardId: hit.entityId)
                  : OffcutDetailScreen(offcutId: hit.entityId),
            )),
          ),
      ],
    );
  }

  Widget _buildStaleMaterialsAnswer(StaleMaterialsAnswer answer, AppLocalizations l10n) {
    if (answer.items.isEmpty) {
      return Text(l10n.aiQueryStaleEmpty);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.aiQueryStaleHeader, style: const TextStyle(fontWeight: FontWeight.w600)),
        for (final item in answer.items)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(item.type == StaleItemType.board ? Icons.crop_square : Icons.content_cut),
            title: Text(item.decorLabel),
            subtitle: Text(item.locationBreadcrumb ?? l10n.locationUnknown),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => item.type == StaleItemType.board
                  ? BoardDetailScreen(boardId: item.entityId)
                  : OffcutDetailScreen(offcutId: item.entityId),
            )),
          ),
      ],
    );
  }

  Widget _buildOffcutMatchAnswer(OffcutMatchAnswer answer, AppLocalizations l10n) {
    if (answer.candidates.isEmpty) {
      return Text(l10n.aiQueryOffcutMatchEmpty);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aiQueryOffcutMatchHeader(answer.decor.code, answer.decor.name),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        for (final candidate in answer.candidates)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.content_cut),
            title: Text(_dimensionsText(
              candidate.offcut.length,
              candidate.offcut.width,
              candidate.offcut.thickness,
            )),
            subtitle: Text(
              l10n.aiQueryWasteAreaLabel(candidate.wasteAreaMm2.toStringAsFixed(0)),
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => OffcutDetailScreen(offcutId: candidate.offcut.id),
            )),
          ),
      ],
    );
  }

  String _dimensionsText(double lengthMm, double widthMm, double thicknessMm) {
    String fmt(double v) => v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1);
    return '${fmt(lengthMm)} × ${fmt(widthMm)} × ${fmt(thicknessMm)} mm';
  }
}
