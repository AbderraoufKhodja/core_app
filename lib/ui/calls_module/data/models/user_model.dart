// export 'package:fibali/fibali_core/models/app_user.dart';

// class PreviousAppUser {
//   late String id;
//   late String name;
//   late String email;
//   late String avatar;
//   bool? busy;

//   PreviousAppUser({required this.name, required this.avatar});

//   PreviousAppUser.resister(
//       {required this.name,
//       required this.id,
//       required this.email,
//       required this.avatar,
//       required this.busy});

//   PreviousAppUser.fromFirestore(
//       {required Map<String, dynamic> map, required String uid}) {
//     id = uid;
//     name = map["name"];
//     email = map["email"];
//     avatar = map["avatar"];
//     busy = map["busy"];
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "uid": id,
//       "name": name,
//       "email": email,
//       "avatar": avatar,
//     };
//   }
// }

// // class UserFcmTokenModel {
// //   late String uid, token;

// //   UserFcmTokenModel({required this.uid, required this.token});

// //   UserFcmTokenModel.fromJson(Map<String, dynamic> json) {
// //     uid = json['uid'];
// //     token = json['token'];
// //   }

// //   Map<String, dynamic> toMap() {
// //     return {
// //       'uid': uid,
// //       'token': token,
// //     };
// //   }
// // }
