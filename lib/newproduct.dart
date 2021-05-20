import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class NewProduct extends StatefulWidget {
  final Product product;

  const NewProduct({Key key, this.product}) : super(key: key);
  @override
  _NewProductState createState() => _NewProductState();
}

class Product {
  String prid, prname, prtype, prprice, prqty;
  Product({this.prid, this.prname, this.prtype, this.prprice, this.prqty});
}

class _NewProductState extends State<NewProduct> {
  double screenHeight, screenWidth;
  File _image;
  TextEditingController prnameController = new TextEditingController();
  TextEditingController prtypeController = new TextEditingController();
  TextEditingController prpriceController = new TextEditingController();
  TextEditingController prqtyController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: Visibility(
          child: FloatingActionButton.extended(
        label: Text('Add New Product'),
        onPressed: () {
          _addPrd();
        },
        icon: Icon(Icons.add),
      )),
      body: Center(
        child: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Text("Add New Item",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  TextField(
                    controller: prnameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                  TextField(
                    controller: prtypeController,
                    decoration: InputDecoration(labelText: 'Product Type'),
                  ),
                  TextField(
                    controller: prpriceController,
                    decoration: InputDecoration(labelText: 'Product Price'),
                  ),
                  TextField(
                    controller: prqtyController,
                    decoration: InputDecoration(labelText: 'Product Quantity'),
                  ),
                  SizedBox(height: 5),
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 18,
                    color: Colors.blueAccent[700],
                    clipBehavior: Clip.antiAlias,
                    child: MaterialButton(
                      minWidth: 100,
                      height: 30,
                      color: Colors.blue[900],
                      child: Text('Register',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      onPressed: _onTakePictureDialog,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ))),
        ),
      ),
    );
  }

  _onTakePictureDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: new Container(
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Camera or Gallery?",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _openCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Theme.of(context).accentColor,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _openGallery()},
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  Future _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  _openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  void _addPrd() {
    if (_image == null ||
        prnameController.text.toString() == "" ||
        prtypeController.text.toString() == "" ||
        prpriceController.text.toString() == "" ||
        prqtyController.text.toString() == "") {
      Fluttertoast.showToast(
          msg: "Forget something?",
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.purple[900],
          textColor: Colors.white,
          fontSize: 20);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Add New Product?"),
            content: Text("Are your sure?"),
            actions: [
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _postuserGram();
                },
              ),
              TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _postuserGram() async {
    String base64Image = base64Encode(_image.readAsBytesSync());
    String prname = prnameController.text.toString();
    String prtype = prtypeController.text.toString();
    String prprice = prpriceController.text.toString();
    String prqty = prqtyController.text.toString();
    http.post(
        Uri.parse(
            "http://crimsonwebs.com/s274004/274004_myshop/php/newproduct.php"),
        body: {
          "prname": prname,
          "prtype": prtype,
          "prprice": prprice,
          "prqty": prqty,
          "encoded_string": base64Image
        }).then((response) {
      print(response.body);
      if (response.body == "success") {}
    }).then((response) {});
    Navigator.push(context, MaterialPageRoute(builder: (content) => MyHome()));
  }
}
