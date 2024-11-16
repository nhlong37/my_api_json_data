import 'dart:convert';

import 'package:product_management/api.dart';
import 'package:product_management/model/loaisanpham.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CreateScreen extends StatefulWidget {
  final String serverURL;
  const CreateScreen({super.key, required this.serverURL});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  // late Future<List<Loaisanpham>> futureLoai;
  List<Loaisanpham>? futureLoai;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  Uint8List? _imgData;
  String? _imgFileName;
  Loaisanpham? _selectedOption;
  ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    getLoai();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectOption(Loaisanpham? option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void getLoai() async {
    try {
      final data = await _apiService.getLoai();
      setState(() {
        futureLoai = data;
      });
    } catch (e) {
      print("Lỗi load dữ liệu từ server: $e");
    }
  }

  Future<void> _showDiaLog(String title, String message) async {
    return showDialog(
        context: context,
        builder: (BuildContext content) {
          return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("OK"))
              ]);
        });
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      //Sử dụng file_picker trong trường hợp là web
      var result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _imgFileName = result.files.single.name;
          _imgData = result.files.single.bytes;
        });
      } else {
        _showDiaLog("Thông báo", "Chưa có dữ liệu");
      }
    } else {
      //Sử dụng image_picker trong trường hợp là mobile
      final picker = ImagePicker();
      final pickerFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickerFile != null) {
        var result = await pickerFile.readAsBytes();
        setState(() {
          _imgFileName = pickerFile.path.split('/').last;
          _imgData = result;
        });
      } else {
        _showDiaLog("Thông báo", "Chưa có dữ liệu");
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final url =
            Uri.parse('${widget.serverURL}/api-demo/api/themSanPham.php');
        var request = http.MultipartRequest('POST', url);
        request.fields['ten'] = _nameController.text;
        request.fields['gia'] = _priceController.text;
        request.fields['mo_ta'] = _descriptionController.text;
        request.fields['loai_id'] = _selectedOption?.id.toString() ?? '';
        if (_imgData != null) {
          request.files.add(http.MultipartFile.fromBytes('hinh', _imgData!,
              filename: _imgFileName!));
        }
        var response = await request.send();
        if (response.statusCode == 200) {
          _showDiaLog("Thành công", "Thêm sản phẩm thành công");
          return;
        } else {
          var responseData = await http.Response.fromStream(response);
          var json = jsonDecode(responseData.body);
          _showDiaLog("Lỗi", jsonDecode(json['error']));
          return;
        }
      } catch (e) {
        _showDiaLog("Lỗi", "$e");
        return;
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return const Text("Đây là trang tạo");
  }
}
