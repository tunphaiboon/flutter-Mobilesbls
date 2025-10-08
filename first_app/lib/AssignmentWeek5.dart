import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Assignmentweek5 extends StatefulWidget {
  const Assignmentweek5({super.key});

  @override
  State<Assignmentweek5> createState() => _Assignmentweek5State();
}

class _Assignmentweek5State extends State<Assignmentweek5> {
  List<Product> products = [];

  Future<void> fetchData() async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost:8001/products'),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        setState(() {
          products = jsonList.map((e) => Product.fromJson(e)).toList();
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createProduct(
    String name,
    String description,
    double price,
  ) async {
    try {
      var response = await http.post(
        Uri.parse("http://localhost:8001/products"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "description": description,
          "price": price,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Create success!'),
            backgroundColor: Colors.green,
          ),
        );
        fetchData();
      } else {
        throw Exception("Failed to create product");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateProduct(
    String id,
    String name,
    String description,
    double price,
  ) async {
    try {
      var response = await http.put(
        Uri.parse("http://localhost:8001/products/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "description": description,
          "price": price,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Update success!'),
            backgroundColor: Colors.blue,
          ),
        );
        fetchData();
      } else {
        throw Exception("Failed to update product");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      var response = await http.delete(
        Uri.parse("http://localhost:8001/products/$id"),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delete success!'),
            backgroundColor: Colors.red,
          ),
        );
        fetchData();
      } else {
        throw Exception("Failed to delete product");
      }
    } catch (e) {
      print(e);
    }
  }

  // Dialog สำหรับสร้างหรือแก้ไข
  void showProductForm({Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? "");
    final descController = TextEditingController(
      text: product?.description ?? "",
    );
    final priceController = TextEditingController(
      text: product != null ? product.price.toString() : "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? "เพิ่มสินค้า" : "แก้ไขสินค้า"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "ชื่อสินค้า"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "รายละเอียด"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "ราคา"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ยกเลิก"),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final desc = descController.text;
              final price = double.tryParse(priceController.text) ?? 0.0;
              Navigator.pop(context);
              if (product == null) {
                createProduct(name, desc, price);
              } else {
                updateProduct(product.id, name, desc, price);
              }
            },
            child: const Text("บันทึก"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // โหลดข้อมูลตอนเปิดหน้าจอ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 79, 87),
        title: const Text('Product', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Text('${index + 1}'),
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(product.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${product.price.toStringAsFixed(1)} ฿',
                  style: const TextStyle(color: Colors.green),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // แสดง dialog ยืนยันก่อนลบ
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("ยืนยันการลบ"),
                        content: Text(
                          "คุณต้องการลบสินค้า ${product.name} ใช่หรือไม่?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("ยกเลิก"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              deleteProduct(product.id);
                            },
                            child: const Text(
                              "ยืนยัน",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            onTap: () {
              // เปิดฟอร์มแก้ไข
              showProductForm(product: product);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showProductForm(), //  เปิดฟอร์มเพิ่มสินค้า
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
    );
  }
}