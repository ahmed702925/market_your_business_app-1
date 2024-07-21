import 'package:shoryanelhayat_user/models/organization.dart';
import 'package:shoryanelhayat_user/screens/org_widgets/movie_api.dart';
import 'package:flutter/material.dart';

import 'package:shoryanelhayat_user/screens/org_widgets/arc_banner_image.dart';

import 'package:shoryanelhayat_user/screens/org_widgets/rating_information.dart';

class MovieDetailHeader extends StatelessWidget {
  // MovieDetailHeader(this.movie);
  //final Movie movie;
  MovieDetailHeader(this.currentOrg);
  final Organization currentOrg;

  // List<Widget> _buildCategoryChips(TextTheme textTheme) {
  //   return movie.categories.map((category) {
  //     return Padding(
  //       padding: const EdgeInsets.only(right: 8.0),
  //       child: Chip(
  //         label: Text(category),
  //         labelStyle: textTheme.caption,
  //         backgroundColor: Colors.black12,
  //       ),
  //     );
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var movieInformation = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Text(
              // movie.title,
              currentOrg.orgName,
              // style: textTheme.title,
              style: TextStyle(
                fontSize: 28,
                height: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // SizedBox(height: 8.0),
        // // RatingInformation(movie),
        //  RatingInformation(testMovie),
        // SizedBox(height: 12.0),
        // Row(children: _buildCategoryChips(textTheme)),
      ],
    );

    // return Stack(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(bottom: 100.0),
    //       // child: ArcBannerImage(movie.bannerUrl),
    //         child: ArcBannerImage(currentOrg.logo),
    //     ),
    //     Positioned(
    //       bottom: 0.0,
    //       left: 16.0,
    //       right: 16.0,
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           // Poster(
    //           //   movie.posterUrl,
    //           //   height: 180.0,
    //           // ),
    //           // SizedBox(width: 16.0),
    //           // Expanded(child: movieInformation),
    //            Expanded(child: movieInformation),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ArcBannerImage(currentOrg.logo),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: movieInformation),
          ],
        ),
      ],
    );
  }
}
