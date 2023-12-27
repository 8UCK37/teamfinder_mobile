import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

class DetectionTextField extends StatefulWidget {
  final GlobalKey<FlutterMentionsState> mentionKey;
  const DetectionTextField({super.key, required this.mentionKey});

  @override
  State<DetectionTextField> createState() => _DetectionTextFieldState();
}

class _DetectionTextFieldState extends State<DetectionTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
         FlutterMentions(
            suggestionListHeight: 150,
            key: widget.mentionKey,
            suggestionPosition: SuggestionPosition.Top,
            maxLines: 5,
            minLines: 1,
            decoration: const InputDecoration(hintText: 'hello'),
            mentions: [
              Mention(
                  trigger: '@',
                  style: TextStyle(
                    color: Colors.amber,
                  ),
                  data: [
                    {
                      'id': '61as61fsa',
                      'display': 'fayeedP',
                      'full_name': 'Fayeed Pawaskar',
                      'photo':
                          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
                    },
                    {
                      'id': '61asasgasgsag6a',
                      'display': 'khaled',
                      'full_name': 'DJ Khaled',
                      'style': TextStyle(color: Colors.purple),
                      'photo':
                          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
                    },
                    {
                      'id': 'asfgasga41',
                      'display': 'markT',
                      'full_name': 'Mark Twain',
                      'photo':
                          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
                    },
                    {
                      'id': 'asfsaf451a',
                      'display': 'JhonL',
                      'full_name': 'Jhon Legend',
                      'photo':
                          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'
                    },
                  ],
                  matchAll: false,
                  suggestionBuilder: (data) {
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              data['photo'],
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            children: <Widget>[
                              Text(data['full_name']),
                              Text('@${data['display']}'),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
              Mention(
                trigger: '#',
                disableMarkup: true,
                style: TextStyle(
                  color: Colors.blue,
                ),
                data: [
                  {'id': 'reactjs', 'display': 'reactjs'},
                  {'id': 'javascript', 'display': 'javascript'},
                ],
                matchAll: true,
              )
            ],
          ),
        
      ],
    );
  }
}
