import 'package:dio/dio.dart';
import 'package:example/home/user.dart';

class HomeService {
  final dio = Dio();

  Future<List<User>> getUsers() async {
    var res = await dio.get('https://jsonplaceholder.typicode.com/users');

    if (res.statusCode == 200) {
      return res.data
          .map((dynamic json) => User.fromJson(json))
          .toList()
          .cast<User>();
    }

    return null;
  }
}
