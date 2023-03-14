import 'package:flutter/material.dart';

Future<bool?> showConfirmDeleteDialog(BuildContext context) {
  final confirmDialog = AlertDialog(
    title: const Text('Confirm note deletion'),
    content: const Text('Are you sure to delete a note?'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: const Text('Yes'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: const Text('No'),
      ),
    ],
  );
  return showDialog(
    context: context,
    builder: (context) {
      return confirmDialog;
    },
  );
}

Future<bool?> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      });
}

Future<void> showErrorMessage(BuildContext context, title, String message) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              ElevatedButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]);
      });
}
