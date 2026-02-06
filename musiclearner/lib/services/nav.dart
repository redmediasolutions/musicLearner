import 'package:go_router/go_router.dart';
import 'package:musiclearner/forgotpassword/forgotpassword.dart';
import 'package:musiclearner/login/login.dart';
import 'package:musiclearner/pages/homelanding.dart';
import 'package:musiclearner/coursedetails/coursedetails.dart';
import 'package:musiclearner/lessonplayer/lessonplayer.dart';
import 'package:musiclearner/signup/signup.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const Signup(),
    ),

    GoRoute(
      path: '/home',
      name: 'homelanding',
      builder: (context, state) => const Homelanding(),
    ),

    GoRoute(
      path: '/course',
      name: 'coursedetails',
      builder: (context, state) => const Coursedetails(),
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
  ],
);
