import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'notifiers/activity_notifier.dart';
import 'notifiers/campaign_notifier.dart';
import 'notifiers/organization_notifier.dart';
import 'providers/auth.dart';
import 'providers/chat_provider.dart';
import 'providers/email_provider.dart';
import 'providers/mydonation_provider.dart';
import 'providers/usersProvider.dart';
import 'screens/Help_organizations.dart';
import 'screens/Notification_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/email_organization.dart';
import 'screens/favourite_screen.dart';
import 'screens/help_screen.dart';
import 'screens/login_screen.dart';
import 'screens/my_donation_edit.dart';
import 'screens/my_donation_screen.dart';
import 'screens/overview_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle style1 = GoogleFonts.amiri(
      fontSize: 18,
    );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: CampaignNotifier(),
          ),
          ChangeNotifierProvider.value(
            value: OrganizationNotifier(),
          ),
          ChangeNotifierProvider.value(
            value: UsersProvider(),
          ),
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProvider.value(
            value: ActivityNotifier(),
          ),
          ChangeNotifierProvider.value(
            value: EmailProvider(),
          ),
          ChangeNotifierProvider.value(
            value: ChatProvider(),
          ),
          ChangeNotifierProvider.value(
            value: MyDonationsProvider(),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (BuildContext context, Widget? child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.linear(1.0),
                  ),
                  child: child!,
                ),
              );
            },
            title: 'شريان الحياة',
            theme: new ThemeData(
                primarySwatch: Colors.green,
                textTheme: TextTheme(
                    titleMedium: style1,
                    // button: TextStyle(
                    //   fontFamily: ArabicFonts.Cairo,
                    //   // color: Color.fromRGBO(187, 186, 198, 1),
                    //   color: Color.fromRGBO(1, 123, 126, 1),
                    //   package: 'google_fonts_arabic',
                    // ),
                    bodyMedium: style1,
                    bodySmall: style1)),
            home: WelcomeScreen(),
            routes: {
              '/Favourite': (context) => Favourite(),
              '/Home': (context) => OrgOverviewScreen(),
              '/Notifications': (context) => Notifications(),
              '/Login': (context) => LoginScreen(),
              '/Signup': (context) => SignupScreen(),
//              '/ExternalDonation': (context) => ExternalDonation(),
//              '/UserProfile': (context) => UserProfileScreen(),
              HelpScreen.routeName: (ctx) => HelpScreen(),
              EmailOrganization.routeName: (ctx) => EmailOrganization(),
              ChatScreen.routeName: (ctx) => ChatScreen(),
              HelpOrganization.routeName: (ctx) => HelpOrganization(),
              MyDonationsScreen.routeName: (ctx) => MyDonationsScreen(),
              EditDonation.routeName: (ctx) => EditDonation(),
            }));
  }
}
