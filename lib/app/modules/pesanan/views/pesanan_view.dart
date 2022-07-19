import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:toko_buku/app/data/Orders.dart';

import '../controllers/pesanan_controller.dart';

class PesananView extends GetView<PesananController> {
  const PesananView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Pesanan'),
        elevation: 0,
      ),
      body: StreamBuilder<List<Orders>>(
        stream: controller.readOrder(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) {
                          return Container(
                            height: 0.8.sh,
                            width: 1.sw,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  height: 50.h,
                                  width: 1.sw,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Colors.amberAccent,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.r),
                                      topRight: Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Text(
                                    "Order Id : ${snapshot.data?[index].id}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 30.w),
                                  height: 80.h,
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border.symmetric(
                                      horizontal: BorderSide(
                                        color: Colors.grey[400]!,
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      10.verticalSpace,
                                      Text(
                                        "Nama Pemesan",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      10.verticalSpace,
                                      Text(
                                        "${snapshot.data?[index].nama}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 0.55.sh,
                                  width: 1.sw,
                                  child: GroupedListView<OrderList, String>(
                                    groupHeaderBuilder: (group) {
                                      return Container(
                                        height: 30.h,
                                        width: 1.sw,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Text(
                                          group.type,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      );
                                    },
                                    elements: snapshot.data![index].data,
                                    groupBy: (element) => element.type,
                                    groupSeparatorBuilder:
                                        (String groupByValue) =>
                                            Text(groupByValue),
                                    itemBuilder: (context, OrderList element) =>
                                        ListTile(
                                      title: Text(element.title),
                                      subtitle: Text(
                                          "${element.quantity.toString()} Item"),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          element.image,
                                          height: 50.h,
                                          width: 50.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ).marginSymmetric(vertical: 10.h),
                                    useStickyGroupSeparators: true, // optional
                                    floatingHeader: true, // optional
                                    order: GroupedListOrder.ASC, // optional
                                  ).paddingOnly(
                                      top: 10.h, left: 20.w, right: 20.w),
                                ),
                                20.verticalSpace,
                                if (snapshot.data![index].status == "menunggu")
                                  GestureDetector(
                                    onTap: () async {
                                      await controller.updateStatus(
                                        snapshot.data![index].id,
                                        "selesai",
                                      );
                                      Get.back();
                                      Get.snackbar("Selesai",
                                          "Pesanan telah selesai diproses.",
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.h,
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: const Text(
                                        "Selesaikan Pesanan",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ).paddingSymmetric(horizontal: 30.r),
                                  )
                                else
                                  Container(
                                    alignment: Alignment.center,
                                    height: 50.h,
                                    width: 1.sw,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: const Text(
                                      "Pesanan Selesai",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ).paddingSymmetric(horizontal: 30.r),
                              ],
                            ),
                          );
                        });
                  },
                  title: Text(
                    snapshot.data?[index].nama ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${snapshot.data?[index].data.length ?? ""} Item(s)"),
                      Text(
                        snapshot.data?[index].status ?? "",
                        style: TextStyle(
                            color: snapshot.data?[index].status == "menunggu"
                                ? Colors.red
                                : Colors.green),
                      ),
                    ],
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      snapshot.data?[index].data.first.image ?? "",
                      height: 50.h,
                      width: 50.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  trailing: Text(
                    "Rp ${controller.currency(snapshot.data?[index].total ?? 0)}",
                  ),
                );
              },
            ).paddingSymmetric(horizontal: 20.w, vertical: 10.h);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
