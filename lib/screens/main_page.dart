import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _buildBody() {
    return Container(
        child: Column(
      children: [
        const Text("Podcato"),
        Container(child: const Text("Popular"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody()));
  }
}
