import 'package:flutter/material.dart';
import 'package:flutter_doc_sqflite/models/customer_detail_list_hive.dart';
import 'package:flutter_doc_sqflite/models/customer_hisab.dart';
import 'package:flutter_doc_sqflite/models/hisab_database.dart';
import 'package:flutter_doc_sqflite/models/variable_value_hive.dart';
import 'package:flutter_doc_sqflite/util/user_detail.dart';
import 'package:flutter_doc_sqflite/util/user_profile.dart';
import 'package:flutter_doc_sqflite/util/varaible_state.dart';
import 'package:flutter_doc_sqflite/widgets/customer_entry_page.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../util/price_provider.dart';

class CustomerDetailList extends StatefulWidget {
  // final String name;
  // final String desc;
  //final CustomerHisab instance;
  //final PriceProvider provider;
  final UserProfile profile;
  const CustomerDetailList({Key? key, required this.profile}) : super(key: key);

  @override
  _CustomerDetailListState createState() => _CustomerDetailListState();
}

class _CustomerDetailListState extends State<CustomerDetailList>
    with WidgetsBindingObserver {
  var price = TextEditingController();
  var advance = 0;
  int? id;
  var advanceResult = 0;
  var advanceControler = TextEditingController();
  //var hisabList = Hive.box<CustomerDetailListHive>("hisabList");
  //var varaibles = Hive.box<VariableValue>("varaibles");
  final _priceKey = GlobalKey<FormState>();
  final _loadKey = GlobalKey<FormState>();
  late VariableValue varaibleInstance;
  late final Map<dynamic, VariableValue> map;
  //final provider = Provider.of<PriceProvider>(_);
  var helper = HisabDatabase.hisabDatabase;

  int total = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    // row = varaibles.values
    //     .where((element) => element.name == widget.instance.name)
    //     .toList();
    // map = varaibles.toMap();
    // if (map.isNotEmpty) {
    //   map.forEach((key, value) {
    //     if (value.name == widget.instance.name) {
    //       varaibleInstance = value;
    //       total = value.total;
    //       advance = value.advance;
    //     } else {
    //       varaibleInstance = VariableValue(
    //           name: widget.instance.name, total: total, advance: advance);
    //     }
    //   });
    // } else {
    //   varaibleInstance = VariableValue(
    //       name: widget.instance.name, total: advance, advance: advance);
    // }
    //var varaibleState;
    getVaraibleState();
  }

  void getVaraibleState() async {
    await helper.fetchVaraibleState(widget.profile.id!).then((value) {
      total = value.getTotal;
      advance = value.getAdvance;
      id = value.id;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // var list = hisabList.values
    //     .where((hisab) => hisab.name == widget.instance.name)
    //     .toList();

    // total = advanceResult;
    // list.forEach((element) {
    //   total += element.price;
    // });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 54, 224, 247),
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.profile.getName,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
              itemBuilder: ((context) {
                return ["profile", "logout"].map((e) {
                  return PopupMenuItem(
                    child: Text(e),
                    value: e,
                  );
                }).toList();
              }),
              onSelected: clickOnItem),
        ],
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
                        style: const TextStyle(fontSize: 16.0),
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
                            fillColor: const Color.fromARGB(255, 85, 201, 247),
                            labelText: "Price from cunstomer",
                            labelStyle: const TextStyle(color: Colors.black),
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 3.0),
                                borderRadius: BorderRadius.circular(10.0)))),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 54, 224, 247)),
                  child: const Text(
                    "submit",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    if (_priceKey.currentState!.validate()) {
                      advanceResult = int.parse(advanceControler.text);
                      String price = advanceControler.text;
                      advanceControler.text = "";
                      var netTotal = total;
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
                      helper.insertData(
                          helper.userDetail,
                          UserDetail(
                              userId: widget.profile.id!,
                              price: " total $netTotal, $price from customer",
                              date: dateFormat));
                      // hisabList.add(CustomerDetailListHive(
                      //     price: " total $total, $price from customer",
                      //     date: dateFormat,
                      //     name: widget.instance.name));
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
                      style: const TextStyle(fontSize: 16.0),
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
                          fillColor: const Color.fromARGB(255, 85, 201, 247),
                          labelText: "Load price",
                          labelStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 3.0),
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
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 54, 224, 247)
                       ),
                    child: const Text(
                      "save",
                      style: TextStyle(color: Colors.black),
                    ),
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
                        helper.insertData(
                            helper.userDetail,
                            UserDetail(
                                userId: widget.profile.id!,
                                price: value,
                                date: dateFormate));
                        // hisabList.add(CustomerDetailListHive(
                        //     price: value,
                        //     date: dateFormate,
                        //     name: widget.instance.name));
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
              child: FutureBuilder<List<UserDetail>>(
                future: helper.fetchUserDetail(widget.profile.id!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 6.0),
                          color: Color.fromARGB(255, 85, 201, 247),
                          child: ListTile(
                            iconColor: Colors.black,
                            textColor: Colors.black,
                            // contentPadding:
                            //     EdgeInsets.symmetric(horizontal: 32.0),
                            title: Text(
                              "Rs ${snapshot.data![index].price}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            subtitle: Text(snapshot.data![index].date),
                            trailing: IconButton(
                                onPressed: () {
                                  helper.deleteData(helper.userDetail,
                                      snapshot.data![index].id!);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete)),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                      text: "Advance Rs ",
                      //style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: "$advance",
                            style: const TextStyle(
                               // color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold))
                      ]),
                ),
                RichText(
                  text: TextSpan(
                      text: "Total Rs ",
                      //style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: "$total",
                            style: const TextStyle(
                               // color: Colors.black,
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        if (id != null) {
          // varaibleInstance.total = total;
          // varaibleInstance.advance = advance;
          // varaibleInstance.save();
          helper.updateData(
              helper.variableState,
              VaraibleState(
                  id: id,
                  userId: widget.profile.id!,
                  total: total,
                  advance: advance));
          //setState(() {});
        } else {
          // varaibleInstance.total = total;
          // varaibleInstance.advance = advance;
          // varaibles.add(varaibleInstance);
          helper.insertData(
              helper.variableState,
              VaraibleState(
                  userId: widget.profile.id!, total: total, advance: advance));
          //setState(() {});
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void deactivate() {
    if (id != null) {
      // varaibleInstance.total = total;
      // varaibleInstance.advance = advance;
      // varaibleInstance.save();
      helper.updateData(
          helper.variableState,
          VaraibleState(
              id: id,
              userId: widget.profile.id!,
              total: total,
              advance: advance));
      //setState(() {});
    } else {
      // varaibleInstance.total = total;
      // varaibleInstance.advance = advance;
      // varaibles.add(varaibleInstance);
      helper.insertData(
          helper.variableState,
          VaraibleState(
              userId: widget.profile.id!, total: total, advance: advance));
      //setState(() {});
    }
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    // hisabList.close();
    // varaibles.close();
    super.dispose();
  }
  

  void clickOnItem(value) {
    switch (value) {
      case "profile":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DetailPage(
                      profile: widget.profile,
                      appTitle: widget.profile.getName,
                    )));
    }
  }
}
