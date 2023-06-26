import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/healpers/dialogs.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;


  Future<void> postImage(
      String uid,
      String username,
      String profImage,
      ) async {
      try{
        setState(() {
          isLoading = true;
        });
        String res = await FirestoreMethods().uploadPost(_descriptionController.text, uid, username, profImage, _file!);
        if(res == 'success'){
          setState(() {
            isLoading = true;
          });
          dialogs.showSnackbar(context, "Posted");
          clearImage();
        }else{
          setState(() {
            isLoading = true;
          });
          dialogs.showSnackbar(context, res);
        }
      }catch(err){
        dialogs.showSnackbar(context, err.toString());
      }
  }


  _selectImage(BuildContext context)async{
     return showDialog(context: context, builder: (context){
       return SimpleDialog(
         title: Text("Create a Post"),
         children: [
           SimpleDialogOption(
             child: Padding(
               padding: const EdgeInsets.all(10),
               child: Text("Take a photo"),
             ),
             onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
             },
           ),
           SimpleDialogOption(
             child: Padding(
               padding: const EdgeInsets.all(10),
               child: Text("Select from Gallery"),
             ),
             onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
             },
           ),
           SimpleDialogOption(
             child: Padding(
               padding: const EdgeInsets.all(10),
               child: Text("Cancel"),
             ),
             onPressed: ()  {
                Navigator.of(context).pop();
             },
           ),
         ],
       );
     });
  }
  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
  void clearImage(){
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserClass user = Provider.of<UserProvider>(context).getUser;

     return _file == null? Center(
      child: IconButton(
        icon: Icon(Icons.upload),
        onPressed: (){
          _selectImage(context);
        },
      ),
    ):
     Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {clearImage();},
        ),
        title: Text("Post to"),
        actions: [
          TextButton(
            onPressed: () {
              postImage(user.uid, user.username, user.photoUrl);
            },
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          isLoading?LinearProgressIndicator():Padding(padding: EdgeInsets.only(top: 0)),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                width: mq.height * 0.28,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Write a caption... ",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                  controller: _descriptionController,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
