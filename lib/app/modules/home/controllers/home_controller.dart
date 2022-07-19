import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toko_buku/app/data/book.dart';

class HomeController extends GetxController {
  CollectionReference ref = FirebaseFirestore.instance.collection('buku');
  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();

  final image = XFile("").obs;

  final formatter = NumberFormat.decimalPattern('en_us');

  String currency(double value) {
    return formatter.format(value);
  }

  Stream<List<Book>> readBook() => FirebaseFirestore.instance
      .collection('buku')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Book.fromJson(doc.data())).toList());
  @override
  void onInit() async {
    super.onInit();
    FlutterNativeSplash.remove();
  }

  Future getImage(bool gallery, XFile image) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
    }

    if (pickedFile != null) {
      image = pickedFile;
    }
  }

  Future<String> uploadFile(File image) async {
    final storageReference =
        FirebaseStorage.instance.ref().child('Menus/${image.path}');
    await storageReference.putFile(image);
    String returnURL = "";
    await storageReference.getDownloadURL().then(
      (fileURL) {
        returnURL = fileURL;
      },
    );
    return returnURL;
  }

  Future<void> updateBookWithImage(
    String id,
    String nama,
    int harga,
    String jenis,
    String deskripsi,
    File images,
  ) async {
    String imageURL = await uploadFile(images);
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "deskripsi": deskripsi,
      "images": imageURL,
    };
    refDoc.set(data);
  }

  Future<void> updateBook(String id, String nama, int harga, String jenis,
      String deskripsi, String image) async {
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "deskripsi": deskripsi,
      "images": image,
    };
    refDoc.set(data);
  }

  Future<void> deleteMenu(String id) async {
    final refDoc = ref.doc(id);
    refDoc.delete();
  }
}
