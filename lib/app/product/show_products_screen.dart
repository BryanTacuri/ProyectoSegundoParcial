import 'dart:developer';

import 'package:app_pizzeria/app/product/arguments/product_argument.dart';
import 'package:app_pizzeria/app/widgets/background_dissmisable.dart';
import 'package:app_pizzeria/app/widgets/emptyMessage.dart';
import 'package:app_pizzeria/domain/product/product_domain.dart';
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
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'create_product');
            },
            child: const Icon(Icons.add),
          ),
          body: snapshot.data!.docs.isEmpty
              ? const Center(child: EmptyMessageWidget())
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Column(
                      children: [
                        Dismissible(
                          key: UniqueKey(),
                          background: const BackgroundDissmisable(),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Eliminar Producto"),
                                  content: Text(
                                      "Estás seguro(a) de eliminar el producto: ${data['nameProduct'] ?? 'Coca-Cola'}"),
                                  actions: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          ProductDomain productDomain =
                                              ProductDomain();
                                          final value = productDomain
                                              .deleteProduct(
                                                  uid: data['uid'],
                                                  uidImage: data['uidImage'])
                                              .then((value) => value.status);
                                          return Navigator.of(context)
                                              .pop(true);
                                        },
                                        child: const Text("Eliminar")),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Cancelar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, 'update_product',
                                  arguments: ProductArgument(
                                      uidImage: data['uid_Image'] ?? '',
                                      uid: data['uid'] ?? '',
                                      descriptionProduct:
                                          data['descriptionProduct'] ??
                                              'Bebida azucarada.',
                                      nameProduct:
                                          data['nameProduct'] ?? 'Coca-Cola',
                                      priceProduct: data['priceProduct'] ?? 0,
                                      urlImage: data['urlImage']));
                            },
                            title: Text(data['nameProduct'] ?? 'Coca-Cola'),
                            subtitle: Text(data['descriptionProduct'] ??
                                'Bebida azucarada.'),
                            leading: Image(
                                image: NetworkImage(data['urlImage'] ??
                                    'https://img.freepik.com/foto-gratis/amor-romance-perforado-corazon-papel_53876-87.jpg')),
                            trailing: Text(
                              ' ${data['priceProduct'] ?? 0}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                        const Divider()
                      ],
                    );
                  }).toList(),
                ),
        );
      },
    );
  }
}
