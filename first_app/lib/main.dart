import 'package:flutter/material.dart';
import 'lab.dart';  // ทำการ import ไฟล์ ProfileCard

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Widget'),
        ),
        body: Center(
          child: ProfileCard(
            name: 'Pavornphop Tunphaiboon',
            position: 'Study in silpakorn',
            email: 'tunphaiboon_p@silpakorn.edu',
            phoneNumber: '0633284666',
            imageUrl: 'https://scontent.fbkk17-1.fna.fbcdn.net/v/t39.30808-1/413838595_1452604411985557_1533031403176848954_n.jpg?stp=dst-jpg_s200x200_tt6&_nc_cat=104&ccb=1-7&_nc_sid=e99d92&_nc_eui2=AeF3TcgO8HfYTwL-n1IiHaWzLCHidletHLksIeJ2V60cuR8df3EjLnZJjr6EUufN_obWVY7FpWEDcKuuvuM2xrKc&_nc_ohc=rD1XGSTG6MwQ7kNvwFSt64t&_nc_oc=AdklRk-xdmwYpV2dvUIJDkfUnTzy8sA7-D6klqRTAh1I23_2c5qMJTimwc0S4FJbKMc&_nc_zt=24&_nc_ht=scontent.fbkk17-1.fna&_nc_gid=VQrfrwaoSXxR3PvmyZrz3Q&oh=00_Afe-4VoEwdr50iXPVTtfOQ5EdHT9TCH31X-TlagHxLFjKw&oe=68F8DF40', // ใส่ URL ของรูปภาพที่ต้องการ
          ),
        ),
      ),
    );
  }
}
