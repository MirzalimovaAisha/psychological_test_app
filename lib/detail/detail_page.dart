import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String question;
  final String answer;
  const DetailPage({super.key, required this.question, required this.answer});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.question, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center,),
              const SizedBox(height: 20,),
              Text(widget.answer, style: const TextStyle(fontSize: 24), textAlign: TextAlign.center,),
              const SizedBox(height: 40,),
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text('돌아가기', style: TextStyle(fontSize: 20),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
