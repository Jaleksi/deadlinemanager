import 'package:flutter/material.dart';

import 'package:dln/util/Deadline.dart';
import 'package:dln/util/DeadlineManager.dart';
import 'package:dln/components/DateTimePicker.dart';

class NewEntryView extends StatefulWidget {
  const NewEntryView({super.key});
  @override
  State<NewEntryView> createState() => _NewEntryViewState();
}

class _NewEntryViewState extends State<NewEntryView> {
  final form_key = GlobalKey<FormState>();
  DeadlineManager dl_manager = DeadlineManager();
  String? newEntryTitle;
  String? newEntryTag;
  DateTime? newEntryDatetime;
  String? newEntryDescription;
  int? newEntryDifficulty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('New deadline'),
      ),
      body: Container(
        child: Form(
          key: form_key,
          child: ListView(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Invalid title";
                  }
                },
                onSaved: (value) {
                  newEntryTitle = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Invalid description";
                  }
                },
                onSaved: (value) {
                  newEntryDescription = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: "Tag"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Invalid tag";
                  }
                },
                onSaved: (value) {
                  newEntryTag = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Difficulty 1-3"),
                validator: (value) {
                  if (value == null) {
                    return "Invalid difficulty";
                  }
                  if (int.parse(value) < 1 || int.parse(value) > 3) {
                    return "Invalid difficulty";
                  }
                },
                onSaved: (value) {
                  newEntryDifficulty = int.parse(value!);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade600,
                ),
                child: Text(
                  "SET DATETIME",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () async {
                  newEntryDatetime = await showDateTimePicker(context: context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade600,
                ),
                child: Text(
                  "SUBMIT",
                  style: TextStyle(
                    color: Colors.black,
                  )
                ),
                onPressed: () {
                  if (
                    form_key.currentState!.validate() &&
                    newEntryDatetime != null
                  ) {
                    form_key.currentState!.save();
                    Deadline newEntryDeadline = Deadline(
                      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                      tag: newEntryTag!,
                      title: newEntryTitle!,
                      description: newEntryDescription!,
                      datetime: newEntryDatetime!,
                      difficulty: newEntryDifficulty!,
                    );
                    dl_manager.add(newEntryDeadline);
                    form_key.currentState!.reset();
                    FocusScope.of(context).requestFocus(new FocusNode());
                    dl_manager.updateStorage();
                  }
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade600,
                  ),
                  child: Text(
                    "TEST NOTIFICATION (5sec delay)",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    DeadlineManager().testNotification();
                  },
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}