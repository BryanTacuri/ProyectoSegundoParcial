import 'dart:io';

import 'package:app_pizzeria/app/utils.dart';
import 'package:app_pizzeria/domain/product/product_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  String nameProduct = '';
  String descriptionProduct = '';
  double priceProduct = 0;
  final ImagePicker _imagePicker = ImagePicker();
  final ProductDomain _productData = ProductDomain();
  bool savingImage = false;

  String urlImage = '';
  GlobalKey<FormState> myForm = GlobalKey();

  getImage() async {
    XFile? currentImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (currentImage != null) {
      setState(() {
        urlImage = currentImage.path;
      });
    }
  }

  gotoBack() {
    Navigator.pop(context);
  }

  storePoint() async {
    setState(() {
      savingImage = true;
    });
    final response = await _productData.storeProduct(
        urlImage: urlImage,
        priceProduct: priceProduct,
        nameProduct: nameProduct,
        descriptionProduct: descriptionProduct);
    setState(() {
      savingImage = false;
    });
    if (response.status) {
      gotoBack();
    }
    Utils.showScaffoldNotification(
        context: context,
        message: response.message,
        title: response.title,
        type: response.status ? 'success' : 'error');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crear Producto'),
        ),
        body: SafeArea(
            child: Form(
                key: myForm,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        SizedBox(
                            height: Utils.getSize(context).height * 0.2,
                            width: Utils.getSize(context).height * 0.2,
                            child: Stack(
                              children: [
                                urlImage.isNotEmpty
                                    ? SizedBox(
                                        height:
                                            Utils.getSize(context).height * 0.2,
                                        width:
                                            Utils.getSize(context).height * 0.2,
                                        child: FadeInImage(
                                            fit: BoxFit.cover,
                                            placeholderErrorBuilder:
                                                (context, error, stackTrace) {
                                              return const Image(
                                                  image: AssetImage(
                                                      'assets/error.jpg'));
                                            },
                                            placeholder: const AssetImage(
                                                'assets/product.png'),
                                            image: FileImage(File(urlImage))),
                                      )
                                    : const Image(
                                        image:
                                            AssetImage('assets/product.png')),
                                Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: const Icon(Icons.add_a_photo),
                                      onPressed: () {
                                        getImage();
                                      },
                                    ))
                              ],
                            )),
                        TextFormField(
                          validator: _validator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              const InputDecoration(labelText: 'Nombre'),
                          onChanged: (value) {
                            nameProduct = value;
                          },
                        ),
                        TextFormField(
                          validator: _validator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              const InputDecoration(labelText: 'Descripción'),
                          onChanged: (value) {
                            descriptionProduct = value;
                          },
                        ),
                        TextFormField(
                          validator: _validator,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r"[0-9.]")),
                          ],
                          decoration:
                              const InputDecoration(labelText: 'Precio'),
                          onChanged: (value) {
                            priceProduct = double.tryParse(value) ?? 0;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: savingImage
                                ? null
                                : () {
                                    if (myForm.currentState?.validate() ??
                                        false) {
                                      storePoint();
                                    } else {
                                      Utils.showScaffoldNotification(
                                          context: context,
                                          message:
                                              'Ingrese los campos correspondientes.',
                                          title: 'Atención',
                                          type: 'error');
                                    }
                                  },
                            child: savingImage
                                ? const CircularProgressIndicator()
                                : const Text('Guardar'),
                          ),
                        )
                      ],
                    ),
                  ),
                ))));
  }

  String? _validator(value) {
    if (value != null && value.toString().isNotEmpty) {
      return null;
    }
    return 'Campo requerido*';
  }
}
