## gptchat  
디자인 틀 AI 부분구현  
https://xd.adobe.com/view/2f0734cb-7979-435c-bdba-be382d89fa05-7a54/screen/c2ce3b19-c832-4284-bbfe-904c5e009dab/specs/  

<img width="25%" alt="KakaoTalk_Photo_2024-04-21-17-01-24" src="https://github.com/alscks6521/ai-chat-service/assets/112923685/49d42930-e479-49a3-9e19-a0705a92bd7f">

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
**구현후 사용 예 이미지:**  

<img width="200" alt="4" src="https://github.com/alscks6521/ai-chat-service/assets/112923685/2d11d75a-a5e7-4fc8-acfe-43c292fc3904">
<img width="200" alt="3" src="https://github.com/alscks6521/ai-chat-service/assets/112923685/04349236-74df-4b8f-a2ae-5e05e981c500">
<img width="200" alt="2" src="https://github.com/alscks6521/ai-chat-service/assets/112923685/04aa74f4-1669-4758-a09a-c9f100c2ff9c">
<img width="200" alt="1" src="https://github.com/alscks6521/ai-chat-service/assets/112923685/7512cae1-7e6c-4774-9603-77d1bb4cdece">  

---

## 영양제 식품나라 API    
**건강기능식품 품목제조신고(원재료)**  
https://www.foodsafetykorea.go.kr/api/newDatasetDetail.do

