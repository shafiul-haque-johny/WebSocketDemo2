import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketDemo extends StatefulWidget {
  WebSocketDemo({Key? key}) : super(key: key);

  @override
  State<WebSocketDemo> createState() => _WebSocketDemoState();
}

class _WebSocketDemoState extends State<WebSocketDemo> {
  final TextEditingController your_controller = TextEditingController();
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Web Socket Demo Page',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: your_controller,
                decoration: InputDecoration(labelText: 'Send Message'),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
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
    }
  }

  //close the connection
  @override
  void dispose() {
    channel.sink.close();
    your_controller.dispose();
    super.dispose();
  }
}
