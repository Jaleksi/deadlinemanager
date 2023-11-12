import 'package:flutter/material.dart';

import 'package:dln/views/DeadlinesListView.dart';
import 'package:dln/views/NewEntryView.dart';
import 'package:dln/components/NavBar.dart';
import 'package:dln/util/DeadlineManager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DeadlineManager().initNotifications();
  runApp(const DeadlineNotifier());
}

class DeadlineNotifier extends StatefulWidget {
  const DeadlineNotifier({super.key});
  @override
  State<DeadlineNotifier> createState() => _DeadlineNotifierState();
}

class _DeadlineNotifierState extends State<DeadlineNotifier> {
  int currViewIndex = 0;
  List views = [DeadlinesListView(), NewEntryView()];

  void setViewIndex(int i) {
    setState(() => currViewIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(child: views.elementAt(currViewIndex)),
        bottomNavigationBar: NavBar(
          currViewIndex: currViewIndex,
          onClick: setViewIndex
        ),
      ),
    );
  }
}