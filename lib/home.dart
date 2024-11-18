import 'dart:convert';
import 'package:product_management/api.dart';
import 'package:product_management/create.dart';
import 'package:product_management/listcolor/color.dart';
import 'package:product_management/model/sanpham.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String serverURL;
  const HomeScreen({super.key, required this.serverURL});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Sanpham> futureSanpham = [];
  Future<List<Sanpham>>? futureSanpham;
  ApiService _api = ApiService();
  var formartPrice = NumberFormat('#,##0 vnđ', 'vi');
  @override
  void initState() {
    super.initState();
    futureSanpham = _api.getSanpham();
  }

  // void getSanpham() async {
  //   try {
  //     final data = await _api.getSanpham();
  //     setState(() {
  //       futureSanpham = data;
  //     });
  //   } catch (e) {
  //     print("Lỗi load dữ liệu từ server: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String urlIMG = widget.serverURL + "/api-demo";
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 32),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Danh sách sản phẩm".toUpperCase(),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
            Expanded(
              child: FutureBuilder(
                  future: futureSanpham,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                          "Error: loading dropdown options ${snapshot.error}");
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data!.isEmpty) {
                            return Container(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Không có dữ liệu",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: ColorList.mediumdarkcyan),
                              ),
                            );
                          } else {
                            return Container(
                              margin: EdgeInsets.only(bottom: 20.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: ColorList.lightblue,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset:
                                          Offset(0, 0.8), // Bóng đổ lệch xuống
                                    ),
                                  ]),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(10.0),
                                leading: Image.network(
                                  "${urlIMG}" + snapshot.data![index].hinhanh!,
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(
                                  snapshot.data![index].tensanpham!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: ColorList.darkcyan,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${formartPrice.format(snapshot.data![index].gia!)}',
                                  style: TextStyle(
                                      fontSize: 16, color: ColorList.grey),
                                ),
                                trailing: Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.edit),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateScreen(
                        serverURL: widget.serverURL,
                      )));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        backgroundColor: ColorList.mediumdarkcyan,
      ),
    );
  }
}
