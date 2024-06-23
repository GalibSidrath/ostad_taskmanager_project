import 'package:flutter/material.dart';
import 'package:taskmanager/ui/widgets/profile_appbar.dart';

class ProgressedTaskScreen extends StatefulWidget {
  const ProgressedTaskScreen({super.key});

  @override
  State<ProgressedTaskScreen> createState() => _ProgressedTaskScreenState();
}

class _ProgressedTaskScreenState extends State<ProgressedTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppbar(context),
    );
  }
}
