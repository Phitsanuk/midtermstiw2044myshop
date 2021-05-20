import 'package:flutter/material.dart';
import 'newproduct.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'My Shop', home: MyHome());
  }
}

class MyHome extends StatefulWidget {
  final Product product;

  const MyHome({Key key, this.product}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('My Shop'),
      ),
      body: const Center(child: Text('You have no item yet.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewProduct()));
        },
        child: const Icon(Icons.add_circle_outline_sharp),
        backgroundColor: Colors.blue[900],
      ),
    );
  }
}
