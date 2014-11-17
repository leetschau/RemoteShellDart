import 'dart:io';

//final HOST = InternetAddress.ANY_IP_V4;
final HOST = InternetAddress.LOOPBACK_IP_V4;
final PORT = 8082;

void main() {
  print("Server listening on port $PORT ...");
  HttpServer.bind(HOST, PORT).then(gotMessage, onError: printError);
}

void gotMessage(_server) {
  _server.listen((HttpRequest request) {
    switch (request.method) {
      case 'POST':
        handlePost(request);
        break;
      case 'OPTIONS':
        handleOptions(request);
        break;
      default: defaultHandler(request);
    }
  },
  onError: printError); // .listen failed
  print('Listening for GET and POST on http://$HOST:$PORT');
}

void handlePost(HttpRequest req) {
  HttpResponse res = req.response;
  print('${req.method}: ${req.uri.path}');

  addCorsHeaders(res);

  req.listen((List<int> buffer) {
    // return the data back to the client
    res.write('Thanks for the data. This is what I heard you say: ');
    res.write(new String.fromCharCodes(buffer));
    res.close();
  },
  onError: printError);
}

void addCorsHeaders(HttpResponse res) {
  res.headers.add('Access-Control-Allow-Origin', '*');
  res.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
}

void handleOptions(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  print('${req.method}: ${req.uri.path}');
  res.statusCode = HttpStatus.NO_CONTENT;
  res.close();
}

void defaultHandler(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NOT_FOUND;
  res.write('Not found: ${req.method}, ${req.uri.path}');
  res.close();
}

void printError(error) => print(error);