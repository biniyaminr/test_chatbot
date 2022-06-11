import 'dart:convert';
import 'dart:core';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_chatbot/FeedbackDialog.dart';
import 'chatbotResponse.dart';



class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<String> _data = [];
  // static const String BOT_URL = "https://amharic-chatbot-for-aau.herokuapp.com/get_answer";
  final uri = Uri.parse('https://amharic-chatbot-for-aau.herokuapp.com/get_answer');
  TextEditingController queryController = TextEditingController();


  Future postAnswer() async{
    try{

      var response = await http.post(
          Uri.parse("https://amharic-chatbot-for-aau.herokuapp.com/get_answer"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(<String,String>{
            "question":"Where is the library?"
          },),

      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonMap = json.decode(response.body);

        return ChatbotResponse.fromJson(jsonMap);

      }if (response.statusCode == 400) {
        return Future.error('Could not fetch data: 400');
      }else {
        return Future.error('Could not fetch data');
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Align(
            alignment: Alignment.topRight,
            child:  GestureDetector(
              onTap: () {
                print("I was touched");
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context)=> FeedbackDialog()));
              },
              child: Text("አስተያየት አለኝ"),
            ),
          )
      ),
      body: Stack(
        children: <Widget>[

          AnimatedList(
            key: _listKey,
            initialItemCount: _data.length,
            itemBuilder: (BuildContext context, int index, Animation<double> animation){
              return buildItem(_data[index], animation, index);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ColorFiltered(
              colorFilter: ColorFilter.linearToSrgbGamma(),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    // style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(

                      suffixIcon: OutlinedButton(
                        onPressed: () async {
                          var response = await getResponse();
                          insertSingleItem(response.answer);
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.indigo,
                        ),
                      ),
                      hintText: "ጥያቄ አልዎት?",
                     fillColor: Colors.white12,),
                    controller: queryController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (msg)
                    async {
                      var response = await getResponse();
                      insertSingleItem(response.answer);
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }



    Future getResponse() async {
    if(queryController.text.length > 0){
      this.insertSingleItem(queryController.text);
      var client = getClient();
      var body = {"question" : "where is the library"};
      try{
        final response = await client.post(
          Uri.parse('https://amharic-chatbot-for-aau.herokuapp.com/get_answer'),
          headers: {"Content-Type": "application/json"},
          body: json.encode(body),
        );
        print(response.body);
        if (response.statusCode == 200) {
          var jsonMap = json.decode(response.body);

          return ChatbotResponse.fromJson(jsonMap);

        }if (response.statusCode == 400) {
          return Future.error('Could not fetch data: 400');

        }else {
          return Future.error('Could not fetch data');
        }
      }
      finally{
        client.close();
        queryController.clear();
        Future.error("could not fetch answer");
      }
    }
  }


  void insertSingleItem(String message) {
    _data.add(message);
    _listKey.currentState?.insertItem(_data.length-1);
  }
  // client
  http.Client getClient() {
    return http.Client();
  }
}




Widget buildItem(String item, Animation<double> animation, int index) {
  bool mine = item.endsWith("<bot>");
  return SizeTransition(
    sizeFactor: animation,
    child: Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(alignment: mine ? Alignment.topLeft : Alignment.topRight,
        child: Bubble(
          child: Text(
            item.replaceAll("<bot>", ""),
            style: TextStyle(
                color: mine ? Colors.white : Colors.black),
          ),
          color: mine ? Colors.blue : Colors.grey[200],
          padding: BubbleEdges.all(10),
        ),
      ),
    ),
  );
}


























