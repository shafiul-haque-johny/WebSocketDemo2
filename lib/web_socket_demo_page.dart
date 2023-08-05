import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketDemo extends StatefulWidget {
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  WebSocketDemo({Key? key}) : super(key: key);

  @override
  State<WebSocketDemo> createState() => _WebSocketDemoState(channel: channel);
}

class _WebSocketDemoState extends State<WebSocketDemo> {
  final WebSocketChannel channel;
  final TextEditingController your_controller = TextEditingController();

  List<String> messageList = [];

  _WebSocketDemoState({required this.channel}) {
    channel.stream.listen((data) {
      setState(() {
        print(data);
        messageList.add(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Web Socket Demo Page',
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[500],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: your_controller,
                    decoration: InputDecoration(
                      labelText: 'Send Message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Expanded(
              child: getMessageList(),
            ),
          ],
        ),
      ),
      // Send Message Button
      floatingActionButton: FloatingActionButton(
        onPressed: sendMessage,
        tooltip: 'Send Message',
        child: Icon(Icons.send),
      ),
    );
  }

  // show message
  void sendMessage() {
    if (your_controller.text.isNotEmpty) {
      channel.sink.add(your_controller.text);
      your_controller.text = '';
    }
  }

  // Store Message in a List
  ListView getMessageList() {
    List<Widget> listWidget = [];

    for (String message in messageList) {
      listWidget.add(
        ListTile(
          title: Container(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(fontSize: 20),
              ),
            ),
            color: Colors.teal[100],
            height: 45,
          ),
        ),
      );
    }

    return ListView(
      children: listWidget,
    );
  }

  //close the connection
  @override
  void dispose() {
    channel.sink.close();
    your_controller.dispose();
    super.dispose();
  }
}
