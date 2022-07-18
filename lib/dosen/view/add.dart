import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uas_dosen/constant.dart';
import 'package:http/http.dart' as http;

class Add extends StatefulWidget {
  final VoidCallback reload;

  const Add({Key? key, required this.reload}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final inputNama = TextEditingController();
  final inputNIDN = TextEditingController();
  final inputTPL = TextEditingController();
  final inputTTL = TextEditingController();
  final inputHP = TextEditingController();
  bool isDisabled = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    inputNama.dispose();
    inputNIDN.dispose();
    inputTPL.dispose();
    inputTTL.dispose();
    inputHP.dispose();
    super.dispose();
  }

  simpanBarang() async {
    try {
      var uri = Uri.parse(BASE_URL + '/dosen');
      var response = await http.post(uri, body: {
        "nama": inputNama.text,
        "nidn": inputNIDN.text,
        "tempat_lahir": inputTPL.text,
        "tgl_lahir": inputTTL.text,
        "no_hp": inputHP.text,
      });

      final respStr = jsonDecode(response.body);

      print('res $respStr');

      setState(() {
        Navigator.pop(context);
        widget.reload();
        isDisabled = false;
      });
    } catch (e) {
      setState(() {
        isDisabled = false;
      });
      print("error");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UAS-ADD'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: inputNama,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nama',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: inputNIDN,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'NIDN',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: inputTPL,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Tempat Lahir',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: inputTTL,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Tanggal Lahir',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: inputHP,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'No HP',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: MaterialButton(
                color: isDisabled ? Colors.grey : Colors.blue,
                onPressed: () {
                  if (isDisabled) {
                    return null;
                  } else {
                    setState(() {
                      isDisabled = true;
                    });
                    simpanBarang();
                  }
                },
                child: Text(
                  isDisabled ? "Waiting...." : "Simpan",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
