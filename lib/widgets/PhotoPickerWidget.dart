// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:project_x/flutter_flow/flutter_flow_theme.dart';
//
// class photoPicker extends StatefulWidget {
//   final Function(XFile?)? onImageSelected; // New parameter
//   const photoPicker({Key? key, this.onImageSelected}) : super(key: key);
//
//   @override
//   State<photoPicker> createState() => _photoPickerState();
// }
//
// class _photoPickerState extends State<photoPicker> {
//
//   XFile? image;
//   final ImagePicker picker = ImagePicker();
//
//   //We can upload image from camera or from gallery based on parameter
//   Future getImage(ImageSource media) async {
//     var img = await picker.pickImage(source: media);
//
//     setState(() {
//       image = img;
//     });
//
//     if (widget.onImageSelected != null) {
//       widget.onImageSelected!(img);
//     }
//   }
//
//
//   //show popup dialog
//   void myAlert() {
//     showDialog(
//         context: this.context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             title: const Text('Please choose media to select'),
//             content: SizedBox(
//               height: MediaQuery.of(context).size.height / 6,
//               child: Column(
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(150, 40),
//                       backgroundColor: FlutterFlowTheme.of(context).primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     //if user click this button, user can upload image from gallery
//                     onPressed: () {
//                       Navigator.pop(context);
//                       getImage(ImageSource.gallery);
//                     },
//                     child: Row(
//                       children: const [
//                         Icon(Icons.image),
//                         Text('From Gallery'),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(150, 40),
//                       backgroundColor: FlutterFlowTheme.of(context).primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     //if user click this button. user can upload image from camera
//                     onPressed: () {
//                       Navigator.pop(context);
//                       getImage(ImageSource.camera);
//                     },
//                     child: Row(
//                       children: const [
//                         Icon(Icons.camera),
//                         Text('From Camera'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
