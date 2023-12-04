import 'package:flutter/material.dart';

class RegisterNowScreen extends StatelessWidget {
  const RegisterNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
        backgroundColor: Colors.black,
        leading: IconButton(icon: Icon(Icons.arrow_backIos,color: Colors.white)),
      ),
      body: Container(
        child: Stack()
      ),
    );
  }
}