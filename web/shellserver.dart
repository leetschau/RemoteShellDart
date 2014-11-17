import 'dart:io';

int PORT = 8082;

void main() {
  print("Server listening on port $PORT ...");
  HttpServer.bind(InternetAddress.ANY_IP_V4, PORT)
    .then(listenForRequest)
    .catchError((e) => print (e.toString()));
}

listenForRequest(HttpServer _server) {
  _server.listen(
    (HttpRequest request){
      if (request.method == 'GET') {
        handleGet(request);
      } else {
        request.response.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
        request.response.write("Unsupported request: ${request.method}.");
        request.response.close();
      }
    },
    onDone: () => print('No more requests.'),
    onError: (e) => print(e.toString())
  );
}

void handleGet(HttpRequest request) {
  String shellname = request.uri.queryParameters['q'];
  print('Receive shell command $shellname from client.');
  Process.run(shellname, []).then((result) {
    request.response.writeln(result.stdout);
    request.response.close();
  });
}