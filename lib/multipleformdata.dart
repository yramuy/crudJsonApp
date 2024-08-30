import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultipleFormData extends StatefulWidget {
  const MultipleFormData({super.key});

  @override
  State<MultipleFormData> createState() => _MultipleFormDataState();
}

class _MultipleFormDataState extends State<MultipleFormData> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  List dataList = [];
  String buttonText = "Save";
  var dataID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text(
          "Multiple Dynamic List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text("Name"),
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(15),
                  //   color: Colors.grey
                  // ),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text("Email"),
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: emailController,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text("Phone Number"),
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(left: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isEmpty) {
                              showAlertDialog(context, "Name required");
                            } else if (emailController.text.isEmpty) {
                              showAlertDialog(context, "Email required");
                            } else if (numberController.text.isEmpty) {
                              showAlertDialog(context, "Phone Number required");
                            } else {
                              if (buttonText.toString() == "Save") {
                                addItem();
                                showSnackBar(
                                    context, "Item saved successfully.");
                              } else {
                                updateItem();
                                showSnackBar(
                                    context, "Item updated successfully.");
                              }
                            }
                            FocusScope.of(context).unfocus();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          child: Text(
                            buttonText.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 100),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              buttonText = "Save";
                              dataID = "";
                              nameController.text = "";
                              emailController.text = "";
                              numberController.text = "";
                            });
                          },
                          icon: const Icon(
                            Icons.restart_alt,
                            color: Colors.green,
                            size: 30,
                          )),
                    ),
                  ],
                ),
                Container(
                  width: 300,
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey),
                  child: const Text(
                    "Display Dynamic Data Table",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dataTextStyle: const TextStyle(color: Colors.white),
                      headingTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      columns: <DataColumn>[
                        const DataColumn(label: Text("Name")),
                        const DataColumn(label: Text("Email")),
                        const DataColumn(label: Text("Phone")),
                        const DataColumn(label: Text("Actions"))
                      ],
                      rows: List<DataRow>.generate(
                        dataList.length,
                        (index) => DataRow(cells: [
                          DataCell(Text(dataList[index]['name'])),
                          DataCell(Text(dataList[index]['email'])),
                          DataCell(Text(dataList[index]['phone'])),
                          DataCell(Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      buttonText = "Update";
                                    });

                                    editItem(
                                        dataList[index]['id'].toString(),
                                        dataList[index]['name'].toString(),
                                        dataList[index]['email'].toString(),
                                        dataList[index]['phone'].toString());
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.lightGreen,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    deleteItem(index);
                                    showSnackBar(
                                        context, "Item deleted successfully.");
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  )),
                            ],
                          ))
                        ]),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  var id = 1;
  void addItem() {
    setState(() {
      var dataObj = jsonEncode({
        "id": id,
        "name": nameController.text,
        "email": emailController.text,
        "phone": numberController.text
      });
      var obj = jsonDecode(dataObj);
      print("object" + obj.toString());
      dataList.add(obj);
      id++;
    });

    nameController.text = "";
    emailController.text = "";
    numberController.text = "";
  }

  void updateItem() {
    print("247 " + dataID);
    setState(() {
      var dataObj = jsonEncode({
        "id": dataID,
        "name": nameController.text,
        "email": emailController.text,
        "phone": numberController.text
      });
      var updateObj = jsonDecode(dataObj);

      for (var i = 0; i < dataList.length; i++) {
        if (dataList[i]['id'].toString() == dataID.toString()) {
          dataList[i]['name'] = updateObj['name'];
          dataList[i]['email'] = updateObj['email'];
          dataList[i]['phone'] = updateObj['phone'];
        }
      }

      // dataList[index] = updateObj;
      buttonText = "Save";
      dataID = "";
      nameController.text = "";
      emailController.text = "";
      numberController.text = "";
    });
  }

  void deleteItem(int index) {
    setState(() {
      dataList.removeAt(index);
    });
  }

  void editItem(id, name, email, phone) {
    print("270 : " + id);
    dataID = id;
    nameController.text = name.toString();
    emailController.text = email.toString();
    numberController.text = phone.toString();
  }

  void showAlertDialog(BuildContext context, error) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Alert"),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }

  void showSnackBar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text(msg.toString()),
      duration: Duration(seconds: 5),
      behavior: SnackBarBehavior.fixed,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
