import 'package:mostlyrx/core/services/api.dart';
import 'package:mostlyrx/core/viewmodels/base_model.dart';

class CommentsModel extends BaseModel {
  CommentsModel({
    required Api api,
  });

//  List<Comment> comments;

  Future fetchComments(int postId) async {
    setBusy(true);
//    comments = await _api.getCommentsForPost(postId);
    setBusy(false);
  }
}
