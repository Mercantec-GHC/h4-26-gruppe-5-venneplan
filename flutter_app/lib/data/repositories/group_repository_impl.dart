import '../../domain/repositories/group_repository.dart';
import '../datasources/group_remote_datasource.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<String>> fetchGroupNames() async {
    final result = await remoteDataSource.fetchGroupNames();
    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.message),
    );
  }
}
