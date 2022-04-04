import 'package:flutter_listview_test/ui/widget/base_map_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ListAdapterTest());
  }
}

// 권한 받기 테스트 ㄲ
class ListAdapterTest extends StatefulWidget {
  const ListAdapterTest({Key? key}) : super(key: key);

  @override
  State<ListAdapterTest> createState() => _State();
}

class _State extends State<ListAdapterTest> {
  void _showLocationOfMap() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BaseMapPage(),
        ));
  }

  void _permission() async {
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;
    if (requestStatus.isGranted && status.isLimited) {
      // isLimited - 제한적 동의 (ios 14 < )
      // 요청 동의됨
      print("isGranted");
      if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        // 요청 동의 + gps 켜짐
        var position = await Geolocator.getCurrentPosition();
        print("serviceStatusIsEnabled position = ${position.toString()}");
      } else {
        // 요청 동의 + gps 꺼짐
        print("serviceStatusIsDisabled");
      }
    } else if (requestStatus.isPermanentlyDenied ||
        status.isPermanentlyDenied) {
      // 권한 요청 거부, 해당 권한에 대한 요청에 대해 다시 묻지 않음 선택하여 설정화면에서 변경해야함. android
      print("isPermanentlyDenied");
      openAppSettings();
    } else if (status.isRestricted) {
      // 권한 요청 거부, 해당 권한에 대한 요청을 표시하지 않도록 선택하여 설정화면에서 변경해야함. ios
      print("isRestricted");
      openAppSettings();
    } else if (status.isDenied) {
      // 권한 요청 거절
      print("isDenied");
    }
    print("requestStatus ${requestStatus.name}");
    print("status ${status.name}");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                bottom: const TabBar(
              tabs: [Tab(text: "tab1"), Tab(text: "tab2"), Tab(text: "tab3")],
            )),
            body: TabBarView(
              children: [
                Row(children: [
                  ElevatedButton(
                    onPressed: _permission,
                    child: const Text("권한 동의"),
                  ),
                  ElevatedButton(
                      onPressed: _showLocationOfMap,
                      child: const Text("위치 보기")),
                  ElevatedButton(
                      onPressed: _showLocationOfMap,
                      child: const Text("위치 보기")),
                ]),
                const Text("tab2"),
                const Text("tab3")
              ],
            )));
  }
}
