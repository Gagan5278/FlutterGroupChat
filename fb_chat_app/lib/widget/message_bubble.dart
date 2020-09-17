import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String userMessage;
  final bool isSelfMessage;
  final String userName;
  final String imageUrl;
  final Key key;
  MessageBubble(
      this.userMessage, this.isSelfMessage, this.userName, this.imageUrl,
      {this.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          isSelfMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSelfMessage)
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            maxRadius: 10,
          ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft:
                    isSelfMessage ? Radius.circular(12) : Radius.circular(0),
                bottomRight:
                    !isSelfMessage ? Radius.circular(12) : Radius.circular(0),
              ),
              color: isSelfMessage ? Colors.blueGrey : Colors.purple),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: 150,
          child: Column(
            crossAxisAlignment: this.isSelfMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                this.isSelfMessage ? 'You' : userName,
                style:
                    TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
              ),
              Text(
                userMessage,
                style: TextStyle(
                    color: isSelfMessage
                        ? Theme.of(context).accentTextTheme.bodyText1.color
                        : Colors.white),
              ),
            ],
          ),
        ),
        if (isSelfMessage)
          CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            maxRadius: 10,
          ),
      ],
    );
  }
}
