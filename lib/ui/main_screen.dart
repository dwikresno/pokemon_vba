import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:just_audio/just_audio.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var imageMap = "littleroot_town.png";
  final player = AudioPlayer();
  List listForbiden = [];
  double posX = 0.0;
  double posY = 0.0;
  double maxXBoy = 380;
  double maxYBoy = 400;
  double boyX = 0.0;
  double boyY = 0.0;
  double step = 26;
  double maxXMap = 7;
  double maxYMap = 38;
  bool isMusicPlayed = true;
  bool isOutside = true;
  String directionBoy = "down";
  List<List<double>> forbidenArea = [
    [394, 210],
  ];
  bool isWalk = false;
  bool isWait = true;
  Timer? timerWalk;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    resetPositionMap();
    resetPositionBoy();
    playMusic();
    super.initState();
  }

  playMusic() async {
    await player.setAsset("lib/assets/pokemon/audio/sound_back.wav");
    await player.setLoopMode(LoopMode.all);
    await player.play();
  }

  pauseAndPlayMusic() {
    if (isMusicPlayed) {
      player.pause();
    } else {
      player.play();
    }
    setState(() {
      isMusicPlayed = !isMusicPlayed;
    });
  }

  @override
  void dispose() {
    player.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  bool checkCanPass(direction) {
    double stepX = 0.0;
    double stepY = 0.0;
    if (direction == "up") {
      stepX = 0;
      stepY += step;
    }

    if (direction == "down") {
      stepX = 0;
      stepY -= step;
    }

    if (direction == "left") {
      stepX -= step;
      stepY = 0;
    }

    if (direction == "right") {
      stepX += step;
      stepY = 0;
    }

    for (var f in forbidenArea) {
      if (cleanNumber(f[0]) == cleanNumber(posX + stepX) &&
          cleanNumber(f[1]) == cleanNumber(posY + stepY)) {
        return false;
      }
    }
    return true;
  }

  resetPositionMap() {
    setState(() {
      posX = -310;
      posY = -122;
    });
  }

  resetPositionBoy() {
    setState(() {
      boyX = maxXBoy / 2;
      boyY = maxYBoy / 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      resetPositionMap();
                    },
                    child: Text("reset position"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      resetPositionBoy();
                    },
                    child: Text("reset position boy"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      pauseAndPlayMusic();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Music"),
                        Icon(
                          isMusicPlayed
                              ? Icons.volume_up_rounded
                              : Icons.volume_off_rounded,
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  widgetJoystik(),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.height,
            // height: 500,
            color: Colors.black,
            child: Stack(
              children: [
                Positioned(
                  top: posY,
                  right: posX,
                  child: Container(
                    width: isOutside ? 800 : 400,
                    height: isOutside ? 800 : 400,
                    child: Image.asset(
                      "lib/assets/pokemon/image/map/" + imageMap,
                      // width: 950,
                      // height: 950,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: boyY,
                  right: boyX,
                  child: widgetBoy(),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setForbidenArea();
                    },
                    child: Text("add to forbiden area"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      resetForbidenArea();
                    },
                    child: Text("reset forbiden area"),
                  ),
                  Text(
                    "GAME BOY ADVANCE",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "NINTENDO",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 50,
                    ),
                    height: 120,
                    width: 120,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                "A",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 6, 100, 177),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                "B",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  moveTop() {
    print("top");
    setState(() {
      posY = posY - 1;
    });
  }

  moveDown() {
    print("down");
    setState(() {
      posY = posY + 1;
    });
  }

  Widget widgetBoy() {
    return Container(
      width: 40,
      height: 40,
      child: Image.asset(
        "lib/assets/pokemon/image/characters/${directionBoy}_${isWait ? 0 : isWalk ? 1 : directionBoy == 'left' || directionBoy == 'right' ? 0 : 2}.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget widgetJoystik() {
    return Joystick(
      mode: JoystickMode.horizontalAndVertical,
      // stickOffsetCalculator: const RectangleStickOffsetCalculator(),
      listener: (details) {
        print("${details.x},${details.y}");
        moveDirection(details.x, details.y);
      },
      onStickDragEnd: () {
        setState(() {
          isWait = true;
        });
      },
    );
  }

  moveDirection(x, y) {
    // print(checkCanPass());
    setState(() {
      if (x == 0 && y < 0 && checkCanPass("up")) {
        //move up
        directionBoy = "up";
        posY += step;
        checkMoveMap();
        walkAnimation();
      }

      if (x == 0 && y > 0 && checkCanPass("down")) {
        //move down
        directionBoy = "down";
        posY -= step;
        checkMoveMap();
        walkAnimation();
      }

      if (x < 0 && y == 0 && checkCanPass("left")) {
        //move left
        directionBoy = "left";
        posX -= step;
        walkAnimation();
      }

      if (x > 0 && y == 0 && checkCanPass("right")) {
        //move right
        directionBoy = "right";
        posX += step;
        walkAnimation();
      }
    });

    print("X : ${(posX)}, Y ${(posY)}");
    print("Xclean : ${cleanNumber(posX)}, Yclean ${cleanNumber(posY)}");
    // ;
  }

  int cleanNumber(double number) {
    return number.abs().floor();
  }

  setForbidenArea() {
    List<double> data = [];
    data.add(cleanNumber(posX).toDouble());
    data.add(cleanNumber(posY).toDouble());
    if (forbidenArea.where((element) {
          return element[0] == cleanNumber(posX).toDouble() &&
              element[1] == cleanNumber(posY).toDouble();
        }).length ==
        0) {
      forbidenArea.add(data);
    }
    print(forbidenArea);
  }

  resetForbidenArea() {
    forbidenArea.clear();
  }

  checkMoveMap() {
    if ((cleanNumber(posX) == 310 && cleanNumber(posY) == 96) ||
        (cleanNumber(posX) == 140 && cleanNumber(posY) == 120)) {
      setState(() {
        if (imageMap == "littleroot_town.png") {
          posX = 116;
          posY = -118;
        } else {
          posX = 116;
          posY = 90;
          directionBoy = "down";
        }
        imageMap = "house_boy.png";
        isOutside = false;
      });
    } else if (cleanNumber(posX) == 116 && cleanNumber(posY) == 90) {
      setState(() {
        imageMap = "room_boy.png";
        isOutside = false;
        directionBoy = "down";
        posX = 140;
        posY = 120;
      });
    } else if ((cleanNumber(posX) == 116 && cleanNumber(posY) == 118) ||
        cleanNumber(posX) == 142 && cleanNumber(posY) == 118) {
      setState(() {
        imageMap = "littleroot_town.png";
        isOutside = true;
        posX = -310;
        posY = -122;
      });
    }
  }

  walkAnimation() {
    setState(() {
      isWait = false;
      isWalk = !isWalk;
    });
  }
}
