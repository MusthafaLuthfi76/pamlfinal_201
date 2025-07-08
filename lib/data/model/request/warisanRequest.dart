class WarisanRequest {
  final int assetId;
  final int keluargaId;

  WarisanRequest({
    required this.assetId,
    required this.keluargaId,
  });

  Map<String, dynamic> toJson() => {
    "asset_id": assetId,
    "keluarga_id": keluargaId,
  };
}
