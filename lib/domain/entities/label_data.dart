/// Answers "what IS a label" before answering "how is it rendered".
///
/// Deliberately NOT built from Board/Offcut directly, and knows
/// nothing about PDF, Zebra, PNG, or any other output format. Any
/// generator (`PdfLabelGenerator` today; a future
/// `ZebraLabelGenerator`/`PngLabelGenerator`) consumes exactly this
/// shape and nothing else — adding a new printer target never
/// touches this class or the entities it's built from.
///
/// All fields are plain, already-resolved strings — including
/// [status], which the CALLER passes in already localized
/// (`AppLocalizations.statusInStock` etc.). LabelData has no i18n
/// dependency of its own; it just carries whatever text it's given.
class LabelData {
  final String qrCode;
  final String title; // e.g. decor code — "H3303"
  final String subtitle; // e.g. decor name — "Natural Hamilton Oak"
  final String dimensions; // e.g. "2800×2070×18 mm"
  final String? location; // breadcrumb, e.g. "Warehouse A > Rack A > A1" — null if unresolved
  final String status; // already-localized display text

  const LabelData({
    required this.qrCode,
    required this.title,
    required this.subtitle,
    required this.dimensions,
    this.location,
    required this.status,
  });
}
