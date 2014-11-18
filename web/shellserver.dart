import 'dart:io';
import 'dart:convert';

final HOST = InternetAddress.ANY_IP_V4;
// final HOST = InternetAddress.LOOPBACK_IP_V4;
final PORT = 8082;

void main() {
  HttpServer.bind(HOST, PORT).then(
    (_server) {
      _server.listen(
        (HttpRequest req) {
          print('Receive request from client ${req.uri.host}:${req.uri.port}/${req.uri.path}');
          ContentType contentType = req.headers.contentType;
          BytesBuilder builder = new BytesBuilder();

          if (req.method == 'POST' && contentType != null) {
            addCorsHeaders(req.response);
            req.listen(
              (buffer) { builder.add(buffer); },
              onDone: () {
                String jsonString = UTF8.decode(builder.takeBytes());
                Map userInput = JSON.decode(jsonString);
                String shell = userInput['shellname'];
                print("Run shell command: $shell");
                List<String> cmdgrp = shell.split(" ");
                String cmd = cmdgrp[0];
                List<String> params = cmdgrp.getRange(1, cmdgrp.length).toList();
                Process.run(cmd, params).then((result) {
                  Map shellResult = {'shell': result.stdout};
                  req.response.statusCode = HttpStatus.OK;
                  req.response.write(JSON.encode(shellResult));
                  req.response.close();
                });
              });
          } else {
            req.response.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
            req.response.write("Unsupported request: ${req.method}.");
            req.response.close();
          }
        },
        onError: printError );
      print('Server listening for POST on http://$HOST:$PORT');
    },
    onError: printError );
}

//void handlePost(HttpRequest req) {
//  HttpResponse res = req.response;
//  print('${req.method}: ${req.uri.path}');
//
//  addCorsHeaders(res);
//
//  req.listen((List<int> buffer) {
//    res.write('Thanks for the data. This is what I heard you say: ');
//    res.write(new String.fromCharCodes(buffer));
//    res.close();
//  },
//  onError: printError);
//}

void addCorsHeaders(HttpResponse res) {
  res.headers.add('Access-Control-Allow-Origin', '*');
  res.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
}

void printError(error) => print(error);