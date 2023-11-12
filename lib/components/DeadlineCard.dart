import 'package:flutter/material.dart';
import 'package:dln/util/Deadline.dart';
import 'package:dln/util/DeadlineManager.dart';

class DeadlineCard extends StatelessWidget {
  final Deadline deadline;
  DeadlineCard({ required this.deadline });

  @override
  Widget build(BuildContext context) {
    final int progressValue = (deadline.remainingTimeProgress() * 10).round();

    return Card(
      child: Container(
        height: 100,
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Expanded(flex: 1, child: SizedBox.shrink()),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${this.deadline.title.toUpperCase()}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${this.deadline.timeStringForCard()}",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox.shrink()),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("${this.deadline.description}"),
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox.shrink()),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(flex: 1, child: SizedBox.shrink()),
                        Expanded(
                          flex: 1,
                          child: Center(child: Text("${this.deadline.tag.toUpperCase()}")),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(child: Text("${"●" * this.deadline.difficulty}")),
                        ),
                        Expanded(flex: 1, child: SizedBox.shrink()),
                      ],
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: progressValue,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade600,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(3)
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10 - progressValue,
                    child: Container(
                      color: Colors.yellow.shade600.withOpacity(0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}