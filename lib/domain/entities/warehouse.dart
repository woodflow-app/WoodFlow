/// Domain entity. Knows nothing about SQLite, column names, or
/// serialization — that mapping lives in WarehouseRepositoryImpl.
///
/// `organizationId` added per Pre-Build Audit — Warehouse is the
/// second level of the hierarchy (Organization → Warehouse → Rack →
/// Slot → Board/Offcut, per Domain Model Audit), required from day
/// one so v2.5 multi-org doesn't need a schema rebuild (ADR-003).
/// Every warehouse today belongs to `defaultOrganizationId` — there's
/// no UI to create a second Organization yet, and none is built
/// speculatively.
class Warehouse {
  final String id;
  final String organizationId;
  final String name;
  final String? address;
  final String qrCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// `qrCode` defaults to `''` on purpose — callers never set it
  /// meaningfully. `WarehouseRepositoryImpl.create()` always
  /// generates a fresh "WF-W-######" code inside its transaction
  /// and overwrites whatever was passed here (see qr_code_generator.dart).
  const Warehouse({
    required this.id,
    required this.organizationId,
    required this.name,
    this.address,
    this.qrCode = '',
    required this.createdAt,
    required this.updatedAt,
  });

  Warehouse copyWith({
    String? name,
    Object? address = _unset,
    String? qrCode,
    DateTime? updatedAt,
  }) {
    return Warehouse(
      id: id,
      organizationId: organizationId,
      name: name ?? this.name,
      address: identical(address, _unset) ? this.address : address as String?,
      qrCode: qrCode ?? this.qrCode,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Sentinel so copyWith can distinguish "leave address unchanged"
/// from "explicitly clear it to null" — same fix already applied to
/// Board/Offcut's copyWith after catching this bug class once.
const _unset = Object();
