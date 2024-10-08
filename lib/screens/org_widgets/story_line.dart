import 'package:market_app/models/organization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Storyline extends StatefulWidget {
  Storyline(this.storyline);
  final Organization storyline;

  @override
  _StorylineState createState() => _StorylineState();
}

class _StorylineState extends State<Storyline> {
  var more = true;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الوصف',
          style: textTheme.titleMedium!.copyWith(fontSize: 24.0),
        ),
        SizedBox(height: 5.0),
        Text(
          widget.storyline.description,
          //  'وَأَطْعِمُوا الطَّعَامَ، وَصِلُوا الْأَرْحَامَ، وَصَلُّوا بِاللَّيْلِ وَالنَّاسُ نِيَامٌ تَدْخُلُوا الْجَنَّةَ بِسَلَامٍ',
          style: textTheme.bodyMedium!.copyWith(
            color: Colors.black45,
            fontSize: 18.0,
          ),
        ),
        if (!more)
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'العنوان',
                  style: textTheme.titleMedium!.copyWith(fontSize: 21.0),
                ),
                SizedBox(height: 5.0),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      widget.storyline.address,
                      style: textTheme.bodyMedium!.copyWith(
                        color: Colors.black45,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  'البريد الإلكتروني',
                  style: textTheme.titleMedium!.copyWith(fontSize: 21.0),
                ),
                SizedBox(height: 5.0),
                GestureDetector(
                  onLongPress: () => {
                    Clipboard.setData(
                        new ClipboardData(text: widget.storyline.email!)),
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'تم نسخ البريد الإلكتروني الى الحافظة \n تستطيع لصقه في المكان المناسب لك'),
                      duration: Duration(milliseconds: 1800),
                      elevation: 10,
                    )),
                    HapticFeedback.mediumImpact()
                  },
                  onTap: () {
                    launch("mailto:${widget.storyline.email}");
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.alternate_email),
                      SizedBox(
                        width: 8,
                      ),
                      Text(widget.storyline.email!,
                          style: textTheme.bodyMedium!.copyWith(
                            color: Colors.black45,
                            fontSize: 18.0,
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.content_copy)
                    ],
                  ),
                ),
                Text(
                  ' رقم التليفون المحمول',
                  style: textTheme.titleMedium!.copyWith(fontSize: 21.0),
                ),
                SizedBox(height: 5.0),
                GestureDetector(
                  onLongPress: () => {
                    Clipboard.setData(
                        new ClipboardData(text: widget.storyline.mobileNo)),
                    //  Fluttertoast.showToast(msg: 'تم نسخ الرقم ',
                    //  toastLength: Toast.LENGTH_LONG,

                    //  ),
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'تم نسخ الرقم الى الحافظة \n تستطيع لصقه في المكان المناسب لك'),
                      duration: Duration(milliseconds: 1800),
                      elevation: 10,
                    )),
                    HapticFeedback.mediumImpact()
                  },
                  onTap: () {
                    launch("tel:${widget.storyline.mobileNo}");
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.smartphone),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.storyline.mobileNo,
                        style: textTheme.bodyMedium!.copyWith(
                          color: Colors.black45,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.content_copy)
                    ],
                  ),
                ),
                Text(
                  ' رابط صفحة الإنترنت ',
                  style: textTheme.titleMedium!.copyWith(fontSize: 21.0),
                ),
                SizedBox(height: 5.0),
                Row(
                  children: <Widget>[
                    Icon(Icons.open_in_browser),
                    SizedBox(width: 8),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: InkWell(
                          onTap: () => launch(widget.storyline.webPage),
                          child: Text(
                            widget.storyline.webPage,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        // No expand-collapse in this tutorial, we just slap the "more"
        // button below the text like in the mockup.

        InkWell(
          onTap: () {
            setState(() {
              more = !more;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                more ? 'المزيد' : 'اقل',
                style: textTheme.bodyMedium!
                    .copyWith(fontSize: 18.0, color: theme.colorScheme.secondary),
              ),
              Icon(
                more ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                size: 20.0,
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
