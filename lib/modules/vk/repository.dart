import 'package:syazanou/modules/app/base_repository.dart';

class VkRepository extends BaseRepository {
  Future<dynamic> getProfileInfo() async {
    return await client.get('/method/account.getProfileInfo');
  }

  Future<dynamic> checkToken({
    required String accessToken,
  }) async {
    return await client.get('/method/secure.checkToken', queryParameters: {
      'access_token': accessToken,
    });
  }

  Future<dynamic> getUser({
    required int userId,
  }) async {
    return await client.get('/method/users.get', queryParameters: {
      'user_ids': userId,
      'fields': 'has_photo,photo_100',
    });
  }

  Future<dynamic> getNewsfeed({
    int pageSize = 15,
    String? startFrom,
  }) async {
    return await client.get('/method/newsfeed.get', queryParameters: {
      'count': pageSize,
      'start_from': startFrom,
      'filters': 'post',
    });
  }

  Future<dynamic> likeAdd({
    required String type,
    required int itemId,
    int? ownerId,
  }) async {
    return await client.get('/method/likes.add', queryParameters: {
      'type': type,
      'item_id': itemId,
      'owner_id': ownerId,
    });
  }

  Future<dynamic> likeDelete({
    required String type,
    required int itemId,
    int? ownerId,
  }) async {
    return await client.get('/method/likes.delete', queryParameters: {
      'type': type,
      'item_id': itemId,
      'owner_id': ownerId,
    });
  }
}
