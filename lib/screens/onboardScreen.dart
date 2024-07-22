import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'overview_screen.dart';

class OnboardScreen extends StatelessWidget {
  final pages = [
    PageViewModel(
      pageColor: Colors.blue[500],
      bubble: Image.asset('assets/images/donation4.png'),
      body: Text(
        'حصّنوا أموالكم بالزكاة و داووا مرضاكم بالصدقة و إستقبلوا أمواج البلاء بالدعاء و التضرع',
        style: GoogleFonts.amiri(
          fontSize: 18,
        ),
      ),
      title: Text(
        'نقود',
        style: GoogleFonts.amiri(
          fontSize: 18,
        ),
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      mainImage: Image.asset(
        'assets/images/mdonation2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
        fit: BoxFit.cover,
      ),
    ),
    PageViewModel(
      pageColor: const Color(0xFF8BC34A),
      iconImageAssetPath: 'assets/images/donation5.png',
      body: Text(
        'وَأَطْعِمُوا الطَّعَامَ، وَصِلُوا الْأَرْحَامَ، وَصَلُّوا بِاللَّيْلِ وَالنَّاسُ نِيَامٌ تَدْخُلُوا الْجَنَّةَ بِسَلَامٍ',
        style: GoogleFonts.amiri(
          fontSize: 18,
        ),
      ),
      title: Text(
        'طعام',
        style: GoogleFonts.amiri(
          fontSize: 18,
        ),
      ),
      mainImage: Image.asset(
        'assets/images/donation2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Colors.grey[350],
      iconImageAssetPath: 'assets/images/donation9.png',
      body: Text(
        'ما نقصت صدقة من مال ، وما زاد الله عبدا بعفو إلا عزاً ، وما تواضع أحد لله إلا رفعة الله',
        style: GoogleFonts.amiri(
          fontSize: 18,
        ),
      ),
      title: Text(
        'ملابس',
        style: GoogleFonts.amiri(
          fontSize: 18,
        ),
      ),
      mainImage: Image.asset(
        'assets/images/donation9.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: true,
          showBackButton: true,
          onTapDoneButton: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrgOverviewScreen(),
                // builder: (context) => AnimatedNav(),
                // builder: (context) => MyHomePage2(),
              ), //MaterialPageRoute MyHomePage2
            );
          },
          doneText: Text(
            'حسنا',
            style: GoogleFonts.amiri(
              fontSize: 18,
            ),
          ),
          skipText: Text(
            'تخطى',
            style: GoogleFonts.amiri(
              fontSize: 18,
            ),
          ),
          nextText: Text(
            'التالى',
            style: GoogleFonts.amiri(
              fontSize: 18,
            ),
          ),
          backText: Text(
            'رجوع',
            style: GoogleFonts.amiri(
              fontSize: 18,
            ),
          ),
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ), //IntroViewsFlutter
      ), //Builder
    ); //Material App
  }
}
