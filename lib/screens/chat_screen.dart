import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  IO.Socket? socket;

  List<String> msge = [];
  TextEditingController? msg;


  @override
  void initState() {
    msg = TextEditingController();

    initSocket();

    super.initState();
    
  }

  @override
  void dispose() {
    msg!.dispose();
    super.dispose();
  }


  initSocket(){
    socket = IO.io('http://localhost:8080/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      log('connect with the server!');
      
    });

    socket!.on("res", (data){
      log(data);
      setState(() {
        msge.add(data);
      });
    });

    socket!.onDisconnect((_) => log('disconnect from server'));
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Chat App Socket', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.04,
          ),

          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width * 0.40,
                child: ListView.builder(
                  itemCount: msge.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: Padding(
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: Text(
                          msge[index], 
                          style: TextStyle(fontSize: 20)),
                        ),
                      );
                  }
                  ),
              ),
            ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.70,
                  child: TextField(
                    controller: msg,
                    decoration: InputDecoration(
                      hintText: 'Enter Message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    socket!.emit("msg", msg!.text);
                    msg!.clear();
                  }, 
                  icon: Icon(Icons.send, color: Colors.blue,))
              ],
            ),

            SizedBox(
            height: height * 0.04,
          ),
        ],
      )
    );
  }
}