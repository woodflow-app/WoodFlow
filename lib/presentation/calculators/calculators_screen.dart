import 'package:flutter/material.dart';

import '../../domain/entities/board_measurement.dart';
import '../../domain/entities/edge_banding_length.dart';
import '../../domain/services/board_measurement_calculator.dart';
import '../../domain/services/edge_banding_calculator.dart';
import '../../l10n/app_localizations.dart';
import '../design_system/design_system.dart';

/// Krok 11 — two pure calculators behind one tabbed screen. Reached
/// two ways, same pattern as `BoardDetailScreen`: standalone from
/// `WarehouseListScreen`'s AppBar (no initial values, empty fields),
/// or as a shortcut from `BoardDetailScreen`/`OffcutDetailScreen`
/// (pre-filled with that item's own dimensions, computed immediately).
///
/// No get_it/interface here — unlike `ExportGenerator`/`LabelGenerator`,
/// there's exactly one reasonable implementation of each calculation,
/// nothing to swap at runtime. Same reasoning as `DashboardService`.
class CalculatorsScreen extends StatefulWidget {
  final double? initialLengthMm;
  final double? initialWidthMm;
  final double? initialThicknessMm;

  const CalculatorsScreen({
    super.key,
    this.initialLengthMm,
    this.initialWidthMm,
    this.initialThicknessMm,
  });

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: WFTopBar(
        title: l10n.calculatorsTitle,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.calculatorAreaVolumeTab),
            Tab(text: l10n.calculatorEdgeBandingTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _AreaVolumeCalculatorTab(
            initialLengthMm: widget.initialLengthMm,
            initialWidthMm: widget.initialWidthMm,
            initialThicknessMm: widget.initialThicknessMm,
          ),
          const _EdgeBandingCalculatorTab(),
        ],
      ),
    );
  }
}

class _AreaVolumeCalculatorTab extends StatefulWidget {
  final double? initialLengthMm;
  final double? initialWidthMm;
  final double? initialThicknessMm;

  const _AreaVolumeCalculatorTab({
    this.initialLengthMm,
    this.initialWidthMm,
    this.initialThicknessMm,
  });

  @override
  State<_AreaVolumeCalculatorTab> createState() => _AreaVolumeCalculatorTabState();
}

class _AreaVolumeCalculatorTabState extends State<_AreaVolumeCalculatorTab> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _lengthController;
  late final TextEditingController _widthController;
  late final TextEditingController _thicknessController;
  BoardMeasurement? _result;

  @override
  void initState() {
    super.initState();
    _lengthController = TextEditingController(text: _fmt(widget.initialLengthMm));
    _widthController = TextEditingController(text: _fmt(widget.initialWidthMm));
    _thicknessController = TextEditingController(text: _fmt(widget.initialThicknessMm));

    final length = widget.initialLengthMm;
    final width = widget.initialWidthMm;
    final thickness = widget.initialThicknessMm;
    if (length != null && width != null && thickness != null) {
      _result = BoardMeasurementCalculator.calculate(
        lengthMm: length,
        widthMm: width,
        thicknessMm: thickness,
      );
    }
  }

  String _fmt(double? value) => value == null ? '' : value.toInt().toString();

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _thicknessController.dispose();
    super.dispose();
  }

  String? _validatePositive(String? value, AppLocalizations l10n) {
    final parsed = value == null ? null : double.tryParse(value);
    if (parsed == null || parsed <= 0) return l10n.fillDimensionsCorrectly;
    return null;
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _result = BoardMeasurementCalculator.calculate(
        lengthMm: double.parse(_lengthController.text),
        widthMm: double.parse(_widthController.text),
        thicknessMm: double.parse(_thicknessController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(WFSpacing.md),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WFTextField(
              controller: _lengthController,
              labelText: l10n.lengthMm,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _validatePositive(v, l10n),
            ),
            const SizedBox(height: WFSpacing.sm),
            WFTextField(
              controller: _widthController,
              labelText: l10n.widthMm,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _validatePositive(v, l10n),
            ),
            const SizedBox(height: WFSpacing.sm),
            WFTextField(
              controller: _thicknessController,
              labelText: l10n.thicknessMm,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _validatePositive(v, l10n),
            ),
            const SizedBox(height: WFSpacing.md),
            WFButton(label: l10n.calculateButton, onPressed: _calculate),
            if (_result != null) ...[
              const Divider(height: WFSpacing.xxl),
              WFListTile(
                leading: const Icon(Icons.square_foot_outlined),
                title: l10n.areaM2Label,
                trailing: Text(_result!.areaM2.toStringAsFixed(3)),
              ),
              WFListTile(
                leading: const Icon(Icons.view_in_ar_outlined),
                title: l10n.volumeM3Label,
                trailing: Text(_result!.volumeM3.toStringAsFixed(4)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EdgeBandingCalculatorTab extends StatefulWidget {
  const _EdgeBandingCalculatorTab();

  @override
  State<_EdgeBandingCalculatorTab> createState() => _EdgeBandingCalculatorTabState();
}

class _EdgeBandingCalculatorTabState extends State<_EdgeBandingCalculatorTab> {
  final _formKey = GlobalKey<FormState>();
  final _outerController = TextEditingController();
  final _coreController = TextEditingController();
  final _thicknessController = TextEditingController();
  EdgeBandingLength? _result;

  @override
  void dispose() {
    _outerController.dispose();
    _coreController.dispose();
    _thicknessController.dispose();
    super.dispose();
  }

  String? _validatePositive(String? value, AppLocalizations l10n) {
    final parsed = value == null ? null : double.tryParse(value);
    if (parsed == null || parsed <= 0) return l10n.fillDimensionsCorrectly;
    return null;
  }

  void _calculate(AppLocalizations l10n) {
    if (!_formKey.currentState!.validate()) return;

    final outer = double.parse(_outerController.text);
    final core = double.parse(_coreController.text);
    if (outer <= core) {
      showWFSnackbar(context, l10n.fillDimensionsCorrectly);
      return;
    }

    setState(() {
      _result = EdgeBandingCalculator.calculate(
        outerDiameterMm: outer,
        coreDiameterMm: core,
        tapeThicknessMm: double.parse(_thicknessController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(WFSpacing.md),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WFTextField(
              controller: _outerController,
              labelText: l10n.outerDiameterMmLabel,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _validatePositive(v, l10n),
            ),
            const SizedBox(height: WFSpacing.sm),
            WFTextField(
              controller: _coreController,
              labelText: l10n.coreDiameterMmLabel,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _validatePositive(v, l10n),
            ),
            const SizedBox(height: WFSpacing.sm),
            WFTextField(
              controller: _thicknessController,
              labelText: l10n.tapeThicknessMmLabel,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _validatePositive(v, l10n),
            ),
            const SizedBox(height: WFSpacing.md),
            WFButton(label: l10n.calculateButton, onPressed: () => _calculate(l10n)),
            if (_result != null) ...[
              const Divider(height: WFSpacing.xxl),
              WFListTile(
                leading: const Icon(Icons.straighten_outlined),
                title: l10n.edgeBandingLengthResultLabel,
                trailing: Text(_result!.meters.toStringAsFixed(2)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
