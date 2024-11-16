import 'package:http/http.dart' as http;

final class ApiService {
  static Future<http.Response?> getMovies(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NTFhMzIxOTNhMDVmNDNlZDZmZTQ1MjRhNWE2NGVjMyIsInN1YiI6IjYzMTU4MGJlYTQwMmMxMDA3YWJmZjFmZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.gJxsq2R64Mb8wWmwsYnfSKC3JrehZVLxzE_Ou-Jv0oY',
        },
      );
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
