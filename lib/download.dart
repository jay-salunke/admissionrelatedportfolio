// import 'package:path/path.dart';
//
// class DownloadingFiles {
//
//   static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
//       Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
//
//   static Future<List<FirebaseFile> listAll() async {
//     final ref = FirebaseStorage.instance.ref();
//     final result = await ref.listAll();
//     final urls = await _getDownloadLinks(result.items);
//
//     return urls.asMap().map((url, index){
//       final ref = result.items[index];
//       final name = ref.getName();
//       final file = FirebaseFile(ref:ref,name:name,url:url)
//     });
//   }
// }