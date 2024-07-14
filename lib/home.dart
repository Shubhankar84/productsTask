import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:products/product_model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> productsList = [];

  Future<void> fetchProducts() async {
    try {
      print("calling fetchproducts in function now");
      final response =
          await http.get(Uri.parse('https://api.restful-api.dev/objects'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));

        List<dynamic> product = jsonDecode(response.body);
        print("PRODUCTS: ${product.length}");
        for (int i = 0; i < product.length; i++) {
          Product temp = Product.fromSnap(product[i] as Map<String, dynamic>);
          productsList.add(temp);
        }
        setState(() {});
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("calling fetchproducts");
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          productsList.clear();
          setState(() {});
          await fetchProducts();
        },
        child: const Icon(Icons.refresh),
      ),
      appBar: AppBar(
        title: const Text("Product List"),
      ),
      body: productsList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productsList.length,
              itemBuilder: (BuildContext context, index) {
                var product = productsList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            child: Text(product.id),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (product.data != null) ...[
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: product.data!.length,
                            itemBuilder: (BuildContext context, dataIndex) {
                              var entry =
                                  product.data!.entries.toList()[dataIndex];
                              return ListTile(
                                title: Text(
                                  entry.key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(entry.value.toString()),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
