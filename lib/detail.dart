import 'dart:convert';

import 'package:product_management/api.dart';
import 'package:product_management/listcolor/color.dart';
import 'package:product_management/model/loaisanpham.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:product_management/model/sanpham.dart';

class DetailScreen extends StatefulWidget {
  final String serverURL;
  final int id;
  const DetailScreen({super.key, required this.serverURL, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<List<Loaisanpham>> futureLoai;
  late Future<List<Sanpham>> futureSanpham;
  late Future<void> futureDetailSanpham;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  Uint8List? _imgData;
  String? _imgFileName;
  Loaisanpham? _selectedOption;
  ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    futureLoai = _api.getLoai();
    getDetailSanpham(widget.id);
  }

  Future<void> getSanpham() async {
    try {
      setState(() {
        futureSanpham = _api.getSanpham();
      });
    } catch (e) {
      print("Lỗi load dữ liệu từ server: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
  }

  void _selectOption(Loaisanpham? option) {
    setState(() {
      _selectedOption = option;
    });
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

  Future<void> _showDialogAfterAddProduct(String title, String message) async {
    return showDialog(
        context: context,
        builder: (BuildContext content) {
          return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () async {
                      // Context.mounted kiểm tra future chạy xong nó mới thực thi
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      await getSanpham();
                      setState(() {});
                    },
                    child: Text("OK"))
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
          _showDialogAfterAddProduct("Thành công", "Thêm sản phẩm thành công");

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
    }
  }

    Future<Sanpham?> getDetailSanpham(int id) async {
    await _api.detailSanpham(id!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorList.mediumdarkcyan,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 32),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  widget.id == 0
                      ? "Thêm mới Sản Phẩm".toUpperCase()
                      : "Cập nhật Sản Phẩm".toUpperCase(),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  FutureBuilder(
                      future: futureLoai,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              "Error: loading dropdown options ${snapshot.error}");
                        } else {
                          return DropdownButtonFormField<Loaisanpham>(
                            value: _selectedOption,
                            validator: (value) => value == null
                                ? "Vui lòng chọn loại sản phẩm"
                                : null,
                            items: snapshot.data!.map((option) {
                              return DropdownMenuItem<Loaisanpham>(
                                value: option,
                                child: Text(option.tenloai),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _selectedOption = value;
                            },
                            decoration:
                                InputDecoration(labelText: "Loại Sản Phẩm"),
                          );
                        }
                      }),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập tên sản phẩm";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Tên sản phẩm"),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui liệu nhập gia sản phẩm";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Giá sản phẩm"),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Vui lòng nhập mô tả";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Mô tả sản phẩm"),
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    children: [
                      _imgData == null
                          ? Text("Chưa có dữ liệu")
                          : Image.memory(
                              _imgData!,
                              height: 200,
                            ),
                      SizedBox(height: 5.0),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: Text("Chọn hình"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: Text("Thêm"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
