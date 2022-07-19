import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toko_buku/app/data/Orders.dart';

class PesananController extends GetxController {
  final orderRef = FirebaseFirestore.instance.collection('order');

  final formatter = NumberFormat.decimalPattern('en_us');

  String currency(double value) {
    return formatter.format(value);
  }

  Stream<List<Orders>> readOrder() => FirebaseFirestore.instance
      .collection('order')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Orders.fromJson(doc.data())).toList());

  Future<void> updateStatus(String id, String status) async {
    await orderRef.doc(id).update({
      'status': status,
    });
  }
}
