import '../model/loaisanpham.dart';

class Sanpham {
  int id;
  Loaisanpham loaisanpham;
  String tensanpham;
  String hinhanh;
  String mota;
  int gia;

  Sanpham({
    required this.id,
    required this.loaisanpham,
    required this.tensanpham,
    required this.hinhanh,
    required this.mota,
    required this.gia,
  });

  factory Sanpham.fromJson(Map<String, dynamic> json) {
    return Sanpham(
      id: json['id'],
      loaisanpham: json['loai_id'] is Map<String, dynamic>
          ? Loaisanpham.fromJson(json['loai_id']) // Nếu là Map, parse trực tiếp
          : Loaisanpham(id: json['loai_id'], tenloai: ""), // Nếu là int, chỉ lấy id,
      tensanpham: json['ten'],
      hinhanh: json['hinh'],
      mota: json['mo_ta'],
      gia: json['gia'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'loai_id': loaisanpham.toJson(),
    'ten': tensanpham,
    'hinh': hinhanh,
    'mo_ta': mota,
    'gia': gia,
  };
}
