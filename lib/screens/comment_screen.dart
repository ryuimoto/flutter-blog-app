import 'package:blog_app/constant.dart';
import 'package:blog_app/models/api_response.dart';
import 'package:blog_app/screens/login.dart';
import 'package:blog_app/services/comments_service.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models/comment.dart';

class CommentScreen extends StatefulWidget{
  final int? postId;

  CommentScreen({
      this.postId
  });

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen>{
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  TextEditingController _txtCommentController = TextEditingController();

  // Get comments
  Future<void> _getComments() async{
    userId = await getUserId();
    ApiResponse response = await getComments(widget.postId ?? 0);

    if(response.error == null){
      setState((){
        _commentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false)
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
      ));
    }
  }

  // create comment
  void _createComment() async{
    ApiResponse response = await createComments(widget.postId ?? 0,_txtCommentController.text);

    if(response.error == null){
      _txtCommentController.clear();
      _getComments();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false)
      });
    }
    else{
      setState((){
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
      ));
    }
  }

  void _deleteComment(int commentId) async {
    ApiResponse response = await deleteComments(commentId);

    if(response.error == null){
      _getComments();
    }
    else if(response.error == null){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false)
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
    }
  }

  @override
  void initState(){
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: _loading ? Center(child: CircularProgressIndicator(),) :
      Column(
          children: [
            Expanded(
                child: RefreshIndicator(
                    onRefresh: (){
                      return _getComments();
                    },
                    child: ListView.builder(
                        itemCount: _commentsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Comment comment = _commentsList[index];
                          return Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.black26, width: 0.5)
                                )
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              image: comment.user!.image != null ? DecorationImage(
                                                  image: NetworkImage('${comment.user!.image}'),
                                                  fit: BoxFit.cover
                                              ) : null,
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.blueGrey
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          '${comment.user!.name}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16
                                          ),
                                        )
                                      ],
                                    ),
                                    comment.user!.id == userId ?
                                    PopupMenuButton(
                                      child: Padding(
                                          padding: EdgeInsets.only(right:10),
                                          child: Icon(Icons.more_vert, color: Colors.black,)
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            child: Text('Edit'),
                                            value: 'edit'
                                        ),
                                        PopupMenuItem(
                                            child: Text('Delete'),
                                            value: 'delete'
                                        )
                                      ],
                                      onSelected: (val){
                                        if(val == 'edit'){
                                          setState(() {

                                          });

                                        } else {
                                          _deleteComment(comment.id ?? 0);
                                        }
                                      },
                                    ) : SizedBox()
                                  ],
                                ), SizedBox(height: 10,),
                                Text('${comment.comment}')
                              ],
                            ),
                          );
                        }
                    )
                )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.black26, width: 0.5
                    )
                ),
              ),
              child: Row(
                children: [
                    Expanded(
                        child: TextFormField(
                          decoration: kInputDecoration('Comment'),
                          controller: _txtCommentController,
                        ),

                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: (){
                        if(_txtCommentController.text.isNotEmpty){
                          setState((){
                            _loading = true;
                          });
                          _createComment();
                        }
                      },
                    )

                ],
              ),
            )
          ]
      ),
    );
  }
}