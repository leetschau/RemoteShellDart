//import 'dart:io';
import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('shell-runner')
class ShellRunner extends PolymerElement {
  @observable String shellname = "";
  @observable String shellresult = "";

  ShellRunner.created() : super.created() {
  }

  void runshell() {
    print("Now shell $shellname runs.");
    shellresult = "result of $shellname";
  }
}