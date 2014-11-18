import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';

@CustomTag('shell-runner')
class ShellRunner extends PolymerElement {

  final IP = "10.31.4.73";
  // final IP = "127.0.0.1";
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

    var url = 'http://$IP:$PORT';
    String inputData = JSON.encode(input);
    print('Send $inputData to $url');
    request.open('POST', url);
    request.send(inputData);
  }

  void onData(_) {
    print('Receive data from server: ${request.responseText}');
    if (request.readyState == HttpRequest.DONE &&
        request.status == 200) {
      Map recData = JSON.decode(request.responseText);
      serverResponse = recData['shell'];
    } else if (request.readyState == HttpRequest.DONE &&
        request.status == 0) {
      serverResponse = 'No server connected.';
    }
  }

  void resetForm(Event e, var detail, Node target) {
    e.preventDefault();
    input['shellname'] = '';
    serverResponse = '';
  }
}