import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_detail_list_hive.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class CustomerDetailList extends StatefulWidget {
  final CustomerHisab instance;
  const CustomerDetailList({Key? key, required this.instance})
      : super(key: key);

  @override
  _CustomerDetailListState createState() => _CustomerDetailListState();
}

class _CustomerDetailListState extends State<CustomerDetailList> {
  var price = TextEditingController();
  var hisabList = Hive.box<CustomerDetailListHive>("hisabList");
  var _fromKey = GlobalKey<FormState>();
  var total;
  @override
  Widget build(BuildContext context) {
    var list = hisabList.values
        .where((hisab) => hisab.name == widget.instance.name)
        .toList();
    total = 0;
    list.forEach((element) {
      total += element.price;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.instance.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Form(
                    key: _fromKey,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [ThousandsFormatter()],
                      controller: price,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Price is required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "price",
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  child: Text("save"),
                  onPressed: () {
                    if (_fromKey.currentState!.validate()) {
                      int value = int.parse(price.text);
                      var date = DateTime.now();
                      String dateFormate = DateFormat("dd-MM-yyy").format(date);
                      hisabList.add(CustomerDetailListHive(
                          price: value,
                          date: dateFormate,
                          name: widget.instance.name));
                      price.text = "";
                      setState(() {});
                    } else {
                      return;
                    }
                  },
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Text("No data found"),
                      )
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text("Rs ${list[index].price}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
                              subtitle: Text(list[index].date),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  hisabList.deleteAt(index);
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      )),
            SizedBox(
              height: 10.0,
            ),
           RichText(
             text: TextSpan(
               text: "Total Rs ",
               style: TextStyle(color: Colors.black),
               children: [
                 TextSpan(text: "${ total}",
                 style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0))
               ]
             ),
           )
          ],
        ),
      ),
    );
  }
}
