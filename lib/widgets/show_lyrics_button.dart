import 'dart:io';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});
 

 Future some()async{
  final file = File('ad'); 
    final img    = file.readAsBytesSync();
    
 }

  @override
  Widget build(BuildContext context) {
    
        return Container();
  }
}