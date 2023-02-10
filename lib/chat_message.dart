import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key? key, required this.text, required this.sender})
      : super(key: key);
  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sender)
            .text
            .color(Colors.white)
            .subtitle1(context)
            .make()
            .box
            .color(sender == "You" ? Vx.red400 : Vx.green400)
            .p12
            .rounded
            .alignCenter
            .makeCentered(),
        Expanded(
            child: text
                .trim()
                .text
                .color(Colors.white)
                .bodyText1(context)
                .make()
                .px12()),
      ],
    ).py8();
  }
}
