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
    final response =
        await http.get(Uri.parse("${serverURL}/api-demo/api/dsLoai.php"));
    if (response.statusCode == 200) {
      List<Loaisanpham> listLoai = (jsonDecode(response.body) as List)
          .map((data) => Loaisanpham.fromJson(data))
          .toList();
      return listLoai;
    } else {
      throw Exception('Lỗi load dữ liệu từ server');
    }
  }

  Future<void> updateSanpham(Sanpham sanpham) async {
    // final response = await http.put(Uri.parse("${serverURL}/api-demo/api/suaSanPham.php"), body: sanpham.toJson());
    // if (response.statusCode == 200) {
    //   print('Cập nhật sản phẩm thành công');
    // } else {
    //   print('Lỗi cap nhật sản phẩm');
    // }
  }

  Future<void> deleteSanpham(int id, String name) async {
    final response = await http.delete(
        Uri.parse("${serverURL}/api-demo/api/xoaSanPham.php?id=$id&ten=$name"));
    if (response.statusCode == 200) {
      print('Xóa sản phẩm thành công');
    } else {
      print('Lỗi xóa sản phẩm');
    }
  }

  Future<Sanpham?> detailSanpham(int id) async {
    final response = await http
        .get(Uri.parse("${serverURL}/api-demo/api/dsSanPham.php?id=$id"));
    if (response.statusCode == 200) {
      List<Sanpham> sanpham = (jsonDecode(response.body) as List)
          .map((data) => Sanpham.fromJson(data))
          .toList();
      return sanpham[0];
    } else {
      return null;
    }
  }
}
