import 'package:flutter/material.dart';

import 'package:shoryanelhayat_user/screens/org_widgets/models.dart';

class RatingInformation extends StatelessWidget {
  RatingInformation(this.movie);
  final Movie movie;

  Widget _buildRatingBar(ThemeData theme) {
    var stars = <Widget>[];

    for (var i = 1; i <= 5; i++) {
// Assuming movie is an instance of a class with starRating as an int?
// var color = (i <= (movie.starRating ?? 0)) ? theme.colorScheme.secondary : Colors.black12;
      
      // Assuming movie is an instance of a class with starRating as an int?
      var color = (i <= (movie.starRating ?? 0))
          ? theme.colorScheme.secondary
          : Colors.black12;

      
      var star = Icon(
        Icons.star,
        color: color,
      );

      stars.add(star);
    }

    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var ratingCaptionStyle = textTheme.bodySmall!.copyWith(color: Colors.black45);

    var numericRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          movie.rating.toString(),
          style: textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.secondary,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          // 'Ratings',
          'التقيم',
          style: ratingCaptionStyle,
        ),
      ],
    );

    var starRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRatingBar(theme),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0),
          child: Text(
            // 'Grade now',
            'عدد النجوم',
            style: ratingCaptionStyle,
          ),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        numericRating,
        SizedBox(width: 16.0),
        starRating,
      ],
    );
  }
}
