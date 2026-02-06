import '../../core/api/api_result.dart';
import '../entities/chat_entity.dart';

abstract class ChatRepository {
  Future<ApiResult<List<ChatEntity>>> getChatData();

  Future<ApiResult<List<ChatEntity>>> getCurrentChatMessages();

  Future<ApiResult<List<ChatEntity>>> loadMoreChatMessages();

  Future<ApiResult<List<ChatEntity>>> refreshChatData();
}