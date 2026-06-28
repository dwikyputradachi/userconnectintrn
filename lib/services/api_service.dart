import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio dio = Dio();

  Future<List<UserModel>> getUsers() async {
    final response = await dio.get(
      'https://jsonplaceholder.typicode.com/users',
    );

    final List data = response.data;

    return data
      .map((user) => UserModel.fromJson(user))
      .toList();
  }

  Future<List<PostModel>> getPostsByUser(int userId) async {
    final response = await dio.get(
      'https://jsonplaceholder.typicode.com/posts?userId=$userId',
    );

    final List data = response.data;

    return data
      .map((post) => PostModel.fromJson(post))
      .toList();
  }
  
  Future<PostModel> createPost({
    required int userId, 
    required String title, 
    required String body,
  }) async {
    final response = await dio.post(
      'https://jsonplaceholder.typicode.com/posts',
      data: {
        'userId': userId,
        'title': title,
        'body': body,
      },
    );
    
    debugPrint("CREATE POST STATUS: ${response.statusCode}"); 
    
    if (response.statusCode == 201) {
      return PostModel.fromJson(response.data);
    } else {
      throw Exception('Failed to create post');
    }
  }

  Future<PostModel> updatePost({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) async {
    final response = await dio.put(
      'https://jsonplaceholder.typicode.com/posts/$id',
      data: {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
      },
    );

    debugPrint("UPDATE POST STATUS: ${response.statusCode}");

    if (response.statusCode == 200) {
      return PostModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update post');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await dio.delete(
      'https://jsonplaceholder.typicode.com/posts/$id',
    );

    debugPrint("DELETE POST STATUS: ${response.statusCode}");

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete post');
    }
  }
}
