import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/add_menu_controller.dart';

class AddMenuView extends GetView<AddMenuController> {
  const AddMenuView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Buku Baru'),
        elevation: 0,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              20.verticalSpace,
              controller.image.value.path != ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.file(
                        File(controller.image.value.path),
                        height: 300.h,
                        width: 200.w,
                        fit: BoxFit.cover,
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        await controller.getImage(true);
                      },
                      child: Container(
                        height: 300.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text("Tambah Foto"),
                        ),
                      ),
                    ),
              20.verticalSpace,
              Obx(
                () => Center(
                  child: controller.image.value.path != ""
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            controller.image.value = XFile("");
                          },
                        )
                      : const SizedBox(),
                ),
              ),
              20.verticalSpace,
              TextField(
                controller: controller.namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Buku',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              TextField(
                controller: controller.jenisController,
                decoration: const InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              TextField(
                controller: controller.hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
              ),
              10.verticalSpace,
              TextFormField(
                maxLines: 5,
                controller: controller.deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
              20.verticalSpace,
              GestureDetector(
                onTap: () async {
                  await controller.saveImages(
                      File(controller.image.value.path),
                      controller.namaController.text,
                      int.parse(controller.hargaController.text),
                      controller.jenisController.text,
                      controller.deskripsiController.text);
                  Get.back();
                  Get.snackbar("Berhasil", "Buku berhasil ditambahkan.",
                      backgroundColor: Colors.green, colorText: Colors.white);
                },
                child: Container(
                    width: 1.sw,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Text('Tambah Buku',
                            style: TextStyle(color: Colors.black)))),
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w, vertical: 10.h),
        ),
      ),
    );
  }
}
