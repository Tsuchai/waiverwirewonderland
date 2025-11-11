import 'package:flutter/material.dart';

class ViewTeamScreen extends StatelessWidget {
  const ViewTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Team'),
      ),
      body: const Center(
        child: Text('View Team Screen'),
      ),
    );
  }
}
