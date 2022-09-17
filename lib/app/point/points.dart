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
          return const CircularProgressIndicator();
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              PointDomain pointDomain = PointDomain();
              pointDomain.storePoint(
                  name: 'mi primer', owner: 'danielñ', lat: -0.2, lng: -79);
            },
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['owner']),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
