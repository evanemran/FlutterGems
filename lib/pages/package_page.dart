import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PackagePage extends StatefulWidget {
  const PackagePage({super.key, required this.endPoint});
  
  final String endPoint;

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Package Info", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)),
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.endPoint)
          ],
        ),
      ),
    );
  }
}
