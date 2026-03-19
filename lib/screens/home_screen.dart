import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('lib/assests/Home page logo.png', height: 40),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assests/Home page logo.png', height: 80),
            const SizedBox(height: 20),
            Text('Welcome to PeerConnect', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Recent Community Updates', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
