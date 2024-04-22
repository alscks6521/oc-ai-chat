import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gptchat/consts.dart';
import 'package:gptchat/screens/nutritional_dialog.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];
  final List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();

    _recomNutritional();
  }

  Future _recomNutritional() async {
    var url =
        Uri.parse('http://openapi.foodsafetykorea.go.kr/api/$FOOD_API/C003/json/1/10/PRDLST_NM=혈압');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['C003']['row'] != null) {
        List<dynamic> nutritionList = [];

        for (var item in data['C003']['row']) {
          nutritionList.add(item);
          // nutritionList.add(item['PRDLST_NM']);
          // debugPrint("${item['PRDLST_NM']}");
        }
        setState(() {
          _items.addAll(nutritionList);
        });
      } else {
        debugPrint("관련 영양제 정보가 없습니다.");
      }
    } else {
      debugPrint('영양제 정보를 불러오는데 실패했습니다.');
    }
  }

  Future<void> _sendMessage() async {
    final String message = _textController.text;
    _textController.clear();

    setState(() {
      _messages.add('본인: $message');
    });
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $OPENAI_API', // Use your actual API key
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
              'AI: 어르신, 건강이나 몸 상태, 소개 등에 관해 더 자세히 말씀해 주시면 제가 잘 이해하고 도와드릴 수 있을 것 같습니다. 어르신의 상태를 더 잘 파악하고 싶습니다.');
        });
      } else {
        setState(() {
          _messages.add('AI: $reply');
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
                      itemCount: _items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return NutritionalContainer(nutritionalItem: _items[index]);
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
                              hintText: 'AI에게 건강 상태를 질문해보세요!',
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _sendMessage,
                          child: const Text('전송'),
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
