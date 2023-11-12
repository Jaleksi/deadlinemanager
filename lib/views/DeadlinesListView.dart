import 'package:flutter/material.dart';
import 'package:dln/util/DeadlineManager.dart';
import 'package:dln/util/Deadline.dart';
import 'package:dln/components/DeadlineCard.dart';
import 'package:dln/components/ConfirmDeleteDialog.dart';

class DeadlinesListView extends StatefulWidget {
  const DeadlinesListView({super.key});
  @override
  State<DeadlinesListView> createState() => _DeadlinesListViewState();
}

class _DeadlinesListViewState extends State<DeadlinesListView> {
  late Future<List<Deadline>> deadlinesFuture;

  @override
  void initState() {
    super.initState();
    deadlinesFuture = DeadlineManager().getDeadlines();
  }


  refresh() {
    setState(() {
      deadlinesFuture = DeadlineManager().getDeadlines();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Deadlines'),
      ),
      body: FutureBuilder<List<Deadline>> (
        future: deadlinesFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Deadline> deadlines = snapshot.data!;
            deadlines.sort((a, b) => a.datetime.compareTo(b.datetime));
            return ListView.builder(
              itemCount: deadlines.length,
              itemBuilder: (ctx, i) {
                return GestureDetector(
                  onLongPress: () {
                    confirmDelete(ctx, deadlines[i], refresh);
                  },
                  child: DeadlineCard(deadline: deadlines[i]),
                );
              },
            );
          }
        },
      ),
    );
  }
}