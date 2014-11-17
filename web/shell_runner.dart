import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('shell-runner')
class ShellRunner extends PolymerElement {

//  final IP = "10.31.4.73";
  final IP = "127.0.0.1";
  final PORT = 8082;

  @observable Map input = toObservable({'shellname' : ''});
  @observable String serverResponse = "";

  ShellRunner.created() : super.created() {
  }

  HttpRequest request;

  void submitForm(Event e, var detail, Node target) {
    e.preventDefault(); // Don't do the default submit.

    request = new HttpRequest();

    request.onReadyStateChange.listen(onData);

    // POST the data to the server.
    var url = 'http://$IP:$PORT';
    print("url: $url");
    print('-----');
    print(_shellAsJsonData());
    print('-----');
    request.open('POST', url);
    request.send(_shellAsJsonData());
  }

  void onData(_) {
    if (request.readyState == HttpRequest.DONE &&
        request.status == 200) {
      // Data saved OK.
      serverResponse = request.responseText;
    } else if (request.readyState == HttpRequest.DONE &&
        request.status == 0) {
      // Status is 0...most likely the server isn't running.
      serverResponse = 'No server connected.';
    }
  }

  void resetForm(Event e, var detail, Node target) {
    e.preventDefault();
    input['shellname'] = '';
    serverResponse = '';
  }

  String _shellAsJsonData() {
    return JSON.encode(input);
  }
}