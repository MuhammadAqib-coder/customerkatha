import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/models/hisab_database.dart';
import 'package:flutter_doc_sqflite/util/user_profile.dart';
import 'package:flutter_doc_sqflite/widgets/home.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';

class DetailPage extends StatefulWidget {
  //final CustomerHisab hisab;
  // final String name;
  // final String desc;
  final UserProfile profile;
  final String appTitle;
  int? id;

  DetailPage({
    Key? key,
    required this.profile,
    required this.appTitle
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var helper = HisabDatabase.hisabDatabase;
  var flag = false;

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();

  final descController = TextEditingController();

  //var helper = DatabaseHelper.databaseHelper;
  @override
  Widget build(BuildContext context) {
    titleController.text = widget.profile.getName;
    descController.text = widget.profile.getDesc;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 54, 224, 247),
        shadowColor: Colors.transparent,
        title: Text(
          widget.appTitle,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
                // onSaved: (value) {
                //   _title = value;
                // },
                decoration: InputDecoration(
                    labelText: "name",
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 85, 201, 247),
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: descController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "description is required";
                  }
                  return null;
                },
                // onSaved: (value) {
                //   _description = value;
                // },
                decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.black),
                    labelText: "description",
                    filled: true,
                    fillColor: const Color.fromARGB(255, 85, 201, 247),
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 54, 224, 247)),
                      child: const Text(
                        "save",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        String name = titleController.text.toString().toLowerCase();
                        //int price = int.parse(descController.text);
                        String desc = descController.text;
                        //_formKey.currentState!.save();
                        // var list = transaction.values
                        //     .where((element) => element.name == name)
                        //     .toList();

                        await helper.userVerification(name).then((bool value) {
                          setState(() {
                            flag = value;
                          });
                        });
                        if (widget.profile.id == null) {
                          if (flag) {
                            helper.insertData(helper.userProfile,
                                UserProfile(name: name, description: desc));
                            titleController.text = "";
                            descController.text = "";
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Home()));
                          } else {
                            showSnackbar(context,
                                "with this name user is already exist");
                          }
                        } else {
                          helper.updateData(
                              helper.userProfile,
                              UserProfile(
                                  id: widget.profile.id,
                                  name: name,
                                  description: desc));
                          titleController.text = "";
                          descController.text = "";
                         // helper.updateUserDetail(widget.profile.id!, name);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Home()));
                        }
                        // if (!hisab.isInBox) {
                        //   if (list.isEmpty) {
                        //     transaction.add(
                        //         CustomerHisab(name: name, description: desc));
                        //     titleController.text = "";
                        //     descController.text = "";
                        //     Navigator.push(context,
                        //         MaterialPageRoute(builder: (_) => Home()));
                        //   } else {}
                        //   // var date = clock.now();
                        //   // String formattedDate =
                        //   //     DateFormat('dd-MM-yyyy').format(date);

                        //   // helper.insertHisab(
                        //   //     Hisab(title: title, description: desc));

                        // } else {
                        //   hisab.name = name;
                        //   hisab.description = desc;
                        //   //helper.updateHisab(instance);
                        //   hisab.save();
                        //   titleController.text = "";
                        //   descController.text = "";
                        //   Navigator.push(context,
                        //       MaterialPageRoute(builder: (_) => Home()));
                        //   // transaction.put(key, instance);
                        // }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 54, 224, 247)),
                      child: const Text(
                        "delete",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        if (widget.profile.id == null) {
                          showSnackbar(context, "no data is provided");
                        } else {
                          //hisab.delete();
                          _showalertDialog(context, widget.profile.id!);
                          // titleController.text = "";
                          // descController.text = "";
                          // Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showalertDialog(BuildContext context, int id) {
    var okbutton = TextButton(
      child: const Text("Cancle"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    var cancleBtn = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        //hisab.delete();
        helper.deleteData(helper.userProfile, id);
        Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
      },
    );
    var alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Are you want to delete this user?"),
      actions: [okbutton, cancleBtn],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  void showSnackbar(BuildContext context, String value) {
    var snackbar = SnackBar(
      content: Text(value),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
