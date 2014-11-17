import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('shell-runner')
class ShellRunner extends PolymerElement {
  @observable Map input = toObservable({'shellname' : ''});
  @observable String shellresult = "";

  ShellRunner.created() : super.created() {
  }

  void runshell() {
    print("Send shell command ${input['shellname']} to server.");

  }
}