// // ignore_for_file: library_private_types_in_public_api, avoid_print

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import '../services/chat_service.dart';

// class ChatScreen extends StatefulWidget {
//   final String receiverId;
//   final String receiverName;

//   const ChatScreen({super.key, required this.receiverId, required this.receiverName});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final ChatService _chatService = ChatService();
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   List<dynamic> _messages = [];
//   String? _lastSentMessage;

//   @override
//   void initState() {
//     super.initState();
//     _initializeChat();
//   }

//   @override
//   void dispose() {
//     _chatService.stopListening();
//     super.dispose();
//   }

//   void _initializeChat() async {
//     await _chatService.initialize();
//     _loadMessages();
//     _listenForIncomingMessages();
//   }

//   void _listenForIncomingMessages() {
//     _chatService.listenForMessages((message) {
//       // Only add the message if it's not the one you just sent
//       if (message != _lastSentMessage) {
//         setState(() {
//           _messages.add({
//             'text': message,
//             'isCurrentUserSentMessage': false,
//             'time': TimeOfDay.now().format(context),
//           });
//         });
//         _scrollToBottom();
//       }
//     });
//   }

//   void _loadMessages() async {
//     // Fetch initial messages
//     try {
//       final response = await _chatService.getMessages(widget.receiverId);
//       final messages = response['messages'];
//       setState(() {
//         _messages = messages.map((message) {
//           final isCurrentUserSentMessage = message['isCurrentUserSentMessage'];
//           final time = message['time'];
//           return {
//             'text': message['text'],
//             'isCurrentUserSentMessage': isCurrentUserSentMessage,
//             'time': time,
//           };
//         }).toList();
//       });
//       _scrollToBottom();
//     } catch (e) {
//       print("Error loading messages: $e");
//     }
//   }

//   void _sendMessage() async {
//     final message = _messageController.text;
//     if (message.isNotEmpty) {
//       // Add the message immediately to your local list
//       setState(() {
//         _messages.add({
//           'text': message,
//           'isCurrentUserSentMessage': true,
//           'time': TimeOfDay.now().format(context),
//         });
//         _lastSentMessage = message; // Track the last sent message
//       });
//       _messageController.clear();
//       _scrollToBottom();

//       // Send the message to the server
//       await _chatService.sendMessage(widget.receiverId, message);
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }

//   Widget _buildMessageBubble(String message, bool isMyMessage, String time) {
//     return Align(
//       alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         decoration: BoxDecoration(
//           color: isMyMessage ? HexColor("#4a43ec") : Colors.grey[300],
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(15),
//             topRight: const Radius.circular(15),
//             bottomLeft: isMyMessage ? const Radius.circular(15) : Radius.zero,
//             bottomRight: isMyMessage ? Radius.zero : const Radius.circular(15),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               message,
//               style: TextStyle(
//                 color: isMyMessage ? Colors.white : Colors.black87,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               time,
//               style: TextStyle(
//                 color: isMyMessage ? Colors.white70 : Colors.black54,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: HexColor("#4a43ec"),
//         title: Text(widget.receiverName,
//             style: const TextStyle(color: Colors.white)),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 final isMyMessage =
//                     message['isCurrentUserSentMessage'] ?? false;
//                 final time = message['time'];
//                 return _buildMessageBubble(message['text'], isMyMessage, time);
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
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: _sendMessage,
//                   child: CircleAvatar(
//                     radius: 25,
//                     backgroundColor: HexColor("#4a43ec"),
//                     child: const Icon(Icons.send, color: Colors.white),
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

// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  String? _lastSentMessage;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _chatService.stopListening();
    super.dispose();
  }

  void _initializeChat() async {
    await _chatService.initialize();
    _loadMessages();
    _listenForIncomingMessages();
  }

  void _listenForIncomingMessages() {
    _chatService.listenForMessages((message) {
      if (message != _lastSentMessage) {
        setState(() {
          _messages.add({
            'text': message,
            'isCurrentUserSentMessage': false,
            'date': DateFormat('dd/MM/yyyy').format(DateTime.now()),
            'time': TimeOfDay.now().format(context),
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _loadMessages() async {
    try {
      final response = await _chatService.getMessages(widget.receiverId);
      final messages = response['messages'] as List<dynamic>;

      setState(() {
        _messages = messages.map<Map<String, dynamic>>((message) {
          return {
            'text': message['text'],
            'isCurrentUserSentMessage': message['isCurrentUserSentMessage'],
            'date': message['date'],
            'time': message['time'],
          };
        }).toList();

        _messages.sort((a, b) {
          final dateA = DateFormat('dd/MM/yyyy hh:mm a')
              .parse('${a['date']} ${a['time']}'.toUpperCase());
          final dateB = DateFormat('dd/MM/yyyy hh:mm a')
              .parse('${b['date']} ${b['time']}'.toUpperCase());
          return dateA.compareTo(dateB);
        });
      });

      _scrollToBottom();
    } catch (e) {
      print("Error loading messages: $e");
    }
  }

  void _sendMessage() async {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      final now = DateTime.now();
      final dateStr = DateFormat('dd/MM/yyyy').format(now);
      final timeStr = TimeOfDay.now().format(context);

      setState(() {
        _messages.add({
          'text': message,
          'isCurrentUserSentMessage': true,
          'date': dateStr,
          'time': timeStr,
        });
        _lastSentMessage = message;
      });

      _messageController.clear();
      _scrollToBottom();

      await _chatService.sendMessage(widget.receiverId, message);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Widget _buildDateSeparator(String dateStr) {
    final parsedDate = DateFormat('dd/MM/yyyy').parse(dateStr);
    final displayDate = DateFormat('dd-MMM-yyyy').format(parsedDate);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Expanded(child: Divider(thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              displayDate,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const Expanded(child: Divider(thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isMyMessage, String time) {
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isMyMessage ? HexColor("#4a43ec") : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isMyMessage ? const Radius.circular(15) : Radius.zero,
            bottomRight: isMyMessage ? Radius.zero : const Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMyMessage ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                color: isMyMessage ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? lastDate;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#4a43ec"),
        title: Text(widget.receiverName,
            style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMyMessage =
                    message['isCurrentUserSentMessage'] ?? false;
                final time = message['time'];
                final date = message['date'];

                List<Widget> messageWidgets = [];

                if (lastDate != date) {
                  messageWidgets.add(_buildDateSeparator(date));
                  lastDate = date;
                }

                messageWidgets.add(
                    _buildMessageBubble(message['text'], isMyMessage, time));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: messageWidgets,
                );
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
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: HexColor("#4a43ec"),
                    child: const Icon(Icons.send, color: Colors.white),
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
