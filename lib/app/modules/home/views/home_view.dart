import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko_buku/app/data/book.dart';
import 'package:toko_buku/app/routes/app_pages.dart';
import 'package:toko_buku/utils/rounded_textfield.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //search bar
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.snackbar(
                          "Belum Tersedia",
                          "Fitur ini belum tersedia",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 18.r,
                            color: Colors.grey[500],
                          ),
                          20.horizontalSpace,
                          Text(
                            "Search",
                            style: TextStyle(fontSize: 12.sp),
                          )
                        ],
                      ).paddingAll(10.r),
                    ),
                  ).paddingOnly(right: 10.w),
                ),
              ],
            ).paddingSymmetric(horizontal: 10.w, vertical: 10.h),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Buku Pilihan",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_bag,
                      color: Colors.amber,
                      size: 28.sp,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.PESANAN);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.amber,
                      size: 28.sp,
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.ADD_MENU);
                    },
                  ),
                ],
              ),
            ],
          ),
          10.verticalSpace,
          Flexible(
            child: StreamBuilder<List<Book>>(
                stream: controller.readBook(),
                builder: (context, snapshot) {
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.h,
                      crossAxisCount: 2,
                      childAspectRatio: .48,
                    ),
                    itemBuilder: (_, index) => GestureDetector(
                      onTap: () {
                        final image = XFile("").obs;
                        final namaController = TextEditingController();
                        final hargaController = TextEditingController();
                        TextEditingController deskripsiController =
                            TextEditingController();
                        TextEditingController kategoriController =
                            TextEditingController();
                        namaController.text = snapshot.data![index].nama;
                        hargaController.text =
                            snapshot.data![index].harga.toString();
                        deskripsiController.text =
                            snapshot.data![index].deskripsi;
                        kategoriController.text = snapshot.data![index].jenis;
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Obx(
                            () => Container(
                              height: 0.95.sh,
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(10),
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Edit Menu",
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w500)),
                                        IconButton(
                                            onPressed: () => Get.back(),
                                            icon: Icon(
                                              Icons.close,
                                              size: 16.sp,
                                              color: Colors.grey[500],
                                            )),
                                      ],
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          ScreenUtil().setWidth(10),
                                        ),
                                      ),
                                      child: image.value.path == ""
                                          ? Center(
                                              child: CachedNetworkImage(
                                                imageUrl: snapshot
                                                        .data?[index].images ??
                                                    "",
                                                width: 200.w,
                                                height: 300.h,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Center(
                                              child: Image.file(
                                                File(image.value.path),
                                                width: 200.w,
                                                height: 300.h,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                    10.verticalSpace,
                                    ElevatedButton(
                                        onPressed: () async {
                                          ImagePicker picker = ImagePicker();
                                          final pickedFile =
                                              await picker.pickImage(
                                                  source: ImageSource.gallery);
                                          if (pickedFile != null) {
                                            image.value = pickedFile;
                                          }
                                        },
                                        child: const Text("Edit Foto")),
                                    20.verticalSpace,
                                    Text(
                                      "Nama Menu",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(12),
                                      ),
                                    ),
                                    10.verticalSpace,
                                    RoundedInputField(
                                      textEditingController: namaController,
                                      hintText:
                                          snapshot.data?[index].nama.toString(),
                                    ),
                                    15.verticalSpace,
                                    Text(
                                      "Harga",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(12),
                                      ),
                                    ),
                                    10.verticalSpace,
                                    RoundedInputField(
                                      keyboardType: TextInputType.number,
                                      textEditingController: hargaController,
                                      hintText: snapshot.data?[index].harga
                                          .toString(),
                                    ),
                                    10.verticalSpace,
                                    Text(
                                      "Genre",
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(12),
                                      ),
                                    ),
                                    10.verticalSpace,
                                    RoundedInputField(
                                      textEditingController: kategoriController,
                                      hintText: snapshot.data?[index].harga
                                          .toString(),
                                    ),
                                    20.verticalSpace,
                                    TextFormField(
                                      controller: deskripsiController,
                                      decoration: const InputDecoration(
                                        labelText: "Deskripsi",
                                        border: OutlineInputBorder(),
                                      ),
                                      maxLines: 5,
                                    ),
                                    30.verticalSpace,
                                    Row(
                                      children: [
                                        Flexible(
                                          child: SizedBox(
                                            height: ScreenUtil().setHeight(40),
                                            width: 0.5.sw,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                await controller.deleteMenu(
                                                    snapshot.data![index].id);
                                                Get.back();
                                                Get.snackbar(
                                                  "Hapus Berhasil",
                                                  "Data Telah Berhasil Dihapus",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  backgroundColor: Colors.green,
                                                  colorText: Colors.white,
                                                );
                                              },
                                              child: const Text('Hapus Menu'),
                                            ),
                                          ),
                                        ),
                                        10.horizontalSpace,
                                        Flexible(
                                          child: SizedBox(
                                            height: ScreenUtil().setHeight(40),
                                            width: 0.5.sw,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.green,
                                              ),
                                              onPressed: () async {
                                                if (image
                                                    .value.path.isNotEmpty) {
                                                  await controller
                                                      .updateBookWithImage(
                                                    snapshot.data![index].id,
                                                    namaController.text,
                                                    int.parse(
                                                        hargaController.text),
                                                    kategoriController.text,
                                                    deskripsiController.text,
                                                    File(image.value.path),
                                                  );
                                                } else {
                                                  await controller.updateBook(
                                                    snapshot.data![index].id,
                                                    namaController.text,
                                                    int.parse(
                                                        hargaController.text),
                                                    kategoriController.text,
                                                    deskripsiController.text,
                                                    snapshot
                                                        .data![index].images,
                                                  );
                                                }
                                                Get.back();
                                                Get.snackbar(
                                                  "Edit Berhasil",
                                                  "Data Telah Berhasil Diedit",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  backgroundColor: Colors.green,
                                                  colorText: Colors.white,
                                                );
                                              },
                                              child: const Text('Simpan Menu'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ).paddingSymmetric(
                                    vertical: 10.h, horizontal: 20.w),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            ScreenUtil().setWidth(10),
                          ),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.h,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  ScreenUtil().setWidth(10),
                                ),
                                topRight: Radius.circular(
                                  ScreenUtil().setWidth(10),
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data?[index].images ?? "",
                                height: 300.h,
                                width: 200.w,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    snapshot.data?[index].nama ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Rp ${controller.currency(snapshot.data?[index].harga.toDouble() ?? 0)}",
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit_note_outlined,
                                        color: Colors.amber,
                                        size: 20.sp,
                                      ),
                                    ],
                                  ),
                                  5.verticalSpace,
                                  Text(
                                    "${snapshot.data?[index].jenis ?? 0}",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(12),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  10.verticalSpace,
                                ],
                              ).paddingOnly(top: 10.h, left: 10.w, right: 10.w),
                            ),
                          ],
                        ),
                      ),
                    ),
                    itemCount: snapshot.data?.length,
                  );
                }),
          ),
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }
}
