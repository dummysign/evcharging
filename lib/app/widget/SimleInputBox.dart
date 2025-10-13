
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../appcolor.dart';


class SimleInputBox extends StatelessWidget{
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isLoading;
  final bool isediable;
  final IconData? icon;
  final bool isPhoneInput;

  const SimleInputBox({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isLoading = false,
    this.isediable = false,
    this.icon,
    this.isPhoneInput = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    return   Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height:  height * 0.025,
            child: Text(label,style:  TextStyle(fontFamily: 'popsmibold',fontSize: height * 0.018,color: AppColors.black)),
          ),
          SizedBox(height: height * 0.002,),
          Container(
            height:  height * 0.06,
            child: TextField(
              cursorColor: AppColors.app_color,
              controller: controller,
              readOnly: isediable,
              keyboardType: isPhoneInput ? TextInputType.phone : TextInputType.text,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: height * 0.018),
              decoration: InputDecoration(
                  hintText: hintText,
                  prefixIcon: icon != null ? Icon(icon) : null,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:AppColors.blue_color, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  /*border: OutlineInputBorder(
                    borderSide: BorderSide(color:AppColors.blue_color),
                    borderRadius: BorderRadius.circular(5),
                  ),*/
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:BorderSide(
                          color: Colors.grey
                      )
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}