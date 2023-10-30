import 'package:flutter/material.dart';

class HighlightContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 200,
      width: 150,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdXX7GO70tKqiGR95LplD2avbw4oIOGll9jJBNCnvT&s",
          ),
          fit: BoxFit.cover,
        ),
        borderRadius:
            BorderRadius.circular(15.0), // Adjust the radius as needed
      ),
      // alignment: AlignmentDirectional.bottomStart,
      child: Container(
        padding: EdgeInsets.only(left: 5),
        alignment: Alignment.bottomLeft,
        child: const Text(
          'Revisit the\n Moment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}