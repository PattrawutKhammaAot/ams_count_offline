import 'package:flutter/material.dart';

class EditDataCountPage extends StatefulWidget {
  const EditDataCountPage({super.key});

  @override
  State<EditDataCountPage> createState() => _EditDataCountPageState();
}

class _EditDataCountPageState extends State<EditDataCountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Count'),
      ),
      body: const Center(
        child: Text('Edit Data Count Page'),
      ),
    );
  }
}
