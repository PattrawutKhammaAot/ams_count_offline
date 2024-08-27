import 'package:count_offline/component/custombutton.dart';
import 'package:count_offline/component/textformfield/custom_input.dart';
import 'package:count_offline/extension/color_extension.dart';
import 'package:count_offline/model/department/departmentModel.dart';
import 'package:count_offline/model/location/locationModel.dart';
import 'package:count_offline/services/database/department_db.dart';
import 'package:count_offline/services/database/location_db.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CountPage extends StatefulWidget {
  @override
  State<CountPage> createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  List<LocationModel> location = [];
  List<DepartmentModel> department = [];

  String? plan;
  String? selectedLocation;
  String? selectedDepartment;
  String? selectedStatus;

  @override
  void initState() {
    LocationDB().getLocation().then((value) {
      location = value;
      setState(() {});
    });
    DepartmenDB().getDepartment().then((value) {
      department = value;
      setState(() {});
    });

    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments as String?;
      if (args != null) {
        setState(() {
          plan = args;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.contentColorBlue,
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Count Plan : ${plan}',
              style: TextStyle(color: Colors.white),
            )),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.contentColorBlue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    dropdownLocation(),
                    SizedBox(height: 10),
                    dropdownDepartment(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Card(
              shadowColor: Colors.black,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Custominput(labelText: "Barcode"),
                    SizedBox(height: 10),
                    Custominput(labelText: "Asset No"),
                    SizedBox(height: 10),
                    Custominput(labelText: "Name"),
                    SizedBox(height: 10),
                    Custominput(labelText: "Cost Center"),
                    SizedBox(height: 10),
                    Custominput(labelText: "Department"),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Custominput(labelText: "Qty")),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(child: Custominput(labelText: "Cap Date")),
                      ],
                    ),
                    SizedBox(height: 10),
                    dropdownStatus(),
                    SizedBox(height: 10),
                    Custominput(labelText: "Remark"),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Custominput(labelText: "Check")),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(child: Custominput(labelText: "Scan Date")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      icon: Icons.save,
                      text: "Save",
                      onPressed: () {},
                      color: AppColors.contentColorBlue,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: CustomButton(
                      icon: Icons.camera_enhance,
                      text: "Camera",
                      onPressed: () {},
                      color: AppColors.contentColorOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropdownLocation() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: DropdownButtonFormField2(
        isExpanded: true,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Select Location"),
            )),
        items: location
            .map((LocationModel item) => DropdownMenuItem<LocationModel>(
                  value: item,
                  child: Text(
                    "Location : ${item.location!}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedLocation,
        onChanged: (value) {
          selectedLocation = value.toString();
        },
        onSaved: (value) {
          selectedLocation = value.toString();
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black45,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget dropdownDepartment() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: DropdownButtonFormField2(
        isExpanded: true,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Select Department"),
            )),
        items: department
            .map((DepartmentModel item) => DropdownMenuItem<DepartmentModel>(
                  value: item,
                  child: Text(
                    "Department : ${item.department!}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedLocation,
        onChanged: (value) {
          selectedDepartment = value.toString();
        },
        onSaved: (value) {
          selectedDepartment = value.toString();
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black45,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget dropdownStatus() {
    List<String> itemStatus = [
      'ปกติ',
      'ทรัพย์สินชำรุด',
      'ส่งซ่อม',
      'รอตัดทรัพย์สิน/ขาย',
      'ใช้งานไม่ได้',
      'อื่นๆ',
      'ทรัพย์สินสุญหาย'
    ];

    return DropdownButtonFormField2(
      isExpanded: true,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Select Status"),
          )),
      items: itemStatus
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  " ${item}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      value: selectedLocation,
      onChanged: (value) {
        selectedStatus = value.toString();
      },
      onSaved: (value) {
        selectedStatus = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
