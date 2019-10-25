
import 'dart:convert';

class Utils {
  static String loadHtml(String html) {
    return Uri.dataFromString(
      '<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><meta http-equiv="X-UA-Compatible" content="ie=edge"><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"><style>p{text-align: justify;}</style></head><body>$html</body></html>',
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();
  }
}