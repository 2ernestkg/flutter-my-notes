import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, title, String message) {
   showDialog(
     context: context,
     builder: (context) {
       return AlertDialog(title: Text(title), content: Text(message), actions: [
          ElevatedButton(
            child: const Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
       ]);
     }
   );
}
