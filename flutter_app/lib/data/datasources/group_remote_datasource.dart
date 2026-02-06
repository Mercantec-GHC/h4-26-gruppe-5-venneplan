import '../../core/api/api_client.dart';
import '../../core/api/api_result.dart';

class GroupRemoteDataSource {
  final ApiClient apiClient;

  GroupRemoteDataSource({required this.apiClient});

  Future<ApiResult<List<String>>> fetchGroupNames() async {
    return await apiClient.get<List<String>>(
      '/Groups/get',
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => e['name'] as String).toList();
        }
        throw FormatException('Expected JSON array, got \\${json.runtimeType}');
      },
    );
  }
}
