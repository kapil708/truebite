import 'package:flutter/material.dart';

class FoodDetailJsonPage extends StatelessWidget {
  const FoodDetailJsonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FoodDetailJsonView();
  }
}

class FoodDetailJsonView extends StatelessWidget {
  const FoodDetailJsonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food information")),
      body: Column(),
    );
  }
}
