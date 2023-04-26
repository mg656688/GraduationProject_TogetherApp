import 'package:flutter/material.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';

import '../../const/constant.dart';

class PlantingGuideCard extends StatelessWidget {
  const PlantingGuideCard({Key? key,
    required this.size, required this.plantName, required this.sub, required this.image,})
      : super(key: key);

  final Size size;
  final String plantName;
  final String sub;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only
        (left: kDefaultPadding/2,
        top: kDefaultPadding/3,
        bottom: kDefaultPadding*0.4,
        right: kDefaultPadding/2,

      ),
      width: size.width*0.4,
      child: Column(
        children: [
          Image.asset(image),
          GestureDetector(
            onTap:(){
            },
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding/2),
              decoration:  BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),bottomRight:  Radius.circular(10),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(offset: const Offset(0,10),blurRadius: 50,color: kPrimaryColor.withOpacity(0.3)),
                ],
              ),
              child: Row(

                children: [
                  RichText(text:TextSpan(
                      children: [
                        TextSpan(text: plantName.toUpperCase(),style: FlutterFlowTheme.of(context).title3),

                        TextSpan(text: sub.toString(),style: FlutterFlowTheme.of(context).bodyText2),
                      ]
                  )),
                ],
              ),

            ),
          ),
        ],
      ),
    );
  }
}


