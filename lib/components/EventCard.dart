import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 200,
      child: Card(
        elevation: 1.0,
        margin: EdgeInsets.all(10.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Upcoming',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
              Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdXX7GO70tKqiGR95LplD2avbw4oIOGll9jJBNCnvT&s",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100.0,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Social Dance Tribe',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Saturday 24 sept 2023',
                  style: TextStyle(fontSize: 14,color: Colors.grey),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'EXPLORE',
                      style: TextStyle(color: Color(0xFF7B61FF),),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
