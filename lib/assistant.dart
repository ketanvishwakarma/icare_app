import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'questions.dart';
import 'package:flutter_dialogflow_v2/flutter_dialogflow_v2.dart' as df;

class Assistant extends StatefulWidget {
  @override
  _AssistantState createState() => _AssistantState();
}

class _AssistantState extends State<Assistant> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final List<ChatMsg> _messages = [];

  @override
  void dispose() {
    for (ChatMsg message in _messages) message.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    itemCount: _messages.length,
                    reverse: true,
                    itemBuilder: (context, index) => _messages[index])),
            _buildTextComposer(),
          ],
        ));
  }

  Widget _buildTextComposer() {
    final _formKey = GlobalKey<FormState>();
    return IconTheme(
        data: IconThemeData(color: Colors.deepPurpleAccent),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _textController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    cursorColor: Colors.deepPurple,
                    decoration:
                        InputDecoration.collapsed(hintText: 'Send a message'),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.send,
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _handleSubmitted(_textController.text);
                        response(_textController.text);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'Please enter some text',
                          style: TextStyle(fontSize: 20),
                        )));
                      }
                    })
              ],
            ),
          ),
        ));
  }

  void _handleSubmitted(String textMessage) {
    ChatMsg message = ChatMsg(
        type: 'msg',
        textMsg: textMessage,
        animationController: AnimationController(
            duration: Duration(milliseconds: 500), vsync: this));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  void response(String query) async {
    _textController.clear();
    df.AuthGoogle authGoogle =
        await df.AuthGoogle(fileJson: 'assets/credential.json').build();
    df.Dialogflow dialogFlow =
        df.Dialogflow(authGoogle: authGoogle, sessionId: '123456');
    df.DetectIntentResponse response = await dialogFlow.detectIntent(
      df.DetectIntentRequest(
        queryInput: df.QueryInput(
          text: df.TextInput(
            text: query,
            languageCode: df.Language.english,
          ),
        ),
        queryParams: df.QueryParameters(
          resetContexts: true,
        ),
      ),
    );
    ChatMsg botMessage = ChatMsg(
        type: 'bot',
        showButton: response.queryResult.fulfillmentText != null,
        textMsg: response.queryResult.fulfillmentText == null
            ? 'Sorry no response found, can you ask something else!!'
            : response.queryResult.fulfillmentText,
        animationController: AnimationController(
            duration: Duration(milliseconds: 500), vsync: this));
    setState(() {
      _messages.insert(0, botMessage);
    });
    botMessage.animationController.forward();
  }
}

class ChatMsg extends StatelessWidget {
  final String type, textMsg;
  final bool showButton;
  final AnimationController animationController;

  const ChatMsg(
      {Key key,
      this.type,
      this.textMsg,
      this.animationController,
      this.showButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizeTransition(
        sizeFactor: CurvedAnimation(
            parent: animationController, curve: Curves.elasticOut),
        axisAlignment: 0.0,
        child: type == 'bot'
            ? Container(
                margin: EdgeInsets.only(
                    bottom: 10, left: 10, right: size.width * .30, top: 10),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: showButton != false ? Colors.deepPurpleAccent : null,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: showButton != false
                    ? Text(
                        textMsg,
                        style: TextStyle(fontSize: 17, color: Colors.white),
                        textAlign: TextAlign.left,
                      )
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10.0,
                    primary: Colors.deepPurpleAccent,
                    padding: EdgeInsets.all(5)
                  ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Questions())),
                        child: Text(
                          textMsg + '\n\nClick to ask Question to doctor',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                          textAlign: TextAlign.left,
                        )))
            : Container(
                width: double.infinity,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(textMsg,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.right),
              ));
  }
}
