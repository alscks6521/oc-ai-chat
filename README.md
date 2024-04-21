# gptchat  
디자인 틀 AI 부분구현  
https://xd.adobe.com/view/2f0734cb-7979-435c-bdba-be382d89fa05-7a54/screen/c2ce3b19-c832-4284-bbfe-904c5e009dab/specs/  

<img width="200" alt="KakaoTalk_Photo_2024-04-21-17-01-24" src="https://github.com/alscks6521/ai-chat-service/assets/112923685/49d42930-e479-49a3-9e19-a0705a92bd7f">

```dart 
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
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': message},
        ],
        'max_tokens': 100,
        'temperature': 0.7,
        'n': 1,
      }),
    );
```
