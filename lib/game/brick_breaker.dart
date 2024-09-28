import 'dart:async';
import 'dart:math' as math;

import 'package:brick_breaker/utils/colors.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components.dart';
import '../utils/config.dart';

enum PlayState { welcome, playing, gameOver, won }

class BrickBreaker extends FlameGame
    with HasCollisionDetection, KeyboardEvents, TapDetector {
  BrickBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  final ValueNotifier<int> score = ValueNotifier(0);
  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;

  late PlayState _playState;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.gameOver:
      case PlayState.won:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.gameOver.name);
        overlays.remove(PlayState.won.name);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    camera.viewfinder.anchor = Anchor.topLeft;

    world.add(PlayArea());

    playState = PlayState.welcome;
  }

  void startGame() {
    if (playState == PlayState.playing) return;

    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<Bat>());
    world.removeAll(world.children.query<Brick>());

    score.value = 0; // Add this line
    playState = PlayState.playing;

    world.add(Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized()
          ..scale(height / 4)));

    world.add(Bat(
        size: Vector2(batWidth, batHeight),
        cornerRadius: Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.95)));

    world.addAll([
      for (var i = 0; i < brickColors.length; i++)
        for (var j = 1; j <= 5; j++)
          Brick(
            position: Vector2(
              (i + 0.5) * brickWidth + (i + 1) * brickGutter,
              (j + 2.0) * brickHeight + j * brickGutter,
            ),
            color: brickColors[i],
          ),
    ]);
  }

  @override
  void onTap() {
    super.onTap();
    startGame();
  }

  // @override
  // KeyEventResult onKeyEvent(
  //     KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
  //   super.onKeyEvent(event, keysPressed);
  //   switch (event.logicalKey) {
  //     case LogicalKeyboardKey.arrowLeft:
  //       world.children.query<Bat>().first.moveBy(-batStep);
  //     case LogicalKeyboardKey.arrowRight:
  //       world.children.query<Bat>().first.moveBy(batStep);
  //     case LogicalKeyboardKey.space:
  //     case LogicalKeyboardKey.enter:
  //       startGame();
  //   }
  //   return KeyEventResult.handled;
  // }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    super.onKeyEvent(event,
        keysPressed); // Remove this, as super is unnecessary for onKeyEvent override
    if (event is RawKeyDownEvent) {
      // Check if it's a key down event
      final logicalKey = event.logicalKey;
      switch (logicalKey) {
        case LogicalKeyboardKey.arrowLeft:
          world.children.query<Bat>().first.moveBy(-batStep);
          break;
        case LogicalKeyboardKey.arrowRight:
          world.children.query<Bat>().first.moveBy(batStep);
          break;
        case LogicalKeyboardKey.space:
        case LogicalKeyboardKey.enter:
          startGame();
          break;
      }
    }
    return KeyEventResult.handled;
  }

  @override
  Color backgroundColor() =>
      GameColors.bgColor; //const Color(0xffd0b4dc); //const Color(0xfff2e8cf);
}
