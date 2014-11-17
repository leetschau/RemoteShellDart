import 'package:polymer/builder.dart';

main(args) {
  build(entryPoints: ['web/shellclient.html'],
        options: parseOptions(args));
}
