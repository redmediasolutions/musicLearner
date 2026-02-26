import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclearner/pages/accountsettings/accountsettings.dart';
import 'package:musiclearner/pages/admission/admissiondetails.dart';
import 'package:musiclearner/pages/buynow/buynow.dart';
import 'package:musiclearner/pages/documents/documents.dart';
import 'package:musiclearner/pages/fees/fees.dart';
import 'package:musiclearner/pages/forgotpassword/forgotpassword.dart';
import 'package:musiclearner/pages/home/homelanding.dart';
//import 'package:musiclearner/pages/learning/learning.dart';
import 'package:musiclearner/pages/login/login.dart';
import 'package:musiclearner/pages/courseland/courseland.dart';
import 'package:musiclearner/pages/coursedetails/coursedetails.dart';
import 'package:musiclearner/pages/lessonplayer/lessonplayer.dart';
import 'package:musiclearner/pages/notifications/notifications.dart';
import 'package:musiclearner/pages/purchasehistory/purchasehistory.dart';
import 'package:musiclearner/pages/signup/signup.dart';

import 'package:musiclearner/pages/profile/profile.dart';
import 'package:musiclearner/services/shellbottom.dart';

import 'auth_provider.dart';

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: "/login",
    debugLogDiagnostics: true,

    refreshListenable: authProvider, 

    redirect: (context, state) {
      final bool loggedIn = authProvider.isLoggedIn;
      final String path = state.uri.toString();
      
      // Allow access to login, signup, and forgot password pages without being logged in
      final bool isPublic = path == "/login" || path == "/signup" || path == "/forgot";

      if (!loggedIn && !isPublic) {
        return "/login";
      }

      if (loggedIn && path == "/login") {
        return "/home";
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/',
        name: 'root',
        builder: (context, state) => const Login(),
      ),

      GoRoute(
        path: '/course',
        name: 'coursedetails',
        builder: (context, state) => const Coursedetails(),
      ),

     GoRoute(
        path: '/courseland',
        name: 'courselanding',
        builder: (context, state) => const Courseland(),
      ),
      GoRoute(
        path: '/lesson',
        name: 'lessonplayer',
        builder: (context, state) => const Lessonplayer(),
      ),

      GoRoute(
        path: '/signup',
        name: 'signuppage',
        builder: (context, state) => const Signup(),
      ),

      GoRoute(
        path: '/login',
        name: 'loginpage',
        builder: (context, state) => const Login(),
      ),

      GoRoute(
        path: '/forgot',
        name: 'forgotpassword',
        builder: (context, state) => const Forgotpassword(),
      ),

      GoRoute(
        path: '/buynow',
        name: 'buynowpage',
        builder: (context, state) => const Buynow(),
      ),

      GoRoute(
        path: '/accountsettings',
        name: 'accountsettings',
        builder: (context, state) => const Accountsettings(),
      ),

      GoRoute(
        path: '/purchasehistory',
        name: 'purchasehistory',
        builder: (context, state) => const Purchasehistory(),
      ),

      GoRoute(
        path: '/admission',
        name: 'admissiondetails',
        builder: (context, state) => const Admissiondetails(),
      ),
       GoRoute(
        path: '/documents',
        name: 'documents',
        builder: (context, state) => const Documents(),
      ),

     
      //SHELL ROUTE
    
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return ShellLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'homelanding',
            builder: (context, state) => const Homelanding(),
          ),
          GoRoute(
            path: '/notifications',
            name: 'notificationpage',
            builder: (context, state) => const Notifications(),
          ),
          GoRoute(
            path: '/fees',
            name: 'feespage',
            builder: (context, state) => const Fees(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const Profile(),
          ),
        ],
      ),
    ],
  );
}