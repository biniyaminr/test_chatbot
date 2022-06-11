import 'package:flutter/material.dart';
import 'package:test_chatbot/chatbotFeedback.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("አስተያየት"),
      elevation: 30.0,
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'አስተያየቶን እዚህ ያስገቡ',
            filled: true,
          ),
          maxLines: 5,
          maxLength: 4096,
          textInputAction: TextInputAction.done,
          validator: (String? text) {
            if (text == null || text.isEmpty) {
              return 'አስተያየቶን በትክክል እዚ አላስገቡም';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('ሰርዝ'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('አስገባ'),
          onPressed: () async {
            var response = await getFeedback();
            return response;
          }),
      ],
    );
  }

  Future getFeedback() async{
    if(_controller.text.length > 0){
      var client = getClient();
      var body = {
        "feedback":"I have some unresolved issue"
      };
      try{
        final feedback = await client.post(
          Uri.parse('https://amharic-chatbot-for-aau-admin.herokuapp.com/postfeedback'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body),
        );
        print(feedback.body);
      }
      finally{
        client.close();
        _controller.clear();
        Future.error("could not response your answer");
      }
    }



  }
  http.Client getClient(){
    return http.Client();

  }
}




















