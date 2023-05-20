import 'package:flutter/material.dart';
import 'package:project_x/const/constant.dart';


class PlantCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const PlantCard({Key? key, required this.name, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kPrimaryColor,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500), // Set the initial font size
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
