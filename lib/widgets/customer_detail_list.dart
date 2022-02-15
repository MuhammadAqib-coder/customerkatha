import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_detail_list_hive.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/models/variable_value_hive.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class CustomerDetailList extends StatefulWidget {
  final CustomerHisab instance;
  //final PriceProvider provider;
  const CustomerDetailList({Key? key, required this.instance})
      : super(key: key);

  @override
  _CustomerDetailListState createState() => _CustomerDetailListState();
}

class _CustomerDetailListState extends State<CustomerDetailList> {
  var price = TextEditingController();
  var advance = 0;
  var advanceResult = 0;
  var advanceControler = TextEditingController();
  var hisabList = Hive.box<CustomerDetailListHive>("hisabList");
  var varaibles = Hive.box<VariableValue>("varaibles");
  final _priceKey = GlobalKey<FormState>();
  final _loadKey = GlobalKey<FormState>();
  late VariableValue varaibleInstance;
  late final Map<dynamic, VariableValue> map;
  //final provider = Provider.of<PriceProvider>(_);

  int total = 0;

  @override
  void initState() {
    super.initState();
    // row = varaibles.values
    //     .where((element) => element.name == widget.instance.name)
    //     .toList();
    map = varaibles.toMap();
    if (map.isNotEmpty) {
      map.forEach((key, value) {
        if (value.name == widget.instance.name) {
          varaibleInstance = value;
          total = value.total;
          advance = value.advance;
        } else {
          varaibleInstance = VariableValue(name: "", total: 0, advance: 0);
        }
      });
    } else {
      varaibleInstance = VariableValue(name: "", total: 0, advance: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    var list = hisabList.values
        .where((hisab) => hisab.name == widget.instance.name)
        .toList();

    // total = advanceResult;
    // list.forEach((element) {
    //   total += element.price;
    // });
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
                    key: _priceKey,
                    child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "price is required";
                          } else {
                            return null;
                          }
                        },
                        controller: advanceControler,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Price from cunstomer",
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)))),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  child: const Text("submit"),
                  onPressed: () {
                    if (_priceKey.currentState!.validate()) {
                      advanceResult = int.parse(advanceControler.text);
                      String price = advanceControler.text;
                      advanceControler.text = "";
                      if (total > 0) {
                        total = total - advanceResult;
                        if (total < 0) {
                          advance = total.abs();
                          total = 0;
                          setState(() {});
                        } else {
                          setState(() {});
                        }
                      } else {
                        advance += advanceResult;
                        setState(() {});
                      }
                      var date = DateTime.now();
                      String dateFormat = DateFormat('dd-MM-yyyy').format(date);
                      hisabList.add(CustomerDetailListHive(
                          price: "$price had give to me",
                          date: dateFormat,
                          name: widget.instance.name));
                      setState(() {});
                    } else {
                      return;
                    }
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Form(
                    key: _loadKey,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      //inputFormatters: [ThousandsFormatter()],
                      controller: price,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Price is required";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Load price",
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                SizedBox(
                  height: 35,
                  width: 75.0,
                  child: ElevatedButton(
                    child: const Text("save"),
                    onPressed: () {
                      if (_loadKey.currentState!.validate()) {
                        advanceResult = int.parse(price.text);
                        String value = price.text;
                        price.text = "";
                        var date = DateTime.now();
                        String dateFormate =
                            DateFormat("dd-MM-yyy").format(date);
                        if (advance > 0) {
                          advance = advance - advanceResult;
                          if (advance <= 0) {
                            total = advance.abs();
                            advance = 0;
                            setState(() {});
                          } else {
                            setState(() {});
                          }
                        } else {
                          total = total + advanceResult;
                          setState(() {});
                        }
                        hisabList.add(CustomerDetailListHive(
                            price: value,
                            date: dateFormate,
                            name: widget.instance.name));
                        setState(() {});
                      } else {
                        return;
                      }
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
                child: list.isEmpty
                    ? const Center(
                        child: Text("No data found"),
                      )
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                "Rs ${list[index].price}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              subtitle: Text(list[index].date),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  hisabList.deleteAt(index);
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      )),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Advance Rs ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "$advance",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: "Total Rs ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: "$total",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0))
                      ]),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // void didUpdateWidget(covariant CustomerDetailList oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (varaibleInstance.isInBox) {
  //     Provider.of<PriceProvider>(context, listen: false).total =
  //         varaibleInstance.total;
  //     Provider.of<PriceProvider>(context, listen: false).advance =
  //         varaibleInstance.advance;
  //   }
  // }

  @override
  void deactivate() {
    if (varaibleInstance.isInBox) {
      varaibleInstance.total = total;
      varaibleInstance.advance = advance;
      varaibleInstance.save();
    } else {
      varaibles.add(VariableValue(
          name: widget.instance.name, total: total, advance: advance));
    }
    super.deactivate();
  }
}
