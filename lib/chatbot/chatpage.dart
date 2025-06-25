import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:intl/intl.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> with TickerProviderStateMixin {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  bool _isTyping = false;
  bool _isOnline = true;
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  ChatUser currentUser = ChatUser(
    id: "0",
    firstName: "You",
    //profileImage: "/assets/shawon.jpg",
  );

  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "LifeDrop AI",
    profileImage:
        "https://ui-avatars.com/api/?name=AI&background=4285F4&color=fff&size=128",
  );

  @override
  void initState() {
    super.initState();
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _typingAnimationController, curve: Curves.easeInOut),
    );
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      user: geminiUser,
      createdAt: DateTime.now(),
      text:
          "🩸 Welcome to LifeDrop AI! 🤖\n\nI'm here to help you with everything blood donation related:\n\n• Find nearby blood banks\n• Check donation eligibility\n• Learn about blood donation process\n• Understand blood types and compatibility\n• Get health tips for donors\n• Find donation events and camps\n\nHow can I assist you today? Feel free to ask me anything about blood donation! 💪❤️",
    );

    setState(() {
      messages = [welcomeMessage, ...messages];
    });
  }

  @override
  void dispose() {
    _typingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildUI()),
          if (_isTyping) _buildTypingIndicator(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios,
            color: Color(0xFF007AFF), size: 20),
      ),
      title: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "LifeDrop ChatBot",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 125, 11, 2),
                  ),
                ),
                Text(
                  _isTyping
                      ? "typing..."
                      : _isOnline
                          ? "online"
                          : "offline",
                  style: TextStyle(
                    fontSize: 13,
                    color: _isTyping ? const Color(0xFF007AFF) : Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => _showOptionsBottomSheet(),
          icon: const Icon(Icons.more_vert, color: Colors.grey),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(
          height: 0.5,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F7),
      ),
      child: DashChat(
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,
        messageOptions: MessageOptions(
          showCurrentUserAvatar: false,
          showOtherUsersAvatar: true,
          showTime: true,
          timeFormat: DateFormat('HH:mm'),
          currentUserContainerColor: const Color(0xFF007AFF),
          containerColor: Colors.white,
          textColor: Colors.black,
          currentUserTextColor: Colors.white,
          borderRadius: 18,
          messagePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          messageDecorationBuilder: (message, previousMessage, nextMessage) {
            final isCurrentUser = message.user.id == currentUser.id;
            final isFirstInGroup = previousMessage?.user.id != message.user.id;
            final isLastInGroup = nextMessage?.user.id != message.user.id;

            return BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    isCurrentUser ? 18 : (isFirstInGroup ? 18 : 4)),
                topRight: Radius.circular(
                    isCurrentUser ? (isFirstInGroup ? 18 : 4) : 18),
                bottomLeft: Radius.circular(
                    isCurrentUser ? 18 : (isLastInGroup ? 18 : 4)),
                bottomRight: Radius.circular(
                    isCurrentUser ? (isLastInGroup ? 18 : 4) : 18),
              ),
              color: isCurrentUser ? const Color(0xFF007AFF) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ],
            );
          },
          messageTextBuilder: (message, previousMessage, nextMessage) {
            return SelectableText(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: message.user.id == currentUser.id
                    ? Colors.white
                    : Colors.black,
                height: 1.3,
                fontWeight: FontWeight.w400,
              ),
            );
          },
          currentUserTimeTextColor: Colors.white70,
          timeTextColor: Colors.grey,
          avatarBuilder: (user, onPressAvatar, onLongPressAvatar) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: user.profileImage != null
                    ? NetworkImage(user.profileImage!)
                    : null,
                backgroundColor: const Color(0xFF4285F4),
                child: user.profileImage == null
                    ? const Icon(Icons.smart_toy, color: Colors.white, size: 16)
                    : null,
              ),
            );
          },
        ),
        inputOptions: InputOptions(
          sendOnEnter: true,
          inputDecoration: InputDecoration(
            hintText: "iMessage",
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: Color(0xFF007AFF), width: 1.5),
            ),
          ),
          sendButtonBuilder: (onSend) => Container(
            margin: const EdgeInsets.only(left: 4),
            child: Material(
              color: const Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onSend,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          leading: [
            IconButton(
              onPressed: () => _showAttachmentOptions(),
              icon: Icon(Icons.add, color: Colors.grey.shade600),
            ),
          ],
          inputToolbarPadding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
          inputToolbarStyle: const BoxDecoration(
            color: Color(0xFFF2F2F7),
          ),
        ),
        messageListOptions: MessageListOptions(
          separatorFrequency: SeparatorFrequency.days,
          dateSeparatorBuilder: (date) => Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatDate(date),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      color: const Color(0xFFF2F2F7),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(geminiUser.profileImage ?? ''),
            backgroundColor: const Color(0xFF4285F4),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _typingAnimation,
      builder: (context, child) {
        final progress =
            (_typingAnimation.value - (index * 0.2)).clamp(0.0, 1.0);
        final opacity = (progress * 2).clamp(0.0, 1.0);

        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(opacity),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
      _isTyping = true;
    });

    _typingAnimationController.repeat();

    // Haptic feedback
    HapticFeedback.lightImpact();

    try {
      String question = chatMessage.text;
      List<String> responseChunks = [];

      gemini.streamGenerateContent(question).listen(
        (event) {
          String chunk = event.content?.parts?.fold("", (previous, current) {
                if (current is TextPart) {
                  return "$previous${current.text}";
                }
                return previous;
              }) ??
              "";

          responseChunks.add(chunk);

          ChatMessage? lastMessage = messages.firstOrNull;
          if (lastMessage != null && lastMessage.user == geminiUser) {
            lastMessage = messages.removeAt(0);
            lastMessage.text = responseChunks.join();
            setState(() {
              messages = [lastMessage!, ...messages];
            });
          } else {
            ChatMessage message = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: responseChunks.join(),
            );
            setState(() {
              messages = [message, ...messages];
              _isTyping = false;
            });
            _typingAnimationController.stop();
          }
        },
        onDone: () {
          setState(() {
            _isTyping = false;
          });
          _typingAnimationController.stop();
          HapticFeedback.selectionClick();
        },
        onError: (error) {
          setState(() {
            _isTyping = false;
          });
          _typingAnimationController.stop();
          _showErrorSnackBar(chatMessage);
        },
      );
    } catch (e) {
      setState(() {
        _isTyping = false;
      });
      _typingAnimationController.stop();
      _showErrorSnackBar(chatMessage);
    }
  }

  void _showErrorSnackBar(ChatMessage originalMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text("Message failed to send"),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: "Retry",
          textColor: Colors.white,
          onPressed: () => _sendMessage(originalMessage),
        ),
      ),
    );
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.refresh, color: Color(0xFF007AFF)),
                title: const Text("Clear Chat"),
                onTap: () {
                  Navigator.pop(context);
                  _clearChat();
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Color(0xFF007AFF)),
                title: const Text("Share Chat"),
                onTap: () {
                  Navigator.pop(context);
                  // Implement share functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFF007AFF)),
                title: const Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "Attachments",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                      Icons.camera_alt, "Camera", Colors.green),
                  _buildAttachmentOption(
                      Icons.photo_library, "Gallery", Colors.blue),
                  _buildAttachmentOption(
                      Icons.description, "Document", Colors.orange),
                  _buildAttachmentOption(
                      Icons.location_on, "Location", Colors.red),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Clear Chat History"),
        content: const Text(
            "This will permanently delete all your messages. This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                messages.clear();
              });
              Navigator.pop(context);
              HapticFeedback.selectionClick();
            },
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return "Today";
    } else if (difference == 1) {
      return "Yesterday";
    } else if (difference < 7) {
      return _getDayName(date.weekday);
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }
}
