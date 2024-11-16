class Loaisanpham {
  int id;
  String tenloai;

  Loaisanpham({required this.id, required this.tenloai});
  
  factory Loaisanpham.fromJson(Map<String, dynamic> json) {
    return Loaisanpham(
      id: json['id'],
      tenloai: json['ten_loai'],
    );
  }
  Map<String, dynamic> toJson() => {'id': id, 'ten_loai': tenloai};
}
