import 'package:flutter/material.dart';

class HighlightContainer extends StatelessWidget {
  String imageUrl;
  String title;
  HighlightContainer({required this.imageUrl,required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 130,
      width: 173,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        image: DecorationImage(
          image: NetworkImage(
            imageUrl,
          ),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          begin: Alignment(-0.00, 1.00),
          end: Alignment(0, -1),
          colors: [Colors.black, Colors.black.withOpacity(0)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      // decoration: BoxDecoration(
      //   image: const DecorationImage(
      //     image: NetworkImage(
      //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdXX7GO70tKqiGR95LplD2avbw4oIOGll9jJBNCnvT&s",
      //     ),
      //     fit: BoxFit.cover,
      //   ),
      //   borderRadius:
      //       BorderRadius.circular(15.0), // Adjust the radius as needed
      // ),
      // alignment: AlignmentDirectional.bottomStart,
      child: Container(
        padding: EdgeInsets.only(left: 14, bottom: 14),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
        ),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
