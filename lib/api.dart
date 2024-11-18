import 'dart:convert';
import 'package:product_management/model/loaisanpham.dart';
import 'package:http/http.dart' as http;
import 'package:product_management/model/sanpham.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  String serverURL = kIsWeb ? "http://127.0.0.1" : "http://10.0.2.2";

  Future<List<Sanpham>> getSanpham() async {
    final response =
        await http.get(Uri.parse("${serverURL}/api-demo/api/dsSanPham.php"));

    if (response.statusCode == 200) {
      List<Sanpham> listSanpham = (jsonDecode(response.body) as List)
          .map((data) => Sanpham.fromJson(data))
          .toList();
      return listSanpham;
    } else {
      throw Exception('Lỗi load dữ liệu từ server');
    }
  }


   Future<List<Loaisanpham>> getLoai() async {
    final response = await http.get(Uri.parse("${serverURL}/api-demo/api/dsLoai.php"));
    if (response.statusCode == 200) {
      List<Loaisanpham> listLoai = (jsonDecode(response.body) as List)
          .map((data) => Loaisanpham.fromJson(data))
          .toList();
      return listLoai;
    } else {
      throw Exception('Lỗi load dữ liệu từ server');
    }
  }
}