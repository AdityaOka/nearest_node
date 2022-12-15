import 'package:get/get.dart';
import 'package:flutter/material.dart';


import 'size_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: "Node Position",
      home: HomeScreen(),
    );
  }
}

class HomeController extends GetxController{
  List<GlobalKey> boxKey = [];
  final node = "".obs;
  final index = 0.obs;
  final offSetList = <Offset>[].obs;
  final tapOffset = const Offset(0, 0).obs;
  final calculateList = <int>[].obs;

  Map<int, String> nodeIndex = {
    0: "A",
    1: "B",
    2: "C",
    3: "D",
  };

  changeNode(){
    calculateList.clear();
    if(offSetList.isEmpty){
      for(var key in boxKey){
        RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        offSetList.add(Offset(position.dx, position.dy));
      }
    }

    for(int i =0; i<offSetList.length; i++){
      calculateList.add((tapOffset.value - offSetList[i]).distance.round() );
    }

    int smallest = calculateList.reduce((previousValue, element) => previousValue < element ? previousValue : element);
    node.value = nodeIndex[calculateList.indexOf(smallest)] ?? 'No node';
  }

  initKey(){
    for (int i=0;i<4; i++){
      boxKey.add(GlobalKey());
    }
  }

  @override 
  void onInit(){
    initKey();
    super.onInit();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    final ctrl = Get.put(HomeController());
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Obx((){
          return Text('Nearest Node ${ctrl.node.value}');
        })
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: SizeConfig.sizeVertical(4),
              left: SizeConfig.sizeHorizontal(10),
              child:  Container(
                key: ctrl.boxKey[0],
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "A",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              top: SizeConfig.sizeVertical(8),
              right: SizeConfig.sizeHorizontal(10),
              child:  Container(
                key: ctrl.boxKey[1],
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "B",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: SizeConfig.sizeVertical(10),
              left: SizeConfig.sizeHorizontal(10),
              child: Container(                
                key: ctrl.boxKey[2],
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "C",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: SizeConfig.sizeVertical(5),
              right: SizeConfig.sizeHorizontal(10),
              child: Container(
                key: ctrl.boxKey[3],
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "D",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details){
                ctrl.tapOffset.value = details.globalPosition;
                ctrl.changeNode();
              },
            ),
          ],
        ),
      ),
    );
  }
}