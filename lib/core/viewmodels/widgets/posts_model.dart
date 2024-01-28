import 'package:mostlyrx/core/services/api.dart';

import '../base_model.dart';

class PostsModel extends BaseModel {
  PostsModel({
    required Api api,
  });

//  List<Post> posts;

  Future getPosts(int userId) async {
    setBusy(true);
//    posts = await _api.getPostsForUser(userId);
    setBusy(false);
  }
}
