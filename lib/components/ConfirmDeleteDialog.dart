import 'package:flutter/material.dart';
import 'package:dln/util/DeadlineManager.dart';


Future<void> confirmDelete(BuildContext context, deadline, refreshCb) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text("Delete deadline?")),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text("${deadline.title}"),
            ],
          ),
        ),
        actions: 
        [
          TextButton(
            child: Text("Delete"),
            onPressed: () {
              DeadlineManager().removeById(deadline.id);
              refreshCb();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}