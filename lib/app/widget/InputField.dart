

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../appcolor.dart';


class InputField extends StatelessWidget {

  final String label;
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isenable;
  final bool isreadonly;
  final bool isMandatory;

  const InputField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.onTap,
    this.isLoading = false,
    required this.isenable  ,
    this.isreadonly = false  ,
    this.isMandatory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final width = Get.width;
    return  GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: Container(
        //  padding: EdgeInsets.symmetric(vertical: height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children:  [
              Text.rich(
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontSize: height * 0.018,
                    fontFamily: 'popsmibold',
                  ),
                  children: isMandatory
                      ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                      : [],
                ),
              ),
              /*Text(label,
                style: TextStyle(
                  fontSize: height * 0.018,
                 // fontWeight: FontWeight.w600,
                  fontFamily: 'popsmibold'
                ),
              ),*/
              Container(
                height:  height * 0.06,
                child: TextField(
                  enabled: isenable,
                  controller: controller,
                  readOnly: isreadonly,
                  style: TextStyle(fontSize: height * 0.017,color: AppColors.black,fontFamily: 'popregular'),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: hintText,
                      suffixIcon : Icon(Icons.arrow_drop_down),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:BorderSide(
                              color: Colors.grey
                          )
                      )
                  ),
                ),
              ),
            ] ,
          ),
        ),
      ),
    );
  }

}