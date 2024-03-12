import 'package:flutter/material.dart';

class CastAndCrewWidget extends StatefulWidget {
  final List casts;

  const CastAndCrewWidget({super.key, required this.casts});

  @override
  State<CastAndCrewWidget> createState() => _CastAndCrewWidgetState();
}

class _CastAndCrewWidgetState extends State<CastAndCrewWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cast",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20),
          ),
          SizedBox(
            height: 130,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: widget.casts.length,
                itemBuilder: (context, index) {
                  return castCard(widget.casts[index]);
                }),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
  Widget castCard(final Map cast) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: 80,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: DecorationImage(
                image: AssetImage(cast["image"].toString()), // Use cast["image"]
                fit: BoxFit.cover,
              ),
            ),
            height: 70, // Set a maximum height
          ),
          SizedBox(height: 8),
          Expanded(
            child: Text(
              cast["name"],
              maxLines: 3,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }

}
