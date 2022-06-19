import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  User? user;
  bool loading = true;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return loading ? Center(child: CircularProgressIndicator(),) : 
        Padding(
            padding: EdgeInsets.only(top: 40,left: 40,right: 40),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        image: _imageFile == null ? user!.image != null ? DecorationImage(
                            image: NetworkImage('${user!.image}'),
                            fit: BoxFit.cover
                        ) : null : DecorationImage(
                          image: FileImage(_imageFile ?? File('')),
                          fit: BoxFit.cover
                        ),
                        color: Colors.amber
                      ),
                    ),
                    onTap: (){
                      getImage();
                    },
                  ),
                ),
              ],
            ),
        );
  }
}