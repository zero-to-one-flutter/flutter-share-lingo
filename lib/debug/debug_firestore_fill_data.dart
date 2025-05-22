import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: use_build_context_synchronously

void removeDebugUsers(BuildContext context) async {
  try {
    final firestore = FirebaseFirestore.instance;

    for (int i = 1; i <= 30; i++) {
      final docId = 'user$i';
      final docRef = firestore.collection('users').doc(docId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.delete();
      }
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('🗑 테스트 유저들이 성공적으로 삭제되었습니다.')));
  } catch (e) {
    log('Error deleting test users: $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('❌ 삭제 중 오류가 발생했습니다.')));
  }
}

void removeDebugPosts(BuildContext context) async {
  try {
    final firestore = FirebaseFirestore.instance;

    for (int i = 1; i <= 30; i++) {
      final docId = 'post$i';
      final docRef = firestore.collection('posts').doc(docId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.delete();
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🗑 테스트 게시물들이 성공적으로 삭제되었습니다.')),
    );
  } catch (e) {
    log('🔥 Error deleting test posts: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ 게시물 삭제 중 오류 발생: ${e.toString()}')),
    );
  }
}


void addDebugUsersFromJson(BuildContext context) async {
  try {
    final jsonMap = jsonDecode(jsonUsersFirst) as Map<String, dynamic>;
    final usersMap = jsonMap['users'] as Map<String, dynamic>;

    final firestore = FirebaseFirestore.instance;

    for (final entry in usersMap.entries) {
      final userId = entry.key;
      final userData = entry.value as Map<String, dynamic>;
      await firestore.collection('users').doc(userId).set(userData);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Success: 테스트 유저들이 성공적으로 추가되었습니다.')),
    );
  } catch (e) {
    log('Error seeding users: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: 유저 추가 중 오류가 발생했습니다: ${e.toString()}')),
    );
  }
}

void addDebugPostsFromJson(BuildContext context) async {
  try {
    final jsonMap = jsonDecode(jsonPosts) as Map<String, dynamic>;
    final postsMap = jsonMap['posts'] as Map<String, dynamic>;

    final firestore = FirebaseFirestore.instance;

    for (final entry in postsMap.entries) {
      final postId = entry.key;
      final postData = Map<String, dynamic>.from(entry.value);

      // Convert ISO date strings to Firestore Timestamps
      postData['createdAt'] = Timestamp.fromDate(DateTime.parse(postData['createdAt']));
      postData['userBirthdate'] = Timestamp.fromDate(DateTime.parse(postData['userBirthdate']));

      await firestore.collection('posts').doc(postId).set(postData);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ 테스트 게시물이 성공적으로 추가되었습니다.')),
    );
  } catch (e) {
    log('🔥 Error seeding posts: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ 게시물 추가 중 오류 발생: ${e.toString()}')),
    );
  }
}


const jsonUsersFirst = '''
{
  "users": {
    "user1": {
      "name": "지훈",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 마포구 합정동",
      "bio": "영어 공부를 시작한 지 얼마 안 되었지만,\\n\\n매일 조금씩 나아지고 있어요.\\n대화로 배울 수 있다면 정말 기쁠 것 같아요.",
      "languageLearningGoal": "외국인 친구들과 깊은 대화를 나눌 수 있도록 어휘력을 늘리고 싶어요.",
      "hobbies": "영화 보는 걸 좋아하고 장르는 다양하게 봐요.\\n특히 로맨스랑 SF 장르를 좋아해요.",
      "email": "지훈0@test.com",
      "profileImage": "https://picsum.photos/seed/1/200/200",
      "createdAt": "2024-06-25T08:05:34.518194",
      "birthdate": "2001-05-28T08:05:34.518223"
    },
    "user2": {
      "name": "서연",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 마포구 합정동",
      "bio": "언어를 배우는 것은 새로운 문화를 이해하는 시작이라고 생각해요.\\n같이 이야기 나누며 서로 배워갔으면 좋겠어요.",
      "languageLearningGoal": "문법적인 정확성과 함께 자연스럽고 유창한 말하기 능력을 갖고 싶어요.",
      "hobbies": "음악을 듣거나 직접 연주하면서 힐링해요.\\n주로 피아노를 연주하고 클래식 음악을 좋아해요.",
      "email": "서연1@test.com",
      "profileImage": "https://picsum.photos/seed/2/200/200",
      "createdAt": "2024-05-30T08:05:34.518532",
      "birthdate": "1992-05-30T08:05:34.518562"
    },
    "user3": {
      "name": "민재",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 마포구 합정동",
      "bio": "영어 공부를 시작한 지 얼마 안 되었지만,\\n매일 조금씩 나아지고 있어요.\\n대화로 배울 수 있다면 정말 기쁠 것 같아요.",
      "languageLearningGoal": "문법적인 정확성과 함께 자연스럽고 유창한 말하기 능력을 갖고 싶어요.",
      "hobbies": "영화 보는 걸 좋아하고 장르는 다양하게 봐요.\\n특히 로맨스랑 SF 장르를 좋아해요.",
      "email": "민재2@test.com",
      "profileImage": "https://picsum.photos/seed/3/200/200",
      "createdAt": "2025-05-01T08:05:34.518806",
      "birthdate": "1998-05-29T08:05:34.518852"
    },
    "user4": {
      "name": "예진",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 마포구 합정동",
      "bio": "언어를 배우는 것은 새로운 문화를 이해하는 시작이라고 생각해요.\\n같이 이야기 나누며 서로 배워갔으면 좋겠어요.",
      "languageLearningGoal": "여행 중에도 자신 있게 말할 수 있도록 회화 실력을 향상시키는 것이 목표예요.",
      "hobbies": "책 읽기와 카페에서 시간 보내는 것을 좋아해요.\\n요즘은 에세이나 심리학 책을 즐겨 읽어요.",
      "email": "예진3@test.com",
      "profileImage": "https://picsum.photos/seed/4/200/200",
      "createdAt": "2024-09-14T08:05:34.518981",
      "birthdate": "2001-05-28T08:05:34.518998"
    },
    "user5": {
      "name": "태현",
      "nativeLanguage": "한국어",
      "targetLanguage": "영어",
      "district": "서울특별시 마포구 합정동",
      "bio": "안녕하세요! 저는 외국 친구들과 대화하며 언어를 배우는 것을 좋아합니다.\\n언제든지 즐겁게 소통할 수 있는 친구를 찾고 있어요.\\n영어로도 대화하려고 노력 중이에요.\\n잘 부탁드립니다!",
      "languageLearningGoal": "여행 중에도 자신 있게 말할 수 있도록 회화 실력을 향상시키는 것이 목표예요.",
      "hobbies": "음악을 듣거나 직접 연주하면서 힐링해요.\\n주로 피아노를 연주하고 클래식 음악을 좋아해요.",
      "email": "태현4@test.com",
      "profileImage": "https://picsum.photos/seed/5/200/200",
      "createdAt": "2024-12-07T08:05:34.519303",
      "birthdate": "1996-05-29T08:05:34.519322"
    },
    "user6": {
      "name": "수빈",
      "nativeLanguage": "한국어",
      "targetLanguage": "일본어",
      "district": "서울특별시 마포구 합정동",
      "bio": "영어뿐 아니라 다양한 문화와 사고방식을 배우는 것도 좋아해요.\\n새로운 사람들과 소통하며 성장하고 싶어요.",
      "languageLearningGoal": "실수하더라도 자신감 있게 말할 수 있는 용기를 키우는 게 목표예요.",
      "hobbies": "영화 보는 걸 좋아하고 장르는 다양하게 봐요.\\n특히 로맨스랑 SF 장르를 좋아해요.",
      "email": "수빈5@test.com",
      "profileImage": "https://picsum.photos/seed/6/200/200",
      "createdAt": "2024-10-02T08:05:34.519441",
      "birthdate": "1994-05-30T08:05:34.519450"
    },
    "user7": {
      "name": "하늘",
      "nativeLanguage": "한국어",
      "targetLanguage": "일본어",
      "district": "서울특별시 마포구 합정동",
      "bio": "일본 애니메이션을 자주 봐서 일본어에 관심이 많아졌어요.\\n일본어로 간단한 대화를 할 수 있도록 연습 중이에요.",
      "languageLearningGoal": "외국인 친구들과 깊은 대화를 나눌 수 있도록 어휘력을 늘리고 싶어요.",
      "hobbies": "산책과 사진 찍기를 즐겨요.\\n여유로운 분위기 속에서 사진을 찍으며 힐링해요.",
      "email": "하늘6@test.com",
      "profileImage": "https://picsum.photos/seed/7/200/200",
      "createdAt": "2024-07-12T08:05:34.519497",
      "birthdate": "1990-05-31T08:05:34.519509"
    },
    "user8": {
      "name": "지민",
      "nativeLanguage": "한국어",
      "targetLanguage": "일본어",
      "district": "서울특별시 마포구 합정동",
      "bio": "언어를 배우는 것은 새로운 문화를 이해하는 시작이라고 생각해요.\\n같이 이야기 나누며 서로 배워갔으면 좋겠어요.",
      "languageLearningGoal": "실수하더라도 자신감 있게 말할 수 있는 용기를 키우는 게 목표예요.",
      "hobbies": "책 읽기와 카페에서 시간 보내는 것을 좋아해요.\\n요즘은 에세이나 심리학 책을 즐겨 읽어요.",
      "email": "지민7@test.com",
      "profileImage": "https://picsum.photos/seed/8/200/200",
      "createdAt": "2024-07-28T08:05:34.519562",
      "birthdate": "1992-05-30T08:05:34.519573"
    },
    "user9": {
      "name": "은우",
      "nativeLanguage": "한국어",
      "targetLanguage": "일본어",
      "district": "서울특별시 마포구 합정동",
      "bio": "안녕하세요! 저는 외국 친구들과 대화하며 언어를 배우는 것을 좋아합니다.\\n언제든지 즐겁게 소통할 수 있는 친구를 찾고 있어요.\\n영어로도 대화하려고 노력 중이에요.\\n잘 부탁드립니다!",
      "languageLearningGoal": "문법적인 정확성과 함께 자연스럽고 유창한 말하기 능력을 갖고 싶어요.",
      "hobbies": "요리하는 걸 좋아해서 새로운 레시피를 시도하곤 해요.\\n특히 이탈리안 요리를 즐깁니다.",
      "email": "은우8@test.com",
      "profileImage": "https://picsum.photos/seed/9/200/200",
      "createdAt": "2025-01-27T08:05:34.519613",
      "birthdate": "1999-05-29T08:05:34.519619"
    },
    "user10": {
      "name": "유진",
      "nativeLanguage": "한국어",
      "targetLanguage": "일본어",
      "district": "서울특별시 마포구 합정동",
      "bio": "영어뿐 아니라 다양한 문화와 사고방식을 배우는 것도 좋아해요.\\n새로운 사람들과 소통하며 성장하고 싶어요.",
      "languageLearningGoal": "여행 중에도 자신 있게 말할 수 있도록 회화 실력을 향상시키는 것이 목표예요.",
      "hobbies": "책 읽기와 카페에서 시간 보내는 것을 좋아해요.\\n요즘은 에세이나 심리학 책을 즐겨 읽어요.",
      "email": "유진9@test.com",
      "profileImage": "https://picsum.photos/seed/10/200/200",
      "createdAt": "2024-07-03T08:05:34.519645",
      "birthdate": "2000-05-28T08:05:34.519650"
    },
    "user11": {
      "name": "Emily",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 용산구 이태원동",
      "bio": "Language exchange is the best way to learn!\\nI'm patient and open-minded, and I'd love to help you with English too.",
      "languageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
      "hobbies": "Going for walks and taking nature photos helps me unwind.\\nI often explore hidden spots around the city.",
      "email": "emily0@test.com",
      "profileImage": "https://picsum.photos/seed/11/200/200",
      "createdAt": "2025-05-15T08:05:34.519686",
      "birthdate": "2005-05-27T08:05:34.519707"
    },
    "user12": {
      "name": "James",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 용산구 이태원동",
      "bio": "I recently moved to Korea and would love to improve my Korean through conversation.\\nI'm especially interested in daily expressions and slang.\\nLet's talk casually!",
      "languageLearningGoal": "My goal is to understand Korean movies and dramas without subtitles.\\nI also want to sound more like a native speaker.",
      "hobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "email": "james1@test.com",
      "profileImage": "https://picsum.photos/seed/12/200/200",
      "createdAt": "2024-10-27T08:05:34.519784",
      "birthdate": "2005-05-27T08:05:34.519808"
    },
    "user13": {
      "name": "Sophia",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 용산구 이태원동",
      "bio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
      "languageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
      "hobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "email": "sophia2@test.com",
      "profileImage": "https://picsum.photos/seed/13/200/200",
      "createdAt": "2024-10-04T08:05:34.520108",
      "birthdate": "2005-05-27T08:05:34.520144"
    },
    "user14": {
      "name": "Daniel",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 용산구 이태원동",
      "bio": "Hi! I’m a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet’s help each other improve.",
      "languageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
      "hobbies": "I enjoy cooking various dishes at home.\\nTrying new recipes is my way of relaxing.",
      "email": "daniel3@test.com",
      "profileImage": "https://picsum.photos/seed/14/200/200",
      "createdAt": "2025-05-17T08:05:34.520225",
      "birthdate": "1999-05-29T08:05:34.520238"
    },
    "user15": {
      "name": "Olivia",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 용산구 이태원동",
      "bio": "Hi! I’m a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet’s help each other improve.",
      "languageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
      "hobbies": "I play guitar in my free time and listen to indie music.\\nMusic is my best companion during late nights.",
      "email": "olivia4@test.com",
      "profileImage": "https://picsum.photos/seed/15/200/200",
      "createdAt": "2025-03-05T08:05:34.520537",
      "birthdate": "1996-05-29T08:05:34.520559"
    },
    "user16": {
      "name": "Ethan",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 용산구 이태원동",
      "bio": "I recently moved to Korea and would love to improve my Korean through conversation.\\nI'm especially interested in daily expressions and slang.\\nLet's talk casually!",
      "languageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
      "hobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "email": "ethan5@test.com",
      "profileImage": "https://picsum.photos/seed/16/200/200",
      "createdAt": "2024-08-24T08:05:34.520671",
      "birthdate": "1999-05-29T08:05:34.520685"
    },
    "user17": {
      "name": "Chloe",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 용산구 이태원동",
      "bio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
      "languageLearningGoal": "My goal is to understand Korean movies and dramas without subtitles.\\nI also want to sound more like a native speaker.",
      "hobbies": "I love exploring new cafes and reading novels.\\nMy weekends are usually spent with a good book and coffee.",
      "email": "chloe6@test.com",
      "profileImage": "https://picsum.photos/seed/17/200/200",
      "createdAt": "2025-03-24T08:05:34.520749",
      "birthdate": "1995-05-30T08:05:34.520760"
    },
    "user18": {
      "name": "Liam",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 용산구 이태원동",
      "bio": "Language exchange is the best way to learn!\\nI'm patient and open-minded, and I'd love to help you with English too.",
      "languageLearningGoal": "My goal is to understand Korean movies and dramas without subtitles.\\nI also want to sound more like a native speaker.",
      "hobbies": "I play guitar in my free time and listen to indie music.\\nMusic is my best companion during late nights.",
      "email": "liam7@test.com",
      "profileImage": "https://picsum.photos/seed/18/200/200",
      "createdAt": "2024-12-30T08:05:34.520811",
      "birthdate": "2000-05-28T08:05:34.520822"
    },
    "user19": {
      "name": "Grace",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 용산구 이태원동",
      "bio": "Hi! I’m a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet’s help each other improve.",
      "languageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
      "hobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "email": "grace8@test.com",
      "profileImage": "https://picsum.photos/seed/19/200/200",
      "createdAt": "2025-03-07T08:05:34.520976",
      "birthdate": "1999-05-29T08:05:34.520996"
    },
    "user20": {
      "name": "Noah",
      "nativeLanguage": "영어",
      "targetLanguage": "한국어",
      "district": "서울특별시 용산구 이태원동",
      "bio": "Language exchange is the best way to learn!\\nI'm patient and open-minded, and I'd love to help you with English too.",
      "languageLearningGoal": "My goal is to understand Korean movies and dramas without subtitles.\\nI also want to sound more like a native speaker.",
      "hobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "email": "noah9@test.com",
      "profileImage": "https://picsum.photos/seed/20/200/200",
      "createdAt": "2025-02-05T08:05:34.521066",
      "birthdate": "2001-05-28T08:05:34.521073"
    },
    "user21": {
      "name": "Emily_0",
      "nativeLanguage": "영어",
      "targetLanguage": "스페인어",
      "district": "서울특별시 종로구 삼청동",
      "bio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
      "languageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
      "hobbies": "Going for walks and taking nature photos helps me unwind.\\nI often explore hidden spots around the city.",
      "email": "emily_0@test.com",
      "profileImage": "https://picsum.photos/seed/21/200/200",
      "createdAt": "2024-12-22T08:05:34.521244",
      "birthdate": "1992-05-30T08:05:34.521265"
    },
    "user22": {
      "name": "James_1",
      "nativeLanguage": "영어",
      "targetLanguage": "스페인어",
      "district": "서울특별시 종로구 삼청동",
      "bio": "한국어를 공부한 지 1년쯤 되었어요.\\n아직 많이 부족하지만, 함께 연습해요.\\n친절한 친구를 찾고 있어요.",
      "languageLearningGoal": "I'd love to be confident in making small talk in Korean.\\nI think casual conversations are the best practice.",
      "hobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "email": "james_1@test.com",
      "profileImage": "https://picsum.photos/seed/22/200/200",
      "createdAt": "2024-11-03T08:05:34.521348",
      "birthdate": "1998-05-29T08:05:34.521358"
    },
    "user23": {
      "name": "Sophia_2",
      "nativeLanguage": "영어",
      "targetLanguage": "스페인어",
      "district": "서울특별시 종로구 삼청동",
      "bio": "Hi! I’m a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet’s help each other improve.",
      "languageLearningGoal": "My goal is to make real friends through language exchange.\\nI believe it's the most fun and meaningful way to learn.",
      "hobbies": "Going for walks and taking nature photos helps me unwind.\\nI often explore hidden spots around the city.",
      "email": "sophia_2@test.com",
      "profileImage": "https://picsum.photos/seed/23/200/200",
      "createdAt": "2025-02-15T08:05:34.521556",
      "birthdate": "2001-05-28T08:05:34.521579"
    },
    "user24": {
      "name": "Daniel_3",
      "nativeLanguage": "영어",
      "targetLanguage": "아랍어",
      "district": "서울특별시 종로구 삼청동",
      "bio": "Hi! I’m a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet’s help each other improve.",
      "languageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
      "hobbies": "Going for walks and taking nature photos helps me unwind.\\nI often explore hidden spots around the city.",
      "email": "daniel_3@test.com",
      "profileImage": "https://picsum.photos/seed/24/200/200",
      "createdAt": "2024-07-29T08:05:34.521974",
      "birthdate": "2005-05-27T08:05:34.521991"
    },
    "user25": {
      "name": "Olivia_4",
      "nativeLanguage": "영어",
      "targetLanguage": "아랍어",
      "district": "서울특별시 종로구 삼청동",
      "bio": "Language exchange is the best way to learn!\\nI'm patient and open-minded, and I'd love to help you with English too.",
      "languageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
      "hobbies": "I enjoy cooking various dishes at home.\\nTrying new recipes is my way of relaxing.",
      "email": "olivia_4@test.com",
      "profileImage": "https://picsum.photos/seed/25/200/200",
      "createdAt": "2024-12-07T08:05:34.522054",
      "birthdate": "1993-05-30T08:05:34.522062"
    },
    "user26": {
      "name": "Ethan_5",
      "nativeLanguage": "영어",
      "targetLanguage": "독일어",
      "district": "서울특별시 종로구 삼청동",
      "bio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
      "languageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
      "hobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "email": "ethan_5@test.com",
      "profileImage": "https://picsum.photos/seed/26/200/200",
      "createdAt": "2024-10-17T08:05:34.522102",
      "birthdate": "2004-05-27T08:05:34.522109"
    },
    "user27": {
      "name": "Chloe_6",
      "nativeLanguage": "영어",
      "targetLanguage": "스페인어",
      "district": "서울특별시 종로구 삼청동",
      "bio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
      "languageLearningGoal": "I'd love to be confident in making small talk in Korean.\\nI think casual conversations are the best practice.",
      "hobbies": "I play guitar in my free time and listen to indie music.\\nMusic is my best companion during late nights.",
      "email": "chloe_6@test.com",
      "profileImage": "https://picsum.photos/seed/27/200/200",
      "createdAt": "2025-03-03T08:05:34.522149",
      "birthdate": "2004-05-27T08:05:34.522160"
    },
    "user28": {
      "name": "Liam_7",
      "nativeLanguage": "영어",
      "targetLanguage": "독일어",
      "district": "서울특별시 종로구 삼청동",
      "bio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
      "languageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
      "hobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "email": "liam_7@test.com",
      "profileImage": "https://picsum.photos/seed/28/200/200",
      "createdAt": "2025-04-17T08:05:34.522200",
      "birthdate": "2004-05-27T08:05:34.522209"
    },
    "user29": {
      "name": "Grace_8",
      "nativeLanguage": "영어",
      "targetLanguage": "중국어",
      "district": "서울특별시 종로구 삼청동",
      "bio": "한국어를 공부한 지 1년쯤 되었어요.\\n아직 많이 부족하지만, 함께 연습해요.\\n친절한 친구를 찾고 있어요.",
      "languageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
      "hobbies": "I enjoy cooking various dishes at home.\\nTrying new recipes is my way of relaxing.",
      "email": "grace_8@test.com",
      "profileImage": "https://picsum.photos/seed/29/200/200",
      "createdAt": "2025-01-23T08:05:34.522257",
      "birthdate": "1995-05-30T08:05:34.522262"
    },
    "user30": {
      "name": "Noah_9",
      "nativeLanguage": "영어",
      "targetLanguage": "중국어",
      "district": "서울특별시 종로구 삼청동",
      "bio": "Hi! I’m a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet’s help each other improve.",
      "languageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
      "hobbies": "I love exploring new cafes and reading novels.\\nMy weekends are usually spent with a good book and coffee.",
      "email": "noah_9@test.com",
      "profileImage": "https://picsum.photos/seed/30/200/200",
      "createdAt": "2025-05-04T08:05:34.522284",
      "birthdate": "1997-05-29T08:05:34.522292"
    }
  }
}

''';

