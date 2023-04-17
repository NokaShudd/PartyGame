import 'package:flutter/material.dart';

import '../constants/route_classes.dart';
import '../pages/focus.dart';
import '../pages/homepage.dart';
import '../pages/library.dart';
import '../pages/play_game.dart';
import '../pages/select_game.dart';
import '../pages/select_player.dart';

Route<dynamic>? onGenerateRoute(settings) {
  if (settings.name == '/') {
    return MaterialPageRoute(builder: (context) => const HomePage());
  }
  if (settings.name == RouteName.selectGame) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => const SelectGame(),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: 0.0, end: 1.0);

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
        // transitionsBuilder:
        //     (context, animation, secondaryAnimation, child) {
        //   const begin = Offset(1.0, 0.0);
        //   const end = Offset.zero;
        //   const curve = Curves.ease;

        //   var tween =
        //       Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        //   return SlideTransition(
        //     position: animation.drive(tween),
        //     child: child,
        //   );
      },
    );
  }
  if (settings.name == RouteName.selectPlayer) {
    final args = settings.arguments as SelectPlayerParam;
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => SelectPlayer(
        difficulty: args.difficulty,
        tagmode: args.tagmode,
        tags: args.tags,
      ),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: animation.drive(Tween(begin: 0.0, end: 1.0)),
          child: child,
        );
      },
      // transitionsBuilder:
      //     (context, animation, secondaryAnimation, child) {
      //   var tween = Tween(
      //     begin: const Offset(1.0, 0.0),
      //     end: Offset.zero,
      //   ).chain(
      //     CurveTween(
      //       curve: Curves.easeInSine,
      //     ),
      //   );

      //   return SlideTransition(
      //     position: animation.drive(tween),
      //     child: child,
      //   );
      // },
    );
  }
  if (settings.name == RouteName.playGame) {
    final args = settings.arguments as GameParam;
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => Game(
        difficulty: args.difficulty,
        tagmode: args.tagmode,
        players: args.players,
        tags: args.tags,
      ),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(
          CurveTween(
            curve: Curves.easeInSine,
          ),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  if (settings.name == RouteName.library) {
    final args = settings.arguments as LibraryParam;
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => Library(
        to: args.to,
      ),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).chain(
          CurveTween(
            curve: Curves.easeInSine,
          ),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  if (settings.name == RouteName.focus) {
    final args = settings.arguments as FocusParam;
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => FocusOn(
        type: args.type,
        element: args.element,
      ),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(
          CurveTween(
            curve: Curves.easeInSine,
          ),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  return MaterialPageRoute(
    builder: (ctx) => const HomePage(),
  );
}
