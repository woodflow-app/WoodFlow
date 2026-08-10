import 'offcut.dart';

/// One offcut proposed by `OffcutMatchFinder` as an alternative for a
/// requested size — same decor, all three dimensions >= requested.
/// `wasteAreaMm2` is precomputed by the finder (candidate area minus
/// requested area) so the screen can show "closest fit first" without
/// recomputing the same subtraction a second place.
class OffcutMatchCandidate {
  final Offcut offcut;
  final double wasteAreaMm2;

  const OffcutMatchCandidate({required this.offcut, required this.wasteAreaMm2});
}
