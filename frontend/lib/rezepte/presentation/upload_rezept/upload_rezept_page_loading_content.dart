import 'package:flutter/material.dart';

class UploadRezeptPageLoadingContent extends StatelessWidget {
  const UploadRezeptPageLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Rezept wird analysiert... (Das kann bis zu 30 Sekunden dauern)'),
        ],
      ),
    );
  }
}
