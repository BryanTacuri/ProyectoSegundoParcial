import 'package:flutter/material.dart';
import 'package:app_pizzeria/app/utils.dart';

class EmptyMessageWidget extends StatelessWidget {
  const EmptyMessageWidget(
      {super.key, this.message = 'No hay data para mostar.'});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: Utils.getSize(context).height * 0.2,
            width: Utils.getSize(context).height * 0.2,
            child: const Image(image: AssetImage('assets/lupa.png'))),
        const Text('No Hay Datos para mostrar')
      ],
    );
  }
}
