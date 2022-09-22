import 'dart:developer';

import 'package:app_pizzeria/app/point/arguments/points_arguments.dart';
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
          inspect(snapshot);
          return const Text('Error al Obtener los pdv.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'create_point');
            },
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, 'update_point',
                          arguments: PointsArgument(
                              name: data['name'] ?? 'Joyas',
                              uid: data['uid'] ?? '',
                              owner: data['owner'] ?? 'Bryan Tacuri',
                              lat: data['lat'] ?? 0,
                              lng: data['lng'] ?? 0));
                    },
                    title: Text(data['name'] ?? 'Joyas'),
                    subtitle: Text(data['owner'] ?? 'Bryan Tacuri'),
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
