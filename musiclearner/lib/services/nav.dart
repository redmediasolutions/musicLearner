import 'package:go_router/go_router.dart';
import 'package:musiclearner/pages/accountsettings/accountsettings.dart';
import 'package:musiclearner/pages/buynow/buynow.dart';
import 'package:musiclearner/pages/forgotpassword/forgotpassword.dart';
import 'package:musiclearner/pages/learning/learning.dart';
import 'package:musiclearner/pages/login/login.dart';
import 'package:musiclearner/pages/home/homelanding.dart';
import 'package:musiclearner/pages/coursedetails/coursedetails.dart';
import 'package:musiclearner/pages/lessonplayer/lessonplayer.dart';
import 'package:musiclearner/pages/purchasehistory/purchasehistory.dart';
import 'package:musiclearner/pages/signup/signup.dart';
import 'package:musiclearner/pages/explore/explore.dart';
import 'package:musiclearner/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:musiclearner/services/shellbottom.dart';

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const Signup(),
    ),
      GoRoute(
          path: '/course',
          name: 'coursedetails',
          builder: (context, state) => const Coursedetails(),
        ),
        GoRoute(
          path: '/lesson',
          name: 'lessonplayer',
          builder: (context, state) => const  Lessonplayer(),
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
          path: '/explore',
          name: 'explorepage',
          builder: (context, state) => const Explore(),
        ),
         GoRoute(
          path: '/learning',
          name: 'learningpage',
          builder: (context, state) => const Learning(),
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