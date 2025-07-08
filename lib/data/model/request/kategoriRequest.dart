class KategoriRequest {
  final String name;

  KategoriRequest({required this.name});

  Map<String, dynamic> toJson() => {
    "name": name, // ✅ pastikan ini "name" bukan "nama"
  };
}
