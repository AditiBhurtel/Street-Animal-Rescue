import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:street_animal_rescue/modal/post_model.dart';
import 'package:street_animal_rescue/repository/post_repository.dart';
import 'package:street_animal_rescue/services/firbase_storage_services.dart';
import 'package:street_animal_rescue/services/print_services.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostState());

  final pr = PostRepository();
  final storageService = FirebaseStorageServices();

  ///todo add different field related to post here and in PostModel
  Future<void> sharePost({XFile? xFile, required String title}) async {
    BotToast.showLoading();
    emit(PostState());
    try {
      String? imageUrl;
      if (xFile != null) {
        final fileArray = await xFile.readAsBytes();
        final fileUrl = await storageService.uploadUint8ListImageAndGetUrl(
          fileArray,
          collection: 'posts',
          imageName: xFile.name,
        );
        imageUrl = fileUrl;
      }
      final nowData = DateTime.now();
      PostModel pm = PostModel(
        title: title,
        image: imageUrl,
        createdAt: nowData,
        updatedAt: nowData,
      );
      await pr.storePost(pm);
      BotToast.showText(text: 'Post shared successfully.');
      BotToast.closeAllLoading();
      emit(PostState(isAdded: true));
    } on FirebaseException catch (e) {
      sPrint('error on adding post: ${e.message}');
      BotToast.showText(text: '${e.message}');
      BotToast.closeAllLoading();
      emit(PostState());
    }
  }
}

class PostState {
  final bool isAdded;
  PostState({this.isAdded = false});
}
