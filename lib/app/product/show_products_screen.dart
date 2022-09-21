import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowProductsScreen extends StatefulWidget {
  const ShowProductsScreen({super.key});

  @override
  State<ShowProductsScreen> createState() => _ShowProductsScreenState();
}

class _ShowProductsScreenState extends State<ShowProductsScreen> {
  final Stream<QuerySnapshot> _pointStream = FirebaseFirestore.instance
      .collection('products')
      .snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _pointStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          inspect(snapshot);

          return const Text('Error al Obtener los productos.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'create_product');
            },
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['nameProduct'] ?? 'Coca-Cola'),
                subtitle:
                    Text(data['descriptionProduct'] ?? 'Bebida azucarada.'),
                leading: Image(image: NetworkImage(data['url'])),
                trailing: Text(
                  data['priceProduct'] ?? '3',
                  style: const TextStyle(color: Colors.green),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
