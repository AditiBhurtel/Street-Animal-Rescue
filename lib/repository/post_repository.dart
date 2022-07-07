import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_animal_rescue/modal/post_model.dart';

class PostRepository {
  final _firestore = FirebaseFirestore.instance;
  final postCollectionRef = "posts";

  Future<List<PostModel>> getAllPosts() async {
    return _firestore.collection(postCollectionRef).get().then((querySnap) {
      return querySnap.docs.map((docSnap) {
        final data = docSnap.data();
        data.putIfAbsent('id', () => docSnap.id);
        return PostModel.fromMap(data);
      }).toList();
    });
  }

  Stream<List<PostModel>> getAllStreamedPosts() {
    return _firestore.collection(postCollectionRef).snapshots().map((querySnap) {
      return querySnap.docs.map((docSnap) {
        final data = docSnap.data();
        data.putIfAbsent('id', () => docSnap.id);
        return PostModel.fromMap(data);
      }).toList();
    });
  }

  Future<void> storePost(PostModel postModel) async {
    await _firestore.collection(postCollectionRef).doc().set(postModel.toMap());
  }
}
