class Book {
  String id;
  final String nama;
  final int harga;
  final String jenis;
  final String deskripsi;
  final String images;

  Book({
    this.id = "",
    required this.nama,
    required this.harga,
    required this.jenis,
    required this.deskripsi,
    required this.images,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      nama: json['nama'] as String,
      harga: json['harga'] as int,
      jenis: json['jenis'] as String,
      deskripsi: json['deskripsi'] as String,
      images: json['images'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'jenis': jenis,
      'deskripsi': deskripsi,
      'images': images,
    };
  }
}
