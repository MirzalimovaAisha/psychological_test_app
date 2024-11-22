import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:psychological_test_app/detail/detail_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class QuestionPage extends StatefulWidget {
  final String question;
  const QuestionPage({super.key, required this.question});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String title = '';
  int selectNumber = -1;
  Future<String> loadAssets(String fileName) async {
    return await rootBundle.loadString('res/api/$fileName.json');
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: FutureBuilder(
          // FutureBuilder는 JSON 데이터를 UI로 표시하는 위젯 ================

          future: loadAssets(widget.question),
          builder: (context, snapshot){
            if (snapshot.hasData == false) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    'Error : ${snapshot.error}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              );
            } else {
              Map<String, dynamic> questions = jsonDecode(snapshot.data!);
              title = questions['title'].toString();
              List<Widget> widgets;

              widgets = List<Widget>.generate(
                  (questions['selects'] as List<dynamic>).length,
                  (int index) => SizedBox(
                    height: 100,
                    child: Column(
                      children: [
                        Text(questions['selects'][index]),
                        Radio(
                          value: index,
                          groupValue: selectNumber,
                          onChanged: (value) {
                            setState(() {
                              selectNumber = index;
                            });
                          },
                        )
                      ],
                    ),
                  )
              );

              return Scaffold(
                appBar: AppBar(
                  title: Text(title),
                ),

                body: Column(
                  children: [
                    Text(questions['question'].toString()),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widgets.length,
                        itemBuilder: (context, index) {
                          final item = widgets[index];
                          return item;
                        },
                      ),
                    ),

                    selectNumber == -1
                    ? Container()
                    : Container(
                      padding: const EdgeInsets.all(10),
                      height: 80,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async{
                          await FirebaseAnalytics.instance.logEvent(
                            name: 'personal_select',
                            parameters: {"test_name": title, "select": selectNumber},
                          ).then((result){
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                                  return DetailPage(question: questions['question'], answer: questions['answer'][selectNumber]);
                                }));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[600],
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        child: const Text('성격 보기'),
                      ),
                    )
                  ],
                ),
              );
            }
          }
      ),
    );
  }
}
