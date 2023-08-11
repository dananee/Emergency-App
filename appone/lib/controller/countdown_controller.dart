import 'package:get/get.dart';
import 'package:timer_count_down/timer_controller.dart';

class CountDownController extends GetxController {
  final countdown = 60.obs; // Replace with your desired countdown duration
  final CountdownController _controller = CountdownController();

  void startCountdown() {
    _controller.restart();
    // _controller.start();
  }
}
