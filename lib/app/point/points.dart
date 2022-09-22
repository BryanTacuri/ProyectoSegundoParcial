import 'dart:developer';

import 'package:app_pizzeria/app/point/arguments/points_arguments.dart';
import 'package:app_pizzeria/app/utils.dart';
import 'package:app_pizzeria/app/widgets/background_dissmisable.dart';
import 'package:app_pizzeria/app/widgets/emptyMessage.dart';
import 'package:app_pizzeria/domain/point/point_domain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PointPage extends StatefulWidget {
  const PointPage({super.key});

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  final Stream<QuerySnapshot> _pointStream = FirebaseFirestore.instance
      .collection('points')
      .snapshots(includeMetadataChanges: true);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _pointStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Error al Obtener los pdv.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'create_point');
            },
            child: const Icon(Icons.add),
          ),
          body: snapshot.data!.docs.isEmpty
              ? const Center(child: EmptyMessageWidget())
              : ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Column(
                      children: [
                        Dismissible(
                          key: UniqueKey(),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Eliminar Producto"),
                                  content: Text(
                                      "Estás seguro(a) de eliminar el Punto de venta: ${data['name'] ?? 'Coca-Cola'}"),
                                  actions: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          PointDomain pointDomain =
                                              PointDomain();
                                          final value = pointDomain
                                              .deletePoint(
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
                          background: const BackgroundDissmisable(),
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, 'update_point',
                                  arguments: PointsArgument(
                                      uidImage: data['uidImage'],
                                      urlImage: data['urlImage'],
                                      name: data['name'] ?? 'Joyas',
                                      uid: data['uid'] ?? '',
                                      owner: data['owner'] ?? 'Bryan Tacuri',
                                      lat: data['lat'] ?? 0,
                                      lng: data['lng'] ?? 0));
                            },
                            leading: Image(
                              image: NetworkImage(data['urlImage']),
                            ),
                            title: Text(data['name'] ?? 'Joyas'),
                            subtitle: Text(data['owner'] ?? 'Bryan Tacuri'),
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
