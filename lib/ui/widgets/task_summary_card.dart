import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskSummaryCard extends StatelessWidget {
  TaskSummaryCard({
    super.key,
    required this.title, required this.count,
  });


  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              FittedBox(
                child: Text(title,
                  style: TextStyle(
                      color: Colors.grey
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
