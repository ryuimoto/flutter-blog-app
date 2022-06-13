import 'package:flutter/material.dart';

class Profile extends StatefulWidget{
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile>{
  @override
  Widget build(BuildContext context){
    return Container(
      child: Center(child: Text('Profile'),),
    );
  }
}