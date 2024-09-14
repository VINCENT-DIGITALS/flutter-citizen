

// Future uploadToStorage() async {
// try {
//   final DateTime now = DateTime.now();
//   final int millSeconds = now.millisecondsSinceEpoch;
//   final String month = now.month.toString();
//   final String date = now.day.toString();
//   final String storageId = (millSeconds.toString() + uid);
//   final String today = ('$month-$date'); 

//  final file =  await ImagePicker.pickVideo(source: ImageSource.gallery);

//   StorageReference ref = FirebaseStorage.instance.ref().child("video").child(today).child(storageId);
//   StorageUploadTask uploadTask = ref.putFile(file, StorageMetadata(contentType: 'video/mp4')); <- this content type does the trick

//   Uri downloadUrl = (await uploadTask.future).downloadUrl;

//     final String url = downloadUrl.toString();

//  print(url);

// } catch (error) {
//   print(error);
//   }

// }