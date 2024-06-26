import 'package:flutter/material.dart';

///Normal Message bar with more actions
///
/// following attributes can be modified
///
///
/// # BOOLEANS
/// [replying] is additional reply widget top of the message bar
///
/// # STRINGS
/// [replyingTo] is a string to tag the replying message
///
/// # WIDGETS
/// [actions] are the additional leading action buttons like camera
/// and file select
///
/// # COLORS
/// [replyWidgetColor] is reply widget color
/// [replyIconColor] is the reply icon color on the left side of reply widget
/// [replyCloseColor] is the close icon color on the right side of the reply
/// widget
/// [messageBarColor] is the color of the message bar
/// [sendButtonColor] is the color of the send button
///
/// # METHODS
/// [onTextChanged] is function which triggers after text every text change
/// [onSend] is send button action
/// [onTapCloseReply] is close button action of the close button on the
/// reply widget usually change [replying] attribute to `false`

class ChatMessageBar extends StatelessWidget {
  final bool replying;
  final String replyingTo;
  final List<Widget> actions;
  //final TextEditingController _textController = TextEditingController();
  final TextEditingController textController;
  final Color replyWidgetColor;
  final Color replyIconColor;
  final Color replyCloseColor;
  final Color messageBarColor;
  final Color sendButtonColor;
  final String? hintText;
  final BoxDecoration? decoration;
  final void Function(String)? onTextChanged;
  final void Function(String)? onSend;
  final void Function()? onTapCloseReply;
  final FocusNode? focusNode;
  final int? maxLines;

  /// [MessageBar] constructor
  ///
  ///
  const ChatMessageBar(
      {super.key, 
      this.replying = false,
      this.replyingTo = "",
      this.actions = const [],
      required this.textController,
      this.replyWidgetColor = const Color(0xffF4F4F5),
      this.replyIconColor = Colors.blue,
      this.replyCloseColor = Colors.black12,
      this.messageBarColor = const Color(0xffF4F4F5),
      this.sendButtonColor = Colors.blue,
      this.onTextChanged,
      this.onSend,
      this.onTapCloseReply,
      this.hintText,
      this.decoration,
      this.focusNode,
      this.maxLines});

  /// [MessageBar] builder method
  ///
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          replying
              ? Container(
                  color: replyWidgetColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.reply,
                        color: replyIconColor,
                        size: 24,
                      ),
                      Expanded(
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: Text(
                            'Re : $replyingTo',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onTapCloseReply,
                        child: Icon(
                          Icons.close,
                          color: replyCloseColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ))
              : Container(),
          replying
              ? Container(
                  height: 1,
                  color: Colors.grey.shade300,
                )
              : Container(),
          Container(
            decoration: decoration ??
                BoxDecoration(
                  color: messageBarColor,
                ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Row(
              children: <Widget>[
                ...actions,
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: maxLines?? 3,
                    onChanged: onTextChanged,
                    decoration: InputDecoration(
                      hintText: hintText ?? "Type your message here",
                      hintMaxLines: 1,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5),
                      hintStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 0.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.black26,
                          width: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape:const CircleBorder(),
                      padding:const EdgeInsets.all(12), // Adjust the padding as needed
                      backgroundColor: sendButtonColor,
                      elevation: 11,
                    ),
                    onPressed: () {
                      if (textController.text.trim() != '') {
                        if (onSend != null) {
                          onSend!(textController.text.trim());
                        }
                        textController.text = '';
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white, // Adjust the icon color as needed
                      size: 20,
                    ),
                  ),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
