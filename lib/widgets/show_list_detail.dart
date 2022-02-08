import 'package:flutter/material.dart';

class ListDetail extends StatelessWidget {
  var list = [];
  ListDetail({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Detail"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.book),
              title: Text(list[index].name),
              subtitle: Text("Rs ${list[index].price}  ${list[index].date}"),
            ),
          );
        },
      ),
    );
  }
}
