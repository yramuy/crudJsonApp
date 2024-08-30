import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameVal = TextEditingController();
  List names = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dynamic List",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: const SizedBox(
                  child: Text("Name"),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
                  controller: nameVal,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    addItems();
                    FocusScope.of(context).unfocus();
                    showAlertMsg(context, 'Item Added Successfully!');
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text(
                    "Add",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: names.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(names[index].toString()),
                                ),
                                IconButton(
                                    onPressed: () {
                                      removeItem(names[index].toString());
                                      showAlertMsg(context,
                                          'Item Removed Successfully!');
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      size: 30,
                                      color: Colors.redAccent,
                                    ))
                              ],
                            ));
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addItems() {
    setState(() {
      names.add(nameVal.text);
    });
    nameVal.text = "";
  }

  void removeItem(value) {
    setState(() {
      names.remove(value);
    });
  }

  void showAlertMsg(BuildContext context, message) {
    final snackBar = SnackBar(
      content: Text(message.toString()),
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.fixed,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
