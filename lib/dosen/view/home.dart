import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uas_dosen/constant.dart';
import 'package:uas_dosen/dosen/model/dosen.dart';
import 'package:uas_dosen/dosen/view/add.dart';
import 'package:uas_dosen/dosen/view/edit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  List<DosenModel> data = [];
  var loading = false;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _deleteData(int? id) async {
    setState(() {
      loading = true;
      data = [];
    });
    await http.delete(Uri.parse(BASE_URL + '/dosen/$id'));

    _refreshData;
    setState(() {
      loading = false;
    });
  }

  Future<void> _refreshData() async {
    try {
      setState(() {
        loading = true;
        data = [];
      });
      var response = await http.get(Uri.parse(BASE_URL + '/dosen'));
      final datas = jsonDecode(response.body);
      Map<String, dynamic> resDataString = datas;

      // data = data.map<DosenModel>((json) => DosenModel.fromJson(json));
      print('resDataString ${resDataString['data'].length}');
      if (resDataString['data'].length > 0) {
        resDataString['data'].forEach((api) {
          final ab = new DosenModel(
            api['id'],
            api['nama'],
            api['nidn'],
            api['tempat_lahir'],
            api['tgl_lahir'],
            api['no_hp'],
          );
          data.add(ab);
        });
      } else {
        data = [];
      }
      setState(() {
        loading = false;
      });
      print('oke $response');
      print('object $data');
    } catch (e) {
      print('error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UAS'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _refreshData(),
        key: _refresh,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : data.length == 0
                ? const Center(
                    child: const Text('Data Dosen Kosong'),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, index) {
                      print('sss $index');
                      final tpl = data[index].tempat_lahir ?? '-';
                      final tl = data[index].tgl_lahir ?? '-';
                      return Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Edit(
                                      reload: _refreshData, data: data[index]),
                                ),
                              ),
                              child: ListTile(
                                title: Text(data[index].nama ?? '-'),
                                subtitle: Text(tpl + ', ' + tl),
                              ),
                            ),
                          ),
                          MaterialButton(
                            color: Colors.red,
                            onPressed: () {
                              _deleteData(data[index].id);
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Add(
                reload: _refreshData,
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
