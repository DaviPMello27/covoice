import 'package:flutter/material.dart';

class ExercisesListPage  extends StatelessWidget {
  const ExercisesListPage ({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Amateur'),
              onTap: (){},
            ),
            ListTile(
              title: const Text('Intermediary'),
              onTap: (){},
            ),
            ListTile(
              title: const Text('Professional'),
              onTap: (){},
            ),
          ],
        ),
      ),
    );
  }
}