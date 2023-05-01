import 'package:flutter/material.dart';
import 'package:project_x/flutter_flow/flutter_flow_theme.dart';

import '../../const/constant.dart';

class PlantingGuideCard extends StatefulWidget {
  const PlantingGuideCard({
    Key? key,
    required this.size,
    required this.plantName,
    required this.sub,
    required this.image,
  }) : super(key: key);

  final Size size;
  final String plantName;
  final String sub;
  final String image;

  @override
  _PlantingGuideCardState createState() => _PlantingGuideCardState();
}

class _PlantingGuideCardState extends State<PlantingGuideCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.only(
          left: kDefaultPadding / 2,
          top: kDefaultPadding / 3,
          bottom: kDefaultPadding * 0.4,
          right: kDefaultPadding / 2,
        ),
        width: widget.size.width * 0.4,
        child: Column(
          children: [
            Image.asset(widget.image),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: _isHovered ? kPrimaryColor.withOpacity(0.1) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 50,
                      color: _isHovered ? kPrimaryColor.withOpacity(0.5) : kPrimaryColor.withOpacity(0.3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.plantName.toUpperCase(),
                            style: FlutterFlowTheme.of(context).title3.copyWith(
                              color: _isHovered ? kPrimaryColor : Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: widget.sub.toString(),
                            style: FlutterFlowTheme.of(context).bodyText2.copyWith(
                              color: _isHovered ? kPrimaryColor : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}