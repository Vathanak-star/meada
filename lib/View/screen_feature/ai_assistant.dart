import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'feature_bottom_nav.dart';

class AiAssistant extends StatefulWidget {
  const AiAssistant({super.key});

  @override
  State<AiAssistant> createState() => _AiAssistantState();
}

class _AiAssistantState extends State<AiAssistant> {
  static const _rose = Color(0xFFC46F7D);
  static const _ink = Color(0xFF332D2F);
  static const _muted = Color(0xFF85797C);
  static const _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const _model = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-2.5-flash-lite',
  );

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isLoadingHistory = true;

  String get _apiKey => _geminiApiKey;

  User? get _user => Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final user = _user;
    if (user == null) {
      if (mounted) setState(() => _isLoadingHistory = false);
      return;
    }

    try {
      final rows = await Supabase.instance.client
          .from('chat_messages')
          .select('role, content, created_at')
          .eq('user_id', user.id)
          .order('created_at', ascending: true);
      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(
            (rows as List<dynamic>).map((row) {
              final data = row as Map<String, dynamic>;
              return _ChatMessage(
                text: data['content'] as String,
                isUser: data['role'] == 'user',
                createdAt: DateTime.parse(data['created_at'] as String),
              );
            }),
          );
        _isLoadingHistory = false;
      });
      _scrollToBottom();
    } on PostgrestException catch (_) {
      if (mounted) {
        setState(() => _isLoadingHistory = false);
        _showError(
          'Chat history is not set up yet. Run supabase/chat_messages.sql in Supabase SQL Editor.',
        );
      }
    }
  }

  Future<void> _saveMessage(_ChatMessage message) async {
    final user = _user;
    if (user == null) return;

    try {
      await Supabase.instance.client.from('chat_messages').insert({
        'user_id': user.id,
        'role': message.isUser ? 'user' : 'assistant',
        'content': message.text,
      });
    } on PostgrestException catch (error) {
      if (mounted) {
        _showError(
          'Message was not saved. Run supabase/chat_messages.sql in Supabase SQL Editor. (${error.message})',
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? suggestedMessage]) async {
    final text = (suggestedMessage ?? _messageController.text).trim();
    if (text.isEmpty || _isLoading) return;

    if (_apiKey.isEmpty) {
      _showError('Add your Gemini API key before starting a chat.');
      return;
    }
    if (_user == null) {
      _showError('Please log in before using the AI chat.');
      return;
    }

    _messageController.clear();
    final userMessage = _ChatMessage(
      text: text,
      isUser: true,
      createdAt: DateTime.now(),
    );
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    _scrollToBottom();
    await _saveMessage(userMessage);

    try {
      final reply = await _askGemini();
      if (!mounted) return;
      final assistantMessage = _ChatMessage(
        text: reply,
        isUser: false,
        createdAt: DateTime.now(),
      );
      setState(() => _messages.add(assistantMessage));
      await _saveMessage(assistantMessage);
      _scrollToBottom();
    } catch (error) {
      if (mounted) _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<String> _askGemini() async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey',
    );
    final contents = _messages.map((message) {
      return {
        'role': message.isUser ? 'user' : 'model',
        'parts': [
          {'text': message.text},
        ],
      };
    }).toList();

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'systemInstruction': {
              'parts': [
                {
                  'text':
                      'You are Meada, a warm and practical wellbeing assistant. '
                      'Give supportive general information, ask thoughtful follow-up questions, '
                      'and never present yourself as a doctor. For urgent danger or self-harm, '
                      'encourage contacting local emergency services immediately.',
                },
              ],
            },
            'contents': contents,
            'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 700},
          }),
        )
        .timeout(const Duration(seconds: 30));

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = (data['error'] as Map<String, dynamic>?)?['message'];
      throw Exception(error ?? 'Gemini could not answer right now.');
    }

    final candidates = data['candidates'] as List<dynamic>?;
    final parts =
        candidates?.firstOrNull?['content']?['parts'] as List<dynamic>?;
    final text = parts
        ?.map((part) => part['text'])
        .whereType<String>()
        .join('\n')
        .trim();
    if (text == null || text.isEmpty) {
      throw Exception('Gemini returned an empty response. Please try again.');
    }
    return text;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF5A3038),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3F3),
      appBar: AppBar(
        titleSpacing: 20,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meada AI', style: TextStyle(fontWeight: FontWeight.w700)),
            Text(
              'A calm space to talk things through',
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoadingHistory
                  ? const Center(child: CircularProgressIndicator(color: _rose))
                  : _messages.isEmpty
                  ? _buildWelcome()
                  : _buildMessages(),
            ),
            _buildComposer(),
          ],
        ),
      ),
      bottomNavigationBar: const FeatureBottomNav(activeIndex: 2),
    );
  }

  Widget _buildWelcome() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFEED9DE),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome, color: _rose, size: 28),
              SizedBox(height: 18),
              Text(
                'How are you feeling today?',
                style: TextStyle(
                  color: _ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Share what is on your mind. I can help you reflect, find information, or make a gentle plan.',
                style: TextStyle(color: _muted, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const SizedBox(height: 18),
        const Text(
          'TRY ASKING',
          style: TextStyle(
            color: _muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        ...[
          'I feel overwhelmed today',
          'Help me build a simple self-care plan',
          'What can help me sleep better tonight?',
        ].map(
          (prompt) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: OutlinedButton(
              onPressed: () => _sendMessage(prompt),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                side: const BorderSide(color: Color(0xFFE2D3D6)),
                foregroundColor: _ink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(prompt),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: _TypingBubble(),
          );
        }
        final message = _messages[index];
        return _MessageBubble(message: message);
      },
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE9DFE1))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Write a message...',
                filled: true,
                fillColor: const Color(0xFFF8F2F3),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          IconButton.filled(
            onPressed: _isLoading ? null : _sendMessage,
            tooltip: 'Send message',
            style: IconButton.styleFrom(
              backgroundColor: _rose,
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFD9BEC3),
            ),
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.arrow_upward_rounded),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isUser,
    required this.createdAt,
  });

  final String text;
  final bool isUser;
  final DateTime createdAt;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(message.createdAt.toLocal()),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 7),
        decoration: BoxDecoration(
          color: message.isUser ? _AiAssistantState._rose : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 18),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : _AiAssistantState._ink,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              time,
              style: TextStyle(
                color: message.isUser
                    ? Colors.white.withValues(alpha: 0.75)
                    : _AiAssistantState._muted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFFC46F7D),
        ),
      ),
    );
  }
}
