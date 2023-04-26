import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_x/widgets/plant_card.dart';

class MyGardenPage extends StatelessWidget {
  final String userId;

  const MyGardenPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Garden'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('favPlants')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Your garden is empty.'));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final plant = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              print(plant);
              return PlantCard(
                name: plant['name']?? '',
                imageUrl: plant['imageUrl'] ?? 'https://images.pexels.com/photos/2845269/pexels-photo-2845269.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
              );
            },
          );
        },
      ),
    );
  }
}