const jsonPosts = '''
{
  "posts": {
    "post1": {
      "uid": "user1",
      "userName": "지훈",
      "userProfileImage": "https://picsum.photos/seed/b3f7/200/200",
      "userNativeLanguage": "한국어",
      "userTargetLanguage": "영어",
      "userDistrict": "서울특별시 마포구 합정동",
      "userBio": "영어 공부를 시작한 지 얼마 안 되었지만,\\n\\n매일 조금씩 나아지고 있어요.\\n대화로 배울 수 있다면 정말 기쁠 것 같아요.",
      "userBirthdate": "2001-05-28T08:05:34.518223",
      "userHobbies": "영화 보는 걸 좋아하고 장르는 다양하게 봐요.\\n특히 로맨스랑 SF 장르를 좋아해요.",
      "userLanguageLearningGoal": "외국인 친구들과 깊은 대화를 나눌 수 있도록 어휘력을 늘리고 싶어요.",
      "content": "어제 봤던 인터스텔라 정말 감동적이었어요 😭\\n\\nI watched Interstellar yesterday and it was so touching!\\n\\n영어로도 써보려고 노력중이에요. 맞나요?",
      "imageUrl": ["https://picsum.photos/seed/1/400/300"],
      "tags": ["영화", "인터스텔라", "영어공부", "movie"],
      "createdAt": "2025-05-20T14:30:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post2": {
      "uid": "user2",
      "userName": "서연",
      "userProfileImage": "https://picsum.photos/seed/6fd2/200/200",
      "userNativeLanguage": "한국어",
      "userTargetLanguage": "영어",
      "userDistrict": "서울특별시 마포구 합정동",
      "userBio": "언어를 배우는 것은 새로운 문화를 이해하는 시작이라고 생각해요.\\n같이 이야기 나누며 서로 배워갔으면 좋겠어요.",
      "userBirthdate": "1992-05-30T08:05:34.518562",
      "userHobbies": "음악을 듣거나 직접 연주하면서 힐링해요.\\n주로 피아노를 연주하고 클래식 음악을 좋아해요.",
      "userLanguageLearningGoal": "문법적인 정확성과 함께 자연스럽고 유창한 말하기 능력을 갖고 싶어요.",
      "content": "오늘 피아노로 쇼팽의 녹턴을 연주했어요 🎹\\n\\nToday I played Chopin's Nocturne on the piano.\\n\\n음악은 정말 국경이 없는 언어인 것 같아요. Music truly is a universal language!",
      "imageUrl": ["https://picsum.photos/seed/2/400/300"],
      "tags": ["피아노", "쇼팽", "음악", "piano", "chopin"],
      "createdAt": "2025-05-20T16:45:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post3": {
      "uid": "user3",
      "userName": "민재",
      "userProfileImage": "https://picsum.photos/seed/cc61/200/200",
      "userNativeLanguage": "한국어",
      "userTargetLanguage": "영어",
      "userDistrict": "서울특별시 마포구 합정동",
      "userBio": "영어 공부를 시작한 지 얼마 안 되었지만,\\n매일 조금씩 나아지고 있어요.\\n대화로 배울 수 있다면 정말 기쁠 것 같아요.",
      "userBirthdate": "1998-05-29T08:05:34.518852",
      "userHobbies": "영화 보는 걸 좋아하고 장르는 다양하게 봐요.\\n특히 로맨스랑 SF 장르를 좋아해요.",
      "userLanguageLearningGoal": "문법적인 정확성과 함께 자연스럽고 유창한 말하기 능력을 갖고 싶어요.",
      "content": "영어 공부 50일차! 📚\\n\\nDay 50 of learning English!\\n\\n매일 조금씩이지만 발전하는 게 느껴져요. I feel like I'm improving little by little each day.\\n\\n함께 공부할 친구 있나요?",
      "imageUrl": [],
      "tags": ["영어공부", "50일차", "English", "study"],
      "createdAt": "2025-05-20T10:15:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post4": {
      "uid": "user4",
      "userName": "예진",
      "userProfileImage": "https://picsum.photos/seed/92b3/200/200",
      "userNativeLanguage": "한국어",
      "userTargetLanguage": "영어",
      "userDistrict": "서울특별시 마포구 합정동",
      "userBio": "언어를 배우는 것은 새로운 문화를 이해하는 시작이라고 생각해요.\\n같이 이야기 나누며 서로 배워갔으면 좋겠어요.",
      "userBirthdate": "2001-05-28T08:05:34.518998",
      "userHobbies": "책 읽기와 카페에서 시간 보내는 것을 좋아해요.\\n요즘은 에세이나 심리학 책을 즐겨 읽어요.",
      "userLanguageLearningGoal": "여행 중에도 자신 있게 말할 수 있도록 회화 실력을 향상시키는 것이 목표예요.",
      "content": "합정동 새로 생긴 카페에서 책 읽는 중 ☕️\\n\\nReading a book at a new cafe in Hapjeong-dong.\\n\\n심리학 책이 생각보다 재밌어요! Psychology books are more interesting than I expected!",
      "imageUrl": ["https://picsum.photos/seed/4/400/300"],
      "tags": ["카페", "독서", "심리학", "cafe", "reading"],
      "createdAt": "2025-05-20T13:20:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post5": {
      "uid": "user5",
      "userName": "태현",
      "userProfileImage": "https://picsum.photos/seed/e055/200/200",
      "userNativeLanguage": "한국어",
      "userTargetLanguage": "영어",
      "userDistrict": "서울특별시 마포구 합정동",
      "userBio": "안녕하세요! 저는 외국 친구들과 대화하며 언어를 배우는 것을 좋아합니다.\\n언제든지 즐겁게 소통할 수 있는 친구를 찾고 있어요.\\n영어로도 대화하려고 노력 중이에요.\\n잘 부탁드립니다!",
      "userBirthdate": "1996-05-29T08:05:34.519322",
      "userHobbies": "음악을 듣거나 직접 연주하면서 힐링해요.\\n주로 피아노를 연주하고 클래식 음악을 좋아해요.",
      "userLanguageLearningGoal": "여행 중에도 자신 있게 말할 수 있도록 회화 실력을 향상시키는 것이 목표예요.",
      "content": "Hello everyone! 🌟\\n\\n오늘은 영어로 인사해볼게요. Today I'll try greeting in English.\\n\\n언어 교환 친구를 찾고 있어요. Looking for language exchange friends.\\n\\n함께 대화하며 배워요! Let's learn together through conversation!",
      "imageUrl": [],
      "tags": ["언어교환", "영어", "친구", "language_exchange", "friends"],
      "createdAt": "2025-05-20T11:30:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post6": {
      "uid": "user6",
      "userName": "수빈",
      "userProfileImage": "https://picsum.photos/seed/3db9/200/200",
      "userNativeLanguage": "한국어",
      "userTargetLanguage": "일본어",
      "userDistrict": "서울특별시 마포구 합정동",
      "userBio": "영어뿐 아니라 다양한 문화와 사고방식을 배우는 것도 좋아해요.\\n새로운 사람들과 소통하며 성장하고 싶어요.",
      "userBirthdate": "1994-05-30T08:05:34.519450",
      "userHobbies": "영화 보는 걸 좋아하고 장르는 다양하게 봐요.\\n특히 로맨스랑 SF 장르를 좋아해요.",
      "userLanguageLearningGoal": "실수하더라도 자신감 있게 말할 수 있는 용기를 키우는 게 목표예요.",
      "content": "일본 영화 '너의 이름은' 다시 봤어요 🎬\\n\\n日本の映画「君の名は」をもう一度見ました。\\n\\n매번 볼 때마다 새로운 감동이 있어요. 일본어 공부에도 도움이 되고요!",
      "imageUrl": ["https://picsum.photos/seed/6/400/300"],
      "tags": ["일본영화", "너의이름은", "일본어공부", "君の名は"],
      "createdAt": "2025-05-20T15:45:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post7": {
      "uid": "user7",
      "userName": "하늘",
      "userProfileImage": "https://picsum.photos/seed/9b2d/200/200",
      "userNativeLanguage": "한국어",
      "userTargetLanguage": "일본어",
      "userDistrict": "서울특별시 마포구 합정동",
      "userBio": "일본 애니메이션을 자주 봐서 일본어에 관심이 많아졌어요.\\n일본어로 간단한 대화를 할 수 있도록 연습 중이에요.",
      "userBirthdate": "1990-05-31T08:05:34.519509",
      "userHobbies": "산책과 사진 찍기를 즐겨요.\\n여유로운 분위기 속에서 사진을 찍으며 힐링해요.",
      "userLanguageLearningGoal": "외국인 친구들과 깊은 대화를 나눌 수 있도록 어휘력을 늘리고 싶어요.",
      "content": "한강에서 찍은 사진 📸\\n\\n今日は漢江で写真を撮りました。\\n\\n봄 날씨가 정말 좋네요! 일본어로 '좋은 날씨'는 いい天気 라고 하더라구요.",
      "imageUrl": ["https://picsum.photos/seed/7/400/300"],
      "tags": ["한강", "사진", "봄", "漢江", "写真"],
      "createdAt": "2025-05-20T17:10:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post8": {
      "uid": "user8",
      "userName": "지민",
      "userProfileImage": "https://picsum.photos/seed/24cb/200/200",
      "userNativeLanguage": "한국어",
      "userTargetLanguage": "일본어",
      "userDistrict": "서울특별시 마포구 합정동",
      "userBio": "언어를 배우는 것은 새로운 문화를 이해하는 시작이라고 생각해요.\\n같이 이야기 나누며 서로 배워갔으면 좋겠어요.",
      "userBirthdate": "1992-05-30T08:05:34.519573",
      "userHobbies": "책 읽기와 카페에서 시간 보내는 것을 좋아해요.\\n요즘은 에세이나 심리학 책을 즐겨 읽어요.",
      "userLanguageLearningGoal": "실수하더라도 자신감 있게 말할 수 있는 용기를 키우는 게 목표예요.",
      "content": "일본 소설을 원서로 읽어보려고 해요 📚\\n\\n日本の小説を原書で読んでみようと思います。\\n\\n무라카미 하루키부터 시작해볼까요? 村上春樹から始めてみようかな？",
      "imageUrl": [],
      "tags": ["일본소설", "무라카미하루키", "원서읽기", "村上春樹"],
      "createdAt": "2025-05-20T09:30:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post9": {
      "uid": "user9",
      "userName": "은우",
      "userProfileImage": "https://picsum.photos/seed/93ed/200/200",
      "userNativeLanguage": "한국어",
      "userTargetLanguage": "일본어",
      "userDistrict": "서울특별시 마포구 합정동",
      "userBio": "안녕하세요! 저는 외국 친구들과 대화하며 언어를 배우는 것을 좋아합니다.\\n언제든지 즐겁게 소통할 수 있는 친구를 찾고 있어요.\\n영어로도 대화하려고 노력 중이에요.\\n잘 부탁드립니다!",
      "userBirthdate": "1999-05-29T08:05:34.519619",
      "userHobbies": "요리하는 걸 좋아해서 새로운 레시피를 시도하곤 해요.\\n특히 이탈리안 요리를 즐깁니다.",
      "userLanguageLearningGoal": "문법적인 정확성과 함께 자연스럽고 유창한 말하기 능력을 갖고 싶어요.",
      "content": "오늘은 일본식 카레를 만들어봤어요! 🍛\\n\\n今日は日本のカレーを作ってみました！\\n\\n한국 카레와는 또 다른 맛이네요. 요리를 통해서도 문화를 배울 수 있어서 좋아요.",
      "imageUrl": ["https://picsum.photos/seed/9/400/300"],
      "tags": ["일본요리", "카레", "요리", "日本料理", "カレー"],
      "createdAt": "2025-05-20T18:20:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post10": {
      "uid": "user10",
      "userName": "유진",
      "userProfileImage": "https://picsum.photos/seed/286d/200/200",
      "userNativeLanguage": "한국어",
      "userTargetLanguage": "일본어",
      "userDistrict": "서울특별시 마포구 합정동",
      "userBio": "영어뿐 아니라 다양한 문화와 사고방식을 배우는 것도 좋아해요.\\n새로운 사람들과 소통하며 성장하고 싶어요.",
      "userBirthdate": "2000-05-28T08:05:34.519650",
      "userHobbies": "책 읽기와 카페에서 시간 보내는 것을 좋아해요.\\n요즘은 에세이나 심리학 책을 즐겨 읽어요.",
      "userLanguageLearningGoal": "여행 중에도 자신 있게 말할 수 있도록 회화 실력을 향상시키는 것이 목표예요.",
      "content": "일본 여행 계획 세우는 중이에요 ✈️\\n\\n日本旅行の計画を立てています。\\n\\n도쿄와 오사카 중에 어디가 좋을까요? 東京と大阪、どちらがいいでしょうか？",
      "imageUrl": [],
      "tags": ["일본여행", "도쿄", "오사카", "日本旅行", "東京", "大阪"],
      "createdAt": "2025-05-20T12:40:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post11": {
      "uid": "user11",
      "userName": "Emily",
      "userProfileImage": "https://picsum.photos/seed/6f98/200/200",
      "userNativeLanguage": "영어",
      "userTargetLanguage": "한국어",
      "userDistrict": "서울특별시 용산구 이태원동",
      "userBio": "Language exchange is the best way to learn!\\nI'm patient and open-minded, and I'd love to help you with English too.",
      "userBirthdate": "2005-05-27T08:05:34.519707",
      "userHobbies": "Going for walks and taking nature photos helps me unwind.\\nI often explore hidden spots around the city.",
      "userLanguageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
      "content": "Found this beautiful hidden park in Itaewon today! 🌸\\n\\n이태원에서 예쁜 숨겨진 공원을 찾았어요!\\n\\nKorean grammar is still challenging for me, but I'm trying my best. 한국어 문법이 아직 어려워요 😅",
      "imageUrl": ["https://picsum.photos/seed/11/400/300"],
      "tags": ["Itaewon", "park", "Korean", "이태원", "공원"],
      "createdAt": "2025-05-20T14:50:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post12": {
      "uid": "user12",
      "userName": "James",
      "userProfileImage": "https://picsum.photos/seed/ccf0/200/200",
      "userNativeLanguage": "영어",
      "userTargetLanguage": "한국어",
      "userDistrict": "서울특별시 용산구 이태원동",
      "userBio": "I recently moved to Korea and would love to improve my Korean through conversation.\\nI'm especially interested in daily expressions and slang.\\nLet's talk casually!",
      "userBirthdate": "2005-05-27T08:05:34.521808",
      "userHobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "userLanguageLearningGoal": "My goal is to understand Korean movies and dramas without subtitles.\\nI also want to sound more like a native speaker.",
      "content": "Just watched 기생충 without subtitles! 🎬\\n\\n자막 없이 기생충을 봤어요!\\n\\nI understood about 70% of it. Still need to work on my listening skills, but I'm getting there! 아직 듣기 연습이 더 필요해요.",
      "imageUrl": [],
      "tags": ["기생충", "Korean", "movie", "listening", "자막없이"],
      "createdAt": "2025-05-20T20:15:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post13": {
      "uid": "user13",
      "userName": "Sophia",
      "userProfileImage": "https://picsum.photos/seed/3bcb/200/200",
      "userNativeLanguage": "영어",
      "userTargetLanguage": "한국어",
      "userDistrict": "서울특별시 용산구 이태원동",
      "userBio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
      "userBirthdate": "2005-05-27T08:05:34.520144",
      "userHobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "userLanguageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
      "content": "Korean pronunciation is so tricky! 😅\\n\\n한국어 발음이 정말 어려워요!\\n\\nEspecially ㅓ and ㅗ sounds. Does anyone have tips for practicing these? 특히 ㅓ와 ㅗ 소리요. 연습하는 팁이 있나요?",
      "imageUrl": [],
      "tags": ["Korean", "pronunciation", "발음", "practice", "연습"],
      "createdAt": "2025-05-20T16:25:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post14": {
      "uid": "user14",
      "userName": "Daniel",
      "userProfileImage": "https://picsum.photos/seed/51e9/200/200",
      "userNativeLanguage": "영어",
      "userTargetLanguage": "한국어",
      "userDistrict": "서울특별시 용산구 이태원동",
      "userBio": "Hi! I'm a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet's help each other improve.",
      "userBirthdate": "1999-05-29T08:05:34.520238",
      "userHobbies": "I enjoy cooking various dishes at home.\\nTrying new recipes is my way of relaxing.",
      "userLanguageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
      "content": "Made 김치찌개 for the first time! 🍲\\n\\n처음으로 김치찌개를 만들었어요!\\n\\nAs a linguistics student, I find it fascinating how cooking terms vary between languages. 언어학 전공으로서 요리 용어가 언어마다 다른 게 흥미로워요!",
      "imageUrl": ["https://picsum.photos/seed/14/400/300"],
      "tags": ["김치찌개", "cooking", "linguistics", "요리", "언어학"],
      "createdAt": "2025-05-20T19:30:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post15": {
      "uid": "user15",
      "userName": "Olivia",
      "userProfileImage": "https://picsum.photos/seed/c090/200/200",
      "userNativeLanguage": "영어",
      "userTargetLanguage": "한국어",
      "userDistrict": "서울특별시 용산구 이태원동",
      "userBio": "Hi! I'm a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet's help each other improve.",
      "userBirthdate": "1996-05-29T08:05:34.520559",
      "userHobbies": "I play guitar in my free time and listen to indie music.\\nMusic is my best companion during late nights.",
      "userLanguageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
      "content": "Learning Korean through K-indie music! 🎸\\n\\n한국 인디 음악으로 한국어를 배우고 있어요!\\n\\nThe lyrics are so poetic and help me understand emotions in Korean. 가사가 정말 시적이고 한국어로 감정을 이해하는 데 도움이 돼요.",
      "imageUrl": [],
      "tags": ["K-indie", "music", "Korean", "인디음악", "가사"],
      "createdAt": "2025-05-20T21:40:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post16": {
      "uid": "user16",
      "userName": "Ethan",
      "userProfileImage": "https://picsum.photos/seed/7748/200/200",
      "userNativeLanguage": "영어",
      "userTargetLanguage": "한국어",
      "userDistrict": "서울특별시 용산구 이태원동",
      "userBio": "I recently moved to Korea and would love to improve my Korean through conversation.\\nI'm especially interested in daily expressions and slang.\\nLet's talk casually!",
      "userBirthdate": "1999-05-29T08:05:34.520685",
      "userHobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
      "userLanguageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
      "content": "Korean slang is so confusing but fun! 😄\\n\\n한국 슬랭이 정말 헷갈리지만 재미있어요!\\n\\nJust learned 대박! Does it really mean 'awesome' in all contexts? 대박이 모든 상황에서 '멋지다'는 뜻인가요?",
      "imageUrl": [],
      "tags": ["Korean", "slang", "대박", "language", "한국어"],
      "createdAt": "2025-05-20T15:10:00.000Z",
      "likeCount": 0,
      "commentCount": 0,
      "deleted": false
    },
    "post17": {
      "uid": "user17",
      "userName": "Chloe",
      "userProfileImage": "https://picsum.photos/seed/1855/200/200",
      "userNativeLanguage": "영어",
      "userTargetLanguage": "한국어",
      "userDistrict": "서울특별시 용산구 이태원동",
      "userBio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
      "userBirthdate": "1995-05-30T08:05:34.520760",
      "userHobbies": "I love exploring new cafes and reading novels.\\nMy weekends are usually spent with a good book and coffee.",
      "userLanguageLearningGoal": "My goal is to understand Korean movies and dramas without subtitles.\\nI also want to sound more like a native speaker.",
      "content": "Perfect cafe day in Hongdae! ☕️📚\\n\\n홍대에서 완벽한 카페 데이!\\n\\nReading a Korean novel while practicing my reading skills. The atmosphere here is so inspiring! 한국 소설을 읽으면서 독해 연습을 해요. 여기 분위기가 정말 영감을 줘요!",
      "imageUrl": ["https://picsum.photos/seed/17/400/300"],
      "tags": ["Hongdae", "cafe", "reading", "홍대", "카페", "독서"],
      "createdAt": "2025-05-20T17:50:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post18": {
     "uid": "user18",
     "userName": "Liam",
     "userProfileImage": "https://picsum.photos/seed/7b06/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "한국어",
     "userDistrict": "서울특별시 용산구 이태원동",
     "userBio": "Language exchange is the best way to learn!\\nI'm patient and open-minded, and I'd love to help you with English too.",
     "userBirthdate": "2000-05-28T08:05:34.520822",
     "userHobbies": "I play guitar in my free time and listen to indie music.\\nMusic is my best companion during late nights.",
     "userLanguageLearningGoal": "My goal is to understand Korean movies and dramas without subtitles.\\nI also want to sound more like a native speaker.",
     "content": "Late night guitar session 🎸\\n\\n늦은 밤 기타 연습!\\n\\nPlaying some Korean indie songs to practice pronunciation. Music really helps with language learning! 발음 연습을 위해 한국 인디 음악을 연주하고 있어요. 음악이 언어 학습에 정말 도움이 돼요!",
     "imageUrl": ["https://picsum.photos/seed/18/400/300"],
     "tags": ["guitar", "Korean", "indie", "기타", "음악", "연습"],
     "createdAt": "2025-05-20T23:15:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post19": {
     "uid": "user19",
     "userName": "Grace",
     "userProfileImage": "https://picsum.photos/seed/3bd9/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "한국어",
     "userDistrict": "서울특별시 용산구 이태원동",
     "userBio": "Hi! I'm a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet's help each other improve.",
     "userBirthdate": "1999-05-29T08:05:34.520996",
     "userHobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
     "userLanguageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
     "content": "Linguistics assignment on Korean grammar! 📝\\n\\n한국어 문법에 대한 언어학 과제!\\n\\nAnalyzing the difference between formal and informal speech levels. It's so complex but fascinating! 높임말과 반말의 차이를 분석하고 있어요. 복잡하지만 정말 흥미로워요!",
     "imageUrl": [],
     "tags": ["linguistics", "Korean", "grammar", "언어학", "문법", "높임말"],
     "createdAt": "2025-05-20T13:45:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post20": {
     "uid": "user20",
     "userName": "Noah",
     "userProfileImage": "https://picsum.photos/seed/a9b7/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "한국어",
     "userDistrict": "서울특별시 용산구 이태원동",
     "userBio": "Language exchange is the best way to learn!\\nI'm patient and open-minded, and I'd love to help you with English too.",
     "userBirthdate": "2001-05-28T08:05:34.521073",
     "userHobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
     "userLanguageLearningGoal": "My goal is to understand Korean movies and dramas without subtitles.\\nI also want to sound more like a native speaker.",
     "content": "Korean sci-fi recommendations? 🚀\\n\\n한국 SF 영화 추천해주세요!\\n\\nI love sci-fi movies and want to improve my Korean through them. Any good ones for language learners? SF 영화를 좋아하고 그걸로 한국어를 늘리고 싶어요. 언어 학습자에게 좋은 영화 있나요?",
     "imageUrl": [],
     "tags": ["Korean", "sci-fi", "movies", "한국영화", "SF", "추천"],
     "createdAt": "2025-05-20T22:30:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post21": {
     "uid": "user21",
     "userName": "Emily_0",
     "userProfileImage": "https://picsum.photos/seed/3bc9/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "스페인어",
     "userDistrict": "서울특별시 종로구 삼청동",
     "userBio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
     "userBirthdate": "1992-05-30T08:05:34.521265",
     "userHobbies": "Going for walks and taking nature photos helps me unwind.\\nI often explore hidden spots around the city.",
     "userLanguageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
     "content": "Learning Spanish while living in Korea! 🇪🇸\\n\\n한국에 살면서 스페인어를 배우고 있어요!\\n\\nIt's interesting how Korean grammar actually helps me understand Spanish verb conjugations better. 한국어 문법이 스페인어 동사 활용을 이해하는 데 도움이 돼요.",
     "imageUrl": ["https://picsum.photos/seed/21/400/300"],
     "tags": ["Spanish", "Korean", "language", "스페인어", "언어학습"],
     "createdAt": "2025-05-20T11:20:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post22": {
     "uid": "user22",
     "userName": "James_1",
     "userProfileImage": "https://picsum.photos/seed/1094/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "스페인어",
     "userDistrict": "서울특별시 종로구 삼청동",
     "userBio": "한국어를 공부한 지 1년쯤 되었어요.\\n아직 많이 부족하지만, 함께 연습해요.\\n친절한 친구를 찾고 있어요.",
     "userBirthdate": "1998-05-29T08:05:34.521358",
     "userHobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
     "userLanguageLearningGoal": "I'd love to be confident in making small talk in Korean.\\nI think casual conversations are the best practice.",
     "content": "¡Hola! 한국어와 스페인어 둘 다 배우고 있어요! 🇰🇷🇪🇸\\n\\nLearning both Korean and Spanish at the same time is challenging but fun!\\n\\n두 언어를 동시에 배우는 건 어렵지만 재미있어요. Sometimes I mix them up! 가끔 섞어서 말해요 😅",
     "imageUrl": [],
     "tags": ["Korean", "Spanish", "multilingual", "한국어", "스페인어", "다국어"],
     "createdAt": "2025-05-20T14:10:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post23": {
     "uid": "user23",
     "userName": "Sophia_2",
     "userProfileImage": "https://picsum.photos/seed/1afe/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "스페인어",
     "userDistrict": "서울특별시 종로구 삼청동",
     "userBio": "Hi! I'm a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet's help each other improve.",
     "userBirthdate": "2001-05-28T08:05:34.521579",
     "userHobbies": "Going for walks and taking nature photos helps me unwind.\\nI often explore hidden spots around the city.",
     "userLanguageLearningGoal": "My goal is to make real friends through language exchange.\\nI believe it's the most fun and meaningful way to learn.",
     "content": "Samcheong-dong photo walk today! 📸\\n\\n삼청동에서 사진 산책!\\n\\nTaking photos while practicing Spanish descriptions. Este lugar es muy hermoso - This place is very beautiful! 스페인어 묘사를 연습하면서 사진을 찍어요.",
     "imageUrl": ["https://picsum.photos/seed/23/400/300"],
     "tags": ["Samcheong-dong", "photography", "Spanish", "삼청동", "사진", "스페인어"],
     "createdAt": "2025-05-20T16:00:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post24": {
     "uid": "user24",
     "userName": "Daniel_3",
     "userProfileImage": "https://picsum.photos/seed/ac2f/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "아랍어",
     "userDistrict": "서울특별시 종로구 삼청동",
     "userBio": "Hi! I'm a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet's help each other improve.",
     "userBirthdate": "2005-05-27T08:05:34.521991",
     "userHobbies": "Going for walks and taking nature photos helps me unwind.\\nI often explore hidden spots around the city.",
     "userLanguageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
     "content": "Starting my Arabic learning journey! 🕌\\n\\n아랍어 학습 여정을 시작해요!\\n\\nThe script is beautiful but challenging. مرحبا (Marhaba) - Hello! 문자가 아름답지만 어려워요. As a linguistics student, I'm fascinated by right-to-left writing systems.",
     "imageUrl": ["https://picsum.photos/seed/24/400/300"],
     "tags": ["Arabic", "linguistics", "script", "아랍어", "언어학", "문자"],
     "createdAt": "2025-05-20T10:45:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post25": {
     "uid": "user25",
     "userName": "Olivia_4",
     "userProfileImage": "https://picsum.photos/seed/182c/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "아랍어",
     "userDistrict": "서울특별시 종로구 삼청동",
     "userBio": "Language exchange is the best way to learn!\\nI'm patient and open-minded, and I'd love to help you with English too.",
     "userBirthdate": "1993-05-30T08:05:34.522062",
     "userHobbies": "I enjoy cooking various dishes at home.\\nTrying new recipes is my way of relaxing.",
     "userLanguageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
     "content": "Made Middle Eastern cuisine today! 🥙\\n\\n오늘 중동 요리를 만들었어요!\\n\\nCooking helps me connect with Arabic culture. شكرا (Shukran) to my Arabic teacher for the recipe! 요리를 통해 아랍 문화와 연결되는 느낌이에요.",
     "imageUrl": ["https://picsum.photos/seed/25/400/300"],
     "tags": ["Arabic", "cooking", "culture", "아랍어", "요리", "문화"],
     "createdAt": "2025-05-20T18:45:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post26": {
     "uid": "user26",
     "userName": "Ethan_5",
     "userProfileImage": "https://picsum.photos/seed/9db4/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "독일어",
     "userDistrict": "서울특별시 종로구 삼청동",
     "userBio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
     "userBirthdate": "2004-05-27T08:05:34.522109",
     "userHobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
     "userLanguageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
     "content": "German grammar is no joke! 😅\\n\\n독일어 문법이 정말 어려워요!\\n\\nGuten Tag! Learning German while living in Korea gives me a unique perspective. 한국에 살면서 독일어를 배우니까 독특한 시각을 갖게 돼요. Ich lerne Deutsch! 🇩🇪",
     "imageUrl": [],
     "tags": ["German", "grammar", "독일어", "문법", "Deutsch"],
     "createdAt": "2025-05-20T12:15:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post27": {
     "uid": "user27",
     "userName": "Chloe_6",
     "userProfileImage": "https://picsum.photos/seed/2277/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "스페인어",
     "userDistrict": "서울특별시 종로구 삼청동",
     "userBio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
     "userBirthdate": "2004-05-27T08:05:34.522160",
     "userHobbies": "I play guitar in my free time and listen to indie music.\\nMusic is my best companion during late nights.",
     "userLanguageLearningGoal": "I'd love to be confident in making small talk in Korean.\\nI think casual conversations are the best practice.",
     "content": "Spanish guitar music is helping me learn! 🎸\\n\\n스페인 기타 음악이 학습에 도움이 돼요!\\n\\n¡Me encanta la música española! I love Spanish music! 음악을 통해 언어를 배우는 게 가장 재미있는 것 같아요. Music makes language learning so much more enjoyable!",
     "imageUrl": ["https://picsum.photos/seed/27/400/300"],
     "tags": ["Spanish", "guitar", "music", "스페인어", "기타", "음악"],
     "createdAt": "2025-05-20T20:45:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post28": {
     "uid": "user28",
     "userName": "Liam_7",
     "userProfileImage": "https://picsum.photos/seed/354d/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "독일어",
     "userDistrict": "서울특별시 종로구 삼청동",
     "userBio": "I'm currently learning Korean because I'm fascinated by the culture and language.\\nLooking for someone to practice with on a regular basis.\\nHopefully we can become friends too!",
     "userBirthdate": "2004-05-27T08:05:34.522209",
     "userHobbies": "Watching foreign films helps me learn languages and understand culture better.\\nSci-fi and dramas are my favorite genres.",
     "userLanguageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
     "content": "German sci-fi films are amazing! 🚀\\n\\n독일 SF 영화가 정말 훌륭해요!\\n\\nWatching Metropolis with German subtitles to practice. Wunderbar! 독일어 자막으로 메트로폴리스를 보면서 연습해요. The language of science fiction is so fascinating!",
     "imageUrl": [],
     "tags": ["German", "sci-fi", "films", "독일어", "SF", "영화"],
     "createdAt": "2025-05-20T19:20:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post29": {
     "uid": "user29",
     "userName": "Grace_8",
     "userProfileImage": "https://picsum.photos/seed/a909/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "중국어",
     "userDistrict": "서울특별시 종로구 삼청동",
     "userBio": "한국어를 공부한 지 1년쯤 되었어요.\\n아직 많이 부족하지만, 함께 연습해요.\\n친절한 친구를 찾고 있어요.",
     "userBirthdate": "1995-05-30T08:05:34.522262",
     "userHobbies": "I enjoy cooking various dishes at home.\\nTrying new recipes is my way of relaxing.",
     "userLanguageLearningGoal": "Expanding my vocabulary and using grammar correctly is what I'm working on now.",
     "content": "中文很难但是很有趣! Chinese is hard but interesting! 🇨🇳\\n\\n중국어가 어렵지만 흥미로워요!\\n\\nLearning Chinese characters while knowing Korean Hanja helps a lot. 한국어 한자를 알고 있으니까 중국어 문자 학습에 도움이 많이 돼요. 你好! (Nǐ hǎo!)",
     "imageUrl": ["https://picsum.photos/seed/29/400/300"],
     "tags": ["Chinese", "Hanja", "characters", "중국어", "한자", "문자"],
     "createdAt": "2025-05-20T15:30:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   },
   "post30": {
     "uid": "user30",
     "userName": "Noah_9",
     "userProfileImage": "https://picsum.photos/seed/9c0d/200/200",
     "userNativeLanguage": "영어",
     "userTargetLanguage": "중국어",
     "userDistrict": "서울특별시 종로구 삼청동",
     "userBio": "Hi! I'm a university student majoring in linguistics.\\nI love learning new languages and Korean is my focus right now.\\nLet's help each other improve.",
     "userBirthdate": "1997-05-29T08:05:34.522292",
     "userHobbies": "I love exploring new cafes and reading novels.\\nMy weekends are usually spent with a good book and coffee.",
     "userLanguageLearningGoal": "I want to be able to speak Korean naturally in everyday situations.\\nImproving my fluency and pronunciation is important to me.",
     "content": "Reading Chinese novels at a Samcheong-dong cafe! ☕️📚\\n\\n삼청동 카페에서 중국 소설을 읽고 있어요!\\n\\n我喜欢看中文小说! I love reading Chinese novels! Literature is such a great way to understand culture deeply. 문학을 통해 문화를 깊이 이해할 수 있어서 좋아요.",
     "imageUrl": ["https://picsum.photos/seed/30/400/300"],
     "tags": ["Chinese", "literature", "cafe", "중국어", "문학", "카페"],
     "createdAt": "2025-05-20T21:10:00.000Z",
     "likeCount": 0,
     "commentCount": 0,
     "deleted": false
   }
 }
}''';