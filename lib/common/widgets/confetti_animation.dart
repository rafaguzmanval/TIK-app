import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ConfettiAnimation extends StatefulWidget
{
  final GlobalKey<ConfettiAnimationState> keyChild;

  ConfettiAnimation({required this.keyChild}) : super(key: keyChild);

  @override
  State<ConfettiAnimation> createState() => ConfettiAnimationState();
}

class ConfettiAnimationState extends State<ConfettiAnimation>
{
  late StateMachineController _controller;

  late SMITrigger _confetti;

  void triggerConfettiFire() {
    _confetti.fire();
  }

  StateMachineController getRiveController(Artboard artboard){
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void onInitChanged(artboard)
  {
    _controller  = getRiveController(artboard);

    _confetti = _controller.findSMI("Trigger explosion") as SMITrigger;
  }


  @override
  Widget build(BuildContext context)
  {
    return RiveAnimation.asset(
      "assets/rive/confetti.riv",
      onInit: onInitChanged
    );
  }
} 