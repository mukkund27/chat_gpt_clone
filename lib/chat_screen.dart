import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgpt/three_dots.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
// import 'package:velocity_x/velocity_x.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;
  StreamSubscription? _subscription;
  bool _isTyping = false;
  @override
  void initState() {
    chatGPT = ChatGPT.instance;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void _sendMessage() {
    ChatMessage _message = ChatMessage(text: _controller.text, sender: "You");

    setState(() {
      _messages.insert(0, _message);
      _isTyping = true;
    });
    _controller.clear();
    final request = CompleteReq(
        prompt: _message.text, model: kTranslateModelV3, max_tokens: 200);

    _subscription = chatGPT!
        .builder(
          "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",
        )
        .onCompleteStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage = ChatMessage(
        text: response!.choices[0].text,
        sender: "bot",
      );
      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return Container(
      color: Color(0xff192734),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            style: TextStyle(color: Colors.white),
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: InputDecoration.collapsed(
                hintText: "Send a Message",
                hintStyle: TextStyle(color: Colors.grey)),
          )),
          IconButton(
              onPressed: () => _sendMessage(),
              icon: Icon(
                Icons.send,
                color: Colors.grey,
              ))
        ],
      ).px16(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff22303C),
      appBar: AppBar(
          backgroundColor: Color(0xff192734),
          title: const Text(
            "ChatGpt",
            style: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              reverse: true,
              padding: Vx.m8,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _messages[index];
              },
            )),
            if (_isTyping) ThreeDots(),
            const Divider(
              height: 1,
            ),
            Container(
              color: context.cardColor,
              child: _buildTextComposer(),
            )
          ],
        ),
      ),
    );
  }
}
