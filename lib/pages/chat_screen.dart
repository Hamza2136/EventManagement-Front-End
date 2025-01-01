// import 'package:flutter/material.dart';
// // import 'package:secure_chat_flutter/services/signalr_service.dart';
// // import 'package:secure_chat_flutter/services/token_service.dart';

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, String>> _messages = [];
//   final List<String> _systemMessages = [];
//   late int? userId;

//   // @override
//   // void initState() {
//   //   super.initState();

//   //   // Initialize SignalR connection and listen for incoming messages
//   //   SignalRService.listenForMessages((user, message) {
//   //     setState(() {
//   //       if (user == 'System') {
//   //         _systemMessages.add(message);
//   //       } else {
//   //         if (int.parse(user) != userId) {
//   //           _messages.add({'user': user, 'message': message});
//   //         }
//   //       }
//   //     });
//   //   });

//   //   getUserId();
//   // }

//   // void getUserId() async {
//   //   String? userIdFromToken = await TokenService.getUserIdFromToken();
//   //   if (userIdFromToken != null) {
//   //     setState(() {
//   //       userId = int.parse(userIdFromToken);
//   //     });
//   //   } else {
//   //     print("No User ID found in token, token is missing, or token has expired.");
//   //   }
//   // }

//   // void _sendMessage() {
//   //   if (userId == null) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Unable to retrieve user ID from token!')),
//   //     );
//   //     return;
//   //   }

//   //   if (_messageController.text.isNotEmpty) {
//   //     SignalRService.sendMessage(userId.toString(), _messageController.text);
//   //     setState(() {
//   //       _messages.add({'user': userId.toString(), 'message': _messageController.text});
//   //     });
//   //     _messageController.clear();
//   //   }
//   // }

//   Widget _buildMessageBubble(String message, bool isMyMessage) {
//     return Align(
//       alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         decoration: BoxDecoration(
//           color: isMyMessage ? Colors.blueAccent : Colors.grey[300],
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(15),
//             topRight: const Radius.circular(15),
//             bottomLeft: isMyMessage ? const Radius.circular(15) : Radius.zero,
//             bottomRight: isMyMessage ? Radius.zero : const Radius.circular(15),
//           ),
//         ),
//         child: Text(
//           message,
//           style: TextStyle(
//             color: isMyMessage ? Colors.white : Colors.black87,
//             fontSize: 16,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSystemMessage(String message) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       color: Colors.amber[100],
//       child: Text(
//         message,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           color: Colors.black87,
//           fontSize: 14,
//           fontStyle: FontStyle.italic,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat Room'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           if (_systemMessages.isNotEmpty)
//             Container(
//               color: Colors.amber[50],
//               child: Column(
//                 children: _systemMessages
//                     .map((message) => _buildSystemMessage(message))
//                     .toList(),
//               ),
//             ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               reverse: true,
//               itemBuilder: (context, index) {
//                 final message = _messages[_messages.length - 1 - index];
//                 final isMyMessage = message['user'] == userId.toString();
//                 return _buildMessageBubble(message['message']!, isMyMessage);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 15,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   // onTap: _sendMessage,
//                   child: const CircleAvatar(
//                     radius: 25,
//                     child: Icon(Icons.send, color: Colors.white),
//                     backgroundColor: Colors.blueAccent,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  int messageCount = 0;

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        // Add user message
        _messages.add({'user': 'Me', 'message': _messageController.text});
        messageCount++;

        // Add automatic reply
        if (messageCount == 1) {
          _messages.add({'user': 'Bot', 'message': 'Hello'});
        } else if (messageCount == 2) {
          _messages
              .add({'user': 'Bot', 'message': 'I am fine, what about you?'});
        } else if (messageCount == 3) {
          _messages.add({'user': 'Bot', 'message': 'Ok, Good Bye!'});
        }
      });
      _messageController.clear();
    }
  }

  Widget _buildMessageBubble(String message, bool isMyMessage) {
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isMyMessage ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isMyMessage ? const Radius.circular(15) : Radius.zero,
            bottomRight: isMyMessage ? Radius.zero : const Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMyMessage ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Chat Room",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isMyMessage = message['user'] == 'Me';
                return _buildMessageBubble(message['message']!, isMyMessage);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: HexColor("#4a43ec"),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
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
