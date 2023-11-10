import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CheckAnimation extends StatefulWidget
{
  final GlobalKey<CheckAnimationState> keyChild;

  CheckAnimation({required this.keyChild}) : super(key: keyChild);

  @override
  State<CheckAnimation> createState() => CheckAnimationState();
}

class CheckAnimationState extends State<CheckAnimation>
{
  late StateMachineController _controller;

  late SMITrigger _check;
  late SMITrigger _error;
  late SMITrigger _reset;

  void triggerCheckFire() {
    _check.fire();
  }

  void triggerErrorFire() {
    _error.fire();
  }

  void triggerResetFire() {
    _reset.fire();
  }

  StateMachineController getRiveController(Artboard artboard){
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void onInitChanged(artboard)
  {
    _controller  = getRiveController(artboard);
    
    _check = _controller.findSMI("Check") as SMITrigger;
    _error = _controller.findSMI("Error") as SMITrigger;
    _reset = _controller.findSMI("Reset") as SMITrigger;
  }

  @override
  Widget build(BuildContext context)
  {
    return RiveAnimation.asset(
      "assets/rive/checkerror.riv",
      onInit: onInitChanged
    );
  }
} 