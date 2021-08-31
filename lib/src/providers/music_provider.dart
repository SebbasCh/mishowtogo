import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mishowtogo/src/models/music.dart';

class MusicProvider {

  CollectionReference _ref;

  MusicProvider() {
    _ref = FirebaseFirestore.instance.collection('Musics');
  }

  Future<void> create(Music music) {
    String errorMessage;

    try {

      return _ref.doc(music.id).set(music.toJson());

    } catch(error) {
      errorMessage  = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<Music> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    if (document.exists) {
      Music music = Music.fromJson(document.data());
      return music;
    }
    return null;

  }

  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

}