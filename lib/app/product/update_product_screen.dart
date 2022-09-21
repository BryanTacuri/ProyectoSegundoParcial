import 'dart:io';

import 'package:app_pizzeria/app/product/arguments/product_argument.dart';
import 'package:app_pizzeria/app/utils.dart';
import 'package:app_pizzeria/domain/product/product_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  String nameProduct = '';
  String descriptionProduct = '';
  double priceProduct = 0;
  String uid = '';
  String uidImage = '';
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
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments as ProductArgument;
    descriptionProduct = args.descriptionProduct;
    nameProduct = args.nameProduct;
    priceProduct = args.priceProduct;
    urlImage = args.urlImage;
    uid = args.uid;
    uidImage = args.uidImage;
    super.didChangeDependencies();
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'UID: $uid',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          height: Utils.getSize(context).height * 0.2,
                          width: Utils.getSize(context).height * 0.2,
                          child: Stack(
                            children: [
                              urlImage.startsWith('http')
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
                                          image: NetworkImage(urlImage)),
                                    )
                                  : Image(image: FileImage(File(urlImage))),
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
                        initialValue: nameProduct,
                        validator: _validator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        onChanged: (value) {
                          nameProduct = value;
                        },
                      ),
                      TextFormField(
                        initialValue: descriptionProduct,
                        validator: _validator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration:
                            const InputDecoration(labelText: 'Descripción'),
                        onChanged: (value) {
                          descriptionProduct = value;
                        },
                      ),
                      TextFormField(
                        initialValue: priceProduct.toString(),
                        validator: _validator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                        ],
                        decoration: const InputDecoration(labelText: 'Precio'),
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
                              : const Text('Editar'),
                        ),
                      )
                    ],
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
