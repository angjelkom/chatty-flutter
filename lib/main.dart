import 'package:flutter/material.dart';
import 'package:chatty_flutter/providers/bottom_navigtation_provider.dart';
import 'package:chatty_flutter/providers/contacts_provider.dart';
import 'package:chatty_flutter/providers/conversations.dart';
import 'package:chatty_flutter/providers/login.dart';
import 'package:chatty_flutter/providers/profile.dart';
import 'package:chatty_flutter/screens/ContactsScreen.dart';
import 'package:chatty_flutter/screens/ConversationScreen.dart';
import 'package:chatty_flutter/screens/ConversationsScreen.dart';
import 'package:chatty_flutter/screens/LoginScreen.dart';
import 'package:chatty_flutter/screens/SearchScreen.dart';
import 'package:chatty_flutter/screens/SettingsScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = (await SharedPreferences.getInstance()).getString('token');

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String token;
  MyApp({this.token}) : super();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
          lazy: true,
        ),
        ChangeNotifierProvider<ConversationsProvider>(
            create: (_) => ConversationsProvider()),
//        ChangeNotifierProxyProvider<ConversationsProvider, ConversationProvider>(
//          create: (_) => ConversationProvider(),
//          update: (BuildContext context, ConversationsProvider conversations, ConversationProvider activeConversation){
//            return activeConversation..conversation = conversations.active;
//          },
//        ),
//        ProxyProvider<ConversationsProvider, ConversationProvider>(
//          create: (_, conversations, __) => ConversationProvider(conversations.active),
//        ),
        ChangeNotifierProvider<ContactsProvider>(
            create: (_) => ContactsProvider()),
        ChangeNotifierProvider<BottomNavigationProvider>(
            create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
              color: Colors.black87,
              iconTheme: IconThemeData(color: Colors.black)),
          typography: Typography.material2018(
            white: TextTheme(
              headline6: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              // subtitle1: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.red),
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          // additional settings go here
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return PageTransition(
                type: PageTransitionType.leftToRight,
                child: LoginScreen(
                  signup: false,
                ),
              );
              break;
            case '/signup':
              return PageTransition(
                type: PageTransitionType.leftToRight,
                child: LoginScreen(
                  signup: true,
                ),
              );
              break;
            case '/settings':
              return PageTransition(
                type: PageTransitionType.leftToRight,
                child: SettingsScreen(),
              );
              break;
            case '/conversations':
              return PageTransition(
                type: PageTransitionType.leftToRight,
                child: ConversationsScreen(),
              );
              break;
            case '/conversation':
              return PageTransition(
                type: PageTransitionType.leftToRight,
                child: ConversationScreen(),
              );
              break;
            case '/search':
              return PageTransition(
                type: PageTransitionType.leftToRight,
                child: SearchScreen(),
              );
              break;
            case '/contacts':
              return PageTransition(
                type: PageTransitionType.leftToRight,
                child: ContactsScreen(),
              );
              break;
            default:
              return null;
          }
        },

        routes: {
          //   '/login': (context) => LoginScreen(signup: false,),
          //  '/signup': (context) => LoginScreen(signup: true,),
          //   '/conversations': (context) => ConversationsScreen(),
          //   '/conversation': (context) => ConversationScreen(),
          //  '/search': (context) => SearchScreen(),
          //  '/contacts': (context) => ContactsScreen(),
          //  '/settings': (context) => SettingsScreen(),
        },
        initialRoute: token != null ? '/conversations' : '/login',
//            initialRoute: '/login',
        // initialRoute: '/conversation',
      ),
    );
  }
}
