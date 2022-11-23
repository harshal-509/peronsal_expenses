// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:peronsal_expenses/transaction.dart';

class Modalbottomsheet extends StatefulWidget {
  final List<Transaction> transaction;
  final Function(String, double, DateTime) callback;
  const Modalbottomsheet(
      {Key? key, required this.transaction, required this.callback})
      : super(key: key);

  @override
  State<Modalbottomsheet> createState() => _ModalbottomsheetState();
}

class _ModalbottomsheetState extends State<Modalbottomsheet> {
  final TextEditingController title = TextEditingController();

  final TextEditingController amount = TextEditingController();

  DateTime? date = DateTime.now().add(
    Duration(days: 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 191, 208, 172),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: title,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter The Title',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: amount,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter the amount',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Choose Date'),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(
                          Duration(days: 1000),
                        ),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        setState(() {
                          date = value;
                        });
                      });
                    },
                  ),
                ),
                (date?.isAfter(DateTime.now()) ?? false) || date == null
                    ? Text('No date chosen')
                    : Text(
                        date.toString().substring(0, 10),
                      )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (title.text.isNotEmpty &&
                        amount.text.isNotEmpty &&
                        !((date?.isAfter(DateTime.now()) ?? false) ||
                            date == null)) {
                      widget.callback(
                          title.text, double.parse(amount.text), date as DateTime);
                    }
                    amount.clear();
                    title.clear();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
