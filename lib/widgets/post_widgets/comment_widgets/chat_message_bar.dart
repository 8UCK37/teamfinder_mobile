import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/data_service.dart';

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

class CommentMessageBar extends StatefulWidget {
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
  const CommentMessageBar(
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

  @override
  State<CommentMessageBar> createState() => _CommentMessageBarState();
}

class _CommentMessageBarState extends State<CommentMessageBar> {
  /// [MessageBar] builder method
  ///
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<ProviderService>(context, listen: true);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          widget.replying
              ? Container(
                  color: widget.replyWidgetColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.reply,
                        color: widget.replyIconColor,
                        size: 24,
                      ),
                      Expanded(
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: Text(
                            'Re : ${widget.replyingTo}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: widget.onTapCloseReply,
                        child: Icon(
                          Icons.close,
                          color: widget.replyCloseColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ))
              : Container(),
          widget.replying
              ? Container(
                  height: 1,
                  color: Colors.grey.shade300,
                )
              : Container(),
          Container(
            decoration: widget.decoration ??
                BoxDecoration(
                  color: widget.messageBarColor,
                ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Row(
              children: <Widget>[
                ...widget.actions,
                Expanded(
                  child: Column(
                    children: [
                      Visibility(
                        visible: userService.replyingToName != null,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: [
                                    const TextSpan(text: "Replying to.. "),
                                    TextSpan(
                                      text: userService.replyingToName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15,),
                              GestureDetector(
                                onTap: () {
                                  userService.updateReplyingTo(null, null);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 20, 20, 20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextField(
                        focusNode: widget.focusNode,
                        controller: widget.textController,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: widget.maxLines ?? 3,
                        onChanged: widget.onTextChanged,
                        decoration: InputDecoration(
                          hintText: widget.hintText ?? "Type your message here",
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(
                          12), // Adjust the padding as needed
                      backgroundColor: widget.sendButtonColor,
                      elevation: 11,
                    ),
                    onPressed: () {
                      if (widget.textController.text.trim() != '') {
                        if (widget.onSend != null) {
                          widget.onSend!(widget.textController.text.trim());
                        }
                        widget.textController.text = '';
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
