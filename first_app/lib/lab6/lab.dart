import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String position;
  final String email;
  final String phoneNumber;
  final String imageUrl;

  ProfileCard({
    required this.name,
    required this.position,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // รูปภาพ
          CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage(imageUrl),
          ),
          // ชื่อและข้อมูลต่างๆ
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              position,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(email),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(phoneNumber),
          ),
        ],
      ),
    );
  }
}
