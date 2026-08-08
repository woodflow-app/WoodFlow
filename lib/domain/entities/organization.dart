/// Root of the hierarchy: Organization → Warehouse → Rack → Slot →
/// Board/Offcut. Per Domain Model Audit + ADR-003 — this should exist
/// from the first table, mostly dormant until multi-tenant features
/// (v2.5) actually need it. Minimal today: one default row, one FK
/// column on Warehouse. No auth, no billing, no multi-org UI — just
/// the seam that avoids retrofitting every table later.
class Organization {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Organization({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Well-known ID for the single default Organization every install
/// gets today. Multi-org (v2.5) will create real ones through the
/// repository like any other entity — this constant just avoids
/// every early caller needing to look it up.
const defaultOrganizationId = 'org-default';
