import 'dart:typed_data';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

downloadFile(String url, String filename, func) async {
  var httpClient = http.Client();
  var request = new http.Request('GET', Uri.parse(url));
  var response = httpClient.send(request);
  String dir = (await getApplicationDocumentsDirectory()).path;
  await new Directory(dir + '/downloaded').create();
  print(dir);

  List<List<int>> chunks = new List();

  response.asStream().listen((http.StreamedResponse r) {
    r.stream.listen((List<int> chunk) {
      chunks.add(chunk);
    }, onDone: () async {
      // Save the file
      File file = new File('$dir/downloaded/$filename');
      final Uint8List bytes = Uint8List(r.contentLength);
      int offset = 0;
      for (List<int> chunk in chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      await file.writeAsBytes(bytes);
      if (func != null) func();
      return;
    });
  });
}
