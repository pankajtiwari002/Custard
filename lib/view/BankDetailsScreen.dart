import 'package:custard_flutter/controllers/BankDetailsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/CustardButton.dart';

class BankDetailsScreen extends StatelessWidget {
  bool isUpi;
  BankDetailsScreen({super.key, required this.isUpi});

  final controller = Get.put(BankDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Bank Details",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Once you link your account, you’ll receive daily payouts to your linked bank account.',
                style: TextStyle(
                  color: Color(0xFF546881),
                  fontSize: 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Visibility(
                  visible: !isUpi,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Beneficiary name',
                        style: TextStyle(
                          color: Color(0xFF141414),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      MyTextField(
                        hintText: "Enter Benificiary Name",
                        controller: controller.benificiarNameController,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Bank Name',
                        style: TextStyle(
                          color: Color(0xFF141414),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Select Bank Name",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Account Number',
                        style: TextStyle(
                          color: Color(0xFF141414),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      MyTextField(
                        hintText: "Enter Account Number",
                        controller: controller.accountNumberController,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Bank IFSC',
                        style: TextStyle(
                          color: Color(0xFF141414),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      MyTextField(
                        hintText: "Enter Bank IFSC",
                        controller: controller.bankIFSCController,
                      ),
                    ],
                  ),
                ),
               Visibility(
                  visible: isUpi,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter UPI ID',
                        style: TextStyle(
                          color: Color(0xFF141414),
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      MyTextField(
                          hintText: "Paytm/Gpay/Bhim, etc",
                          controller: controller.upiController),
                    ],
                  ),
               ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: CustardButton(
              onPressed: () {
              },
              buttonType: ButtonType.POSITIVE,
              label: !isUpi
                  ? "Add Bank Account"
                  : "Add UPI ID",
              backgroundColor:
                  controller.allOk().value ? Color(0xFF7B61FF) : Colors.grey,
              textColor: Colors.white,
            ),
          ),
        );
  }
}

class MyTextField extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  MyTextField({super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
