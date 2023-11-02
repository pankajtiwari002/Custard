import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class UserPhotosContainer extends StatelessWidget {

  List<String> images;
  String title;
  Function onPress;
  String userImage;

  UserPhotosContainer({
    super.key,
    required this.images,
    required this.title,
    required this.onPress,
    required this.userImage
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(userImage),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      '${images.length} Photos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF979797),
                        fontSize: 14,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400
                      ),
                    )
                  ],
                ),
                Spacer(
                  flex: 1,
                ),
                TextButton(
                    onPressed: onPress(),
                    child: Text(
                      'View all',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF7B61FF),
                        fontSize: 12,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                )
              ],
            ),
            SizedBox(height: 10,),
            GridView.custom(
              shrinkWrap: true,
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: [
                  QuiltedGridTile(2, 2),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 1),
                  QuiltedGridTile(1, 2),
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                childCount: 4,
                (context, index) => Container(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }
}