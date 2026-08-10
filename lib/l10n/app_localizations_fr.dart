// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get warehousesTitle => 'Entrepôts';

  @override
  String get boardTitle => 'Panneau';

  @override
  String get offcutTitle => 'Chute';

  @override
  String get historyLabel => 'Historique';

  @override
  String get noEntries => 'Aucune entrée.';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get archive => 'Archiver';

  @override
  String get move => 'Déplacer';

  @override
  String get moveToLabel => 'Déplacer vers :';

  @override
  String get cut => 'Découper';

  @override
  String get cutOffcut => 'Découper une chute';

  @override
  String get retry => 'Réessayer';

  @override
  String get searchManually => 'Rechercher manuellement';

  @override
  String get scanAgain => 'Scanner à nouveau';

  @override
  String get scanQrCode => 'Scanner le code QR';

  @override
  String get viewSourceBoard => 'Voir le panneau d\'origine';

  @override
  String get addBoard => 'Ajouter un panneau';

  @override
  String get addRack => 'Ajouter un rayonnage';

  @override
  String get addSlot => 'Ajouter un emplacement';

  @override
  String get newBoardTitle => 'Nouveau panneau';

  @override
  String get newRackTitle => 'Nouveau rayonnage';

  @override
  String get newSlotTitle => 'Nouvel emplacement';

  @override
  String get deleteSlotQuestion => 'Supprimer cet emplacement ?';

  @override
  String get archiveBoardQuestion => 'Archiver ce panneau ?';

  @override
  String get archiveOffcutQuestion => 'Archiver cette chute ?';

  @override
  String get historyStaysVisible => 'L\'historique (Ledger) restera visible.';

  @override
  String get deleteSlotWarning =>
      'Cette action est irréversible. Les panneaux et chutes affectés à cet emplacement ne seront pas supprimés — ils perdront simplement leur emplacement assigné (slot_id pointera vers un enregistrement inexistant — une étape de nettoyage future si nécessaire).';

  @override
  String get fillDimensionsCorrectly =>
      'Veuillez renseigner correctement les dimensions.';

  @override
  String get noDecorsInCatalog =>
      'Aucun décor dans le catalogue — ajoutez-en au moins un.';

  @override
  String get noOtherSlotInRack => 'Aucun autre emplacement dans ce rayonnage.';

  @override
  String get noWarehousesYet =>
      'Aucun entrepôt pour le moment. Ajoutez le premier avec le bouton +.';

  @override
  String get nameLabel => 'Nom';

  @override
  String get nameHintSlot => 'Nom (ex. A1)';

  @override
  String get nameHintRack => 'Nom du rayonnage (ex. A, ENTREPÔT-1)';

  @override
  String get addressOptional => 'Adresse (facultatif)';

  @override
  String get decorLabel => 'Décor';

  @override
  String get lengthMm => 'Longueur (mm)';

  @override
  String get widthMm => 'Largeur (mm)';

  @override
  String get thicknessMm => 'Épaisseur (mm)';

  @override
  String get capacityLabel => 'Capacité';

  @override
  String get capacityPcsLabel => 'Capacité (pièces)';

  @override
  String errorPrefix(String message) {
    return 'Erreur : $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Rayonnage $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Rayonnages — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity pièces';
  }

  @override
  String get statusInStock => 'en stock';

  @override
  String get statusAvailable => 'disponible';

  @override
  String get statusArchived => 'archivé';

  @override
  String get newWarehouseTitle => 'Nouvel entrepôt';

  @override
  String get noItemsInSlot => 'Aucun panneau ni chute dans cet emplacement.';

  @override
  String get noRacksYet =>
      'Aucun rayonnage dans cet entrepôt.\nAjoutez le premier pour commencer à organiser les emplacements.';

  @override
  String get noSlotsYet =>
      'Aucun emplacement dans ce rayonnage.\nAjoutez le premier pour pouvoir y affecter des panneaux et des chutes.';

  @override
  String get boardsSectionLabel => 'PANNEAUX';

  @override
  String get offcutsSectionLabel => 'CHUTES';

  @override
  String get qrCodeNotFound => 'Ce code n\'existe pas ou a été supprimé.';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteSlotButton => 'Supprimer l\'emplacement';

  @override
  String cutFromBoardNote(String decor) {
    return 'Depuis le panneau ($decor) — reste dans le même emplacement.';
  }

  @override
  String statusLabel(String value) {
    return 'Statut : $value';
  }

  @override
  String get printLabelsForSlot => 'Imprimer les étiquettes';

  @override
  String get eventCreated => 'Créé';

  @override
  String get eventMoved => 'Déplacé';

  @override
  String get eventArchived => 'Archivé';

  @override
  String get eventCut => 'Découpé';

  @override
  String get eventQrRegenerated => 'QR régénéré';

  @override
  String get ownerDashboardTitle => 'Tableau de bord propriétaire';

  @override
  String get totalBoardsLabel => 'Panneaux';

  @override
  String get totalOffcutsLabel => 'Chutes';

  @override
  String get overallFillRateLabel => 'Taux de remplissage';

  @override
  String get totalRacksSlotsLabel => 'Rayonnages / Emplacements';

  @override
  String get staleItemsSectionTitle => 'Matériaux dormants';

  @override
  String get staleItemsSectionSubtitle => 'Inutilisés depuis plus d\'un an';

  @override
  String get noStaleItems => 'Aucun matériau dormant.';

  @override
  String get locationUnknown => 'Emplacement inconnu';

  @override
  String daysAgo(int days) {
    return 'il y a $days jours';
  }

  @override
  String get exportTitle => 'Export';

  @override
  String get exportWarehouseLabel => 'Entrepôt';

  @override
  String get exportButton => 'Exporter';

  @override
  String get exportEmptyWarehouse =>
      'Cet entrepôt n\'a aucun panneau ni chute à exporter.';

  @override
  String get exportColumnType => 'Type';

  @override
  String get exportColumnQrCode => 'Code QR';

  @override
  String get exportColumnDecorCode => 'Code décor';

  @override
  String get exportColumnDecorName => 'Nom du décor';

  @override
  String get exportColumnLocation => 'Emplacement';

  @override
  String get exportColumnStatus => 'Statut';

  @override
  String get exportColumnCreatedAt => 'Créé';

  @override
  String exportFailedMessage(String message) {
    return 'Échec de l\'export : $message';
  }
}
