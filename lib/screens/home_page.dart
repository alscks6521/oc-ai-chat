import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gptchat/consts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];

  Widget _buildButton(String label) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final String message = _textController.text;
    _textController.clear();

    setState(() {
      _messages.add('User: $message');
    });
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $OPENAI_API_KEY', // Use your actual API key
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content':
                '당신은 건강 관련 질문, 사용자의 현재 몸 상태, 소개 등에 대해 답변해야 합니다. 답변은 300자 내외로 간결하되, 어르신이 이해하기 쉽고 예의 바른 언어로 작성해 주세요. 존댓말을 사용하고, 어려운 의학 용어는 평이한 말로 풀어서 설명해 주세요. 만약 질문이 건강, 몸 상태, 소개 등과 관련이 없다면, "죄송하지만, 건강이나 몸 상태, 소개 등에 관해 더 자세히 말씀해 주시면 제가 잘 이해하고 도와드릴 수 있을 것 같습니다."라고 친절하게 답변해 주세요.',
          },
          {'role': 'user', 'content': message},
        ],
        'max_tokens': 300,
        'temperature': 0.7,
        'n': 1,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      final String reply = jsonResponse['choices'][0]['message']['content'];
      if (reply.contains('어르신, 건강이나 몸 상태, 소개 등에 관해 더 자세히 말씀해 주시면 제가 잘 이해하고 도와드릴 수 있을 것 같습니다.')) {
        setState(() {
          _messages.add(
              'GPT: 어르신, 건강이나 몸 상태, 소개 등에 관해 더 자세히 말씀해 주시면 제가 잘 이해하고 도와드릴 수 있을 것 같습니다. 어르신의 상태를 더 잘 파악하고 싶습니다.');
        });
      } else {
        setState(() {
          _messages.add('GPT: $reply');
        });
      }
    } else {
      debugPrint('Request failed with status: ${response.statusCode}.');
      debugPrint('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ai',
                style: TextStyle(
                  fontSize: 60,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // 여기에 배경색을 지정
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'Ai 도우미',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color.fromARGB(255, 69, 69, 69),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.3),
                      thickness: 1, // 선의 두께
                      height: 0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "제가 추천드리는 영양제입니다!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color.fromARGB(255, 69, 69, 69),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 158,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8), // 박스 간의 간격 조정
                          width: 83, // 박스의 너비 조정
                          height: 83, // 박스의 높이 조정
                          decoration: BoxDecoration(
                            color: Colors.white, // 박스의 배경색
                            borderRadius: BorderRadius.circular(20), // 박스의 모서리 둥글게 설정
                          ),
                          // 박스 안에 들어갈 내용 추가
                          child: Center(
                            child: Text(
                              'Box ${index + 1}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_messages[index]),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: const InputDecoration(
                              hintText: 'Enter a message',
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _sendMessage,
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
