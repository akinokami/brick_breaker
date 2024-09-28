import 'dart:math'; // For random selection
import 'package:brick_breaker/services/local_storage.dart';
import 'package:brick_breaker/utils/enum.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'brick_breaker.dart';
import '../utils/config.dart';
import 'ball.dart';
import 'bat.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  static List<IconData> iconList = [
    Icons.sports_soccer,
    Icons.sports_baseball,
    Icons.sports_rugby,
    Icons.sports_cricket,
    Icons.sports_hockey,
    Icons.sports_tennis,
    Icons.sports_golf,
    Icons.sports_baseball,
    Icons.sports_volleyball,
    Icons.sports_football,
  ];

  Brick({
    required super.position,
    required Color color,
  }) : super(
          size: Vector2(brickWidth, brickHeight),
          anchor: Anchor.center,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [
            RectangleHitbox(),
            IconComponent(
              icon: iconList[
                  Random().nextInt(iconList.length)], // Select random icon
              size: Vector2(brickWidth * 0.6,
                  brickHeight * 0.6), // Larger size (60% of brick size)
              position: Vector2(
                  brickWidth * 0.2, brickHeight * 0.2), // Center the icon
            ),
          ],
        );

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    removeFromParent();
    game.score.value++;

    if (game.world.children.query<Brick>().length == 1) {
      game.playState = PlayState.won;
      if (game.score.value >= game.best.value) {
        game.best.value = game.score.value;
        LocalStorage.instance.write(StorageKey.best.name, game.best.value);
      }
      game.world.removeAll(game.world.children.query<Ball>());
      game.world.removeAll(game.world.children.query<Bat>());
    }
  }
}

class IconComponent extends PositionComponent {
  final IconData icon;
  final double iconSize;

  IconComponent({
    required this.icon,
    Vector2? position,
    Vector2? size,
  })  : iconSize = size?.x ?? 24.0,
        super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: icon.fontFamily,
          color: Colors.white, // Change the icon color if needed
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Adjust to ensure the icon is centered within its component
    final iconOffset = Offset(
      (size.x - textPainter.width) / 2,
      (size.y - textPainter.height) / 2,
    );

    textPainter.paint(canvas, iconOffset);
  }
}



// import 'package:brick_breaker/services/local_storage.dart';
// import 'package:brick_breaker/utils/enum.dart';
// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flutter/material.dart';

// import 'brick_breaker.dart';
// import '../utils/config.dart';
// import 'ball.dart';
// import 'bat.dart';

// class Brick extends RectangleComponent
//     with CollisionCallbacks, HasGameReference<BrickBreaker> {
//   Brick({required super.position, required Color color})
//       : super(
//           size: Vector2(brickWidth, brickHeight),
//           anchor: Anchor.center,
//           paint: Paint()
//             ..color = color
//             ..style = PaintingStyle.fill,
//           children: [RectangleHitbox()],
//         );

//   @override
//   void onCollisionStart(
//       Set<Vector2> intersectionPoints, PositionComponent other) {
//     super.onCollisionStart(intersectionPoints, other);
//     removeFromParent();
//     game.score.value++;

//     if (game.world.children.query<Brick>().length == 1) {
//       game.playState = PlayState.won;
//       if (game.score.value >= game.best.value) {
//         game.best.value = game.score.value;
//         LocalStorage.instance.write(StorageKey.best.name, game.best.value);
//       }
//       game.world.removeAll(game.world.children.query<Ball>());
//       game.world.removeAll(game.world.children.query<Bat>());
//     }
//   }
// }


