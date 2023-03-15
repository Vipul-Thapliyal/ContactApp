import 'package:flutter/material.dart';

class AllContacts extends StatefulWidget {
  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Text('This is the content of second screen'),
    );
  }
}