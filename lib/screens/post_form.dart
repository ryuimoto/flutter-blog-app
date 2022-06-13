import 'package:flutter/material.dart';

class PostForm extends StatefulWidget{
  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new post'),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: IconButton(
                icon: Icon(Icons.image,size: 50,color: Colors.black38),
                onPressed: (){

                },
              ),
            ),
          ),
          Form(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}