import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:clock/clock.dart';
import 'package:flutter_doc_sqflite/widgets/home.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';


class DetailPage extends StatelessWidget {
  final CustomerHisab hisab;
  final String appTitle;

  DetailPage({Key? key, required this.hisab, required this.appTitle})
      : super(key: key);

 
  final _formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var descController = TextEditingController();

  //var helper = DatabaseHelper.databaseHelper;

  var home = Home();

  var transaction = Hive.box<CustomerHisab>("hisab");
  //var _character = SingingCharacter.notCompleted;

  @override
  Widget build(BuildContext context) {
    titleController.text = hisab.name;
    descController.text = hisab.price.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title is required";
                  }
                  return null;
                },
                // onSaved: (value) {
                //   _title = value;
                // },
                decoration: InputDecoration(
                    labelText: "name",
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextFormField(
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
                    labelText: "price",
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text("save"),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        String name = titleController.text.toString();
                        int price = int.parse(descController.text);
                        //_formKey.currentState!.save();
                        if (!hisab.isInBox) {
                          var date = clock.now();
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(date);
                          transaction.add(CustomerHisab(
                              name: name, price: price, date: formattedDate));
                          // helper.insertHisab(
                          //     Hisab(title: title, description: desc));
                          titleController.text = "";
                          descController.text = "";
                          Navigator.pop(context);
                        } else {
                          hisab.name = name;
                          hisab.price = price;
                          //helper.updateHisab(instance);
                          hisab.save();
                          titleController.text = "";
                          descController.text = "";
                          Navigator.pop(context);
                          // transaction.put(key, instance);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Text("delete"),
                      onPressed: () {
                        if (!hisab.isInBox) {
                          var snackBar =
                              SnackBar(content: Text("No data is provided"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          hisab.delete();
                          titleController.text = "";
                          descController.text = "";
                          Navigator.pop(context);
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
}
