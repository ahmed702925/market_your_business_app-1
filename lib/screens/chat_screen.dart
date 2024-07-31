import 'dart:developer';

import 'package:market_app/models/user_nav.dart';
import 'package:market_app/providers/shard_pref.dart';
import '../widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/chat.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';
  final orgId;
  ChatScreen({this.orgId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _enteredMessage = '';
  var _isInit = true;
  var chat =
      Chat(time: '', text: '', userId: '', userName: '', img: '', id: null);

  final _controller = new TextEditingController();
  // var data;
  UserNav? userLoad;
  bool _loading = false;
  loadSharedPrefs() async {
    try {
      SharedPref sharedPref = SharedPref();
      UserNav user = UserNav.fromJson(await sharedPref.read("user"));
      userLoad = user;
    } catch (Excepetion) {
      // do something
    }
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    chat = Chat(
      img: chat.img,
      text: _enteredMessage,
      userName: chat.userName,
      userId: 
      // "zNRzRliSjLbXxz4FPQjMQJXAOmj1",
      chat.userId,
      id: chat.id,
      time: chat.time,
    );
    Provider.of<ChatProvider>(context, listen: false)
        .addMessage(chat, userLoad!.email!.split('.')[0], widget.orgId)
        .then((value) => {
              _controller.clear(),
              _enteredMessage = '',
            });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadSharedPrefs().then((_) => {
            Provider.of<ChatProvider>(context,listen: false)
                .fetchAndSetChat(userLoad!.email!.split('.')[0], widget.orgId)
                .then((value) => {
                      _loading = true,
                    }),
          });
    }
    _isInit = false;
    if (_loading) {
      chat = Chat(
          time: '',
          text: '',
          userId: userLoad!.id.toString(),
          userName: userLoad!.email!.split('@')[0],
          img: '',
          id: null);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final chatDocs = Provider.of<ChatProvider>(context);
    log("chat is : "+chatDocs.items.length.toString());
    if(userLoad!=null){
 Provider.of<ChatProvider>(context)
                .fetchAndSetChat(userLoad!.email!.split('.')[0], widget.orgId)
                .then((value) => {
                      _loading = true,
                    });

    }
   
    return Scaffold(
      appBar: AppBar(
        title: Text('المحادثة'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _loading
                  ? FutureBuilder(
                      future: chatDocs.fetchAndSetChat(
                          userLoad!.email!.split('.')[0], widget.orgId),
                      builder: (ctx, futureSnapshot) {
                        return StreamBuilder(builder: (ctx, chatSnapshot) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: chatDocs.items.length,
                            itemBuilder: (_, index) => MessageBubble(
                              chatDocs.items[index].text,
                              chatDocs.items[index].userName,
                              chatDocs.items[index].userName == "Admin",
                            ),
                          );
                        }, stream: null,);
                      },
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'كتابة رسالة ...'),
                      onChanged: (value) {
                        setState(() {
                          _enteredMessage = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(
                      Icons.send,
                    ),
                    onPressed:
                        _enteredMessage.trim().isEmpty ? null : _sendMessage,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
