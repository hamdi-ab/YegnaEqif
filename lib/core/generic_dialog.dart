import "package:flutter/material.dart";

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
            final T value = options[optionTitle];
            return TextButton(onPressed: () {
              if(value != null) {
                Navigator.of(context).pop(value);
              }
              else {
                Navigator.of(context).pop();
              }
            }, child: Text(optionTitle));
          }).toList(),
        );
      });
}

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context,
    title: 'An error occurred',
    content: text,
    optionsBuilder: () => {
      'ok': null,
    },
  );
}

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog(
    {required BuildContext context, required String text}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10,
        ),
        Text(text),
      ],
    ),
  );
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => dialog);

  return () => Navigator.of(context).pop();
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: "Log Out",
      content: 'Are you sure you want to log out?',
      optionsBuilder: () => {
        'Cancel': false,
        'Log Out': true,
      }).then((value) => value ?? false);
}

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: "Delete",
      content: 'Are you sure you want to Delete this item?',
      optionsBuilder: () => {
        'Cancel': false,
        'Delete': true,
      }).then((value) => value ?? false);
}



