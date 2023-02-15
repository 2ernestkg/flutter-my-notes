import 'package:flutter/material.dart';

AlertDialog showErrorMessage(String title, String message) {
   return AlertDialog(title: Text(title), content: Text(message), actions: [
     ElevatedButton(
       child: const Text("Ok"),
       onPressed: () {
       },
     )
   ]);
}
