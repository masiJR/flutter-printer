import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_web/flutter_native_web.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:image/image.dart';
import 'package:printer/file_storage.dart';
import 'package:printer/utis/utils.dart';
import 'package:wifi/wifi.dart';
import 'package:network_pos_printer/network_pos_printer.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:flutter_native_web/flutter_native_web.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
const kCanvasSize = 200.0;
String htmlContent = "<p><br></p><table class=\"table table-bordered\"><tbody><tr><td><span style=\"background-color: rgb(255, 255, 255);\">Testing</span></td><td><font face=\"Comic Sans MS\">Testing</font><br></td></tr><tr><td>Testing<br></td><td><font face=\"Courier New\">Testing</font><br></td></tr></tbody></table><p><span style=\"color: rgb(34, 34, 34); font-size: small;\"><font face=\"Arial\"><br></font></span></p><ol><li><font color=\"#222222\" face=\"Helvetica\" size=\"2\">Helvetica</font></li></ol><p><span style=\"color: rgb(34, 34, 34); font-size: small;\"><font face=\"Arial\"></p>";
String abc = '<html><html lang="en"><head><link rel="stylesheet"><href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css"><style type=\"text/css\></script><link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous"><style>p{text-align: justify;}</style></head><body>$htmlContent</body></html>';
// StringCodec adata = '<html><head><link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
//                         + "<script src="https:maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>"
//                         + "<style type=\"text/css\">body{background-color: transparent;}"
//                         + "</style></head>"
//                         + "<body>"
//                         + productsResponse.getData().getDescription()
//                         + "</body></html>"



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discover Printers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebController webController;
   

  int _counter = 0;
  File _imageFile;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController(); 
  GlobalKey globalKey = GlobalKey();
  FileStorage fileStorage = FileStorage();
  String localIp = '';
  List<String> devices = [];
  bool isDiscovering = false;
  int found = -1;
  TextEditingController portController = TextEditingController(text: '9100');

  void discover(BuildContext ctx) async {
    setState(() {
      isDiscovering = true;
      devices.clear();
      found = -1;
    });

    String ip;
    try {
      ip = await Wifi.ip;
      print('local ip:\t$ip');
    } catch (e) {
      final snackBar = SnackBar(
          content: Text('WiFi is not connected', textAlign: TextAlign.center));
      Scaffold.of(ctx).showSnackBar(snackBar);
      return;
    }
    setState(() {
      localIp = ip;
    });

    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    int port = 9100;
    try {
      port = int.parse(portController.text);
    } catch (e) {
      portController.text = port.toString();
    }
    print('subnet:\t$subnet, port:\t$port');

    final stream = NetworkAnalyzer.discover(subnet, port);

    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
        setState(() {
          devices.add(addr.ip);
          found = devices.length;
        });
      }
    })
      ..onDone(() {
        setState(() {
          isDiscovering = false;
          found = devices.length;
        });
      })
      ..onError((dynamic e) {
        final snackBar = SnackBar(
            content: Text('Unexpected exception', textAlign: TextAlign.center));
        Scaffold.of(ctx).showSnackBar(snackBar);
      });
  }
  
  Future<ByteData> generateImage() async {
    // final color = Colors.primaries[widget.rd.nextInt(widget.numColors)];

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromPoints(Offset(0.0, 0.0), Offset(kCanvasSize, kCanvasSize)));

    final stroke = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, 600, kCanvasSize), stroke);

    TextSpan companyName = TextSpan(style: new TextStyle(color: Colors.black,fontSize: 40), text: 'វិក័យប័ត្រ');
    TextPainter tpCompanyName = new TextPainter(text: companyName,textAlign: TextAlign.center,textDirection:TextDirection.ltr );
    tpCompanyName.layout();
    tpCompanyName.paint(canvas, new Offset(200.0, 5.0));

    TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.black,fontSize: 20), text:'');
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.justify, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(5.0, 90.0));
    

    // TextSpan span = new TextSpan(
    //     style: new TextStyle(color: Colors.black,fontSize: 20), text: 'AEON CAMBODIA CO>LTD (100-00011)\nAEON CAMBODIA CO>LTD\nAEON CAMBODIA CO>LTD (100-00011)');
    // TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.justify, textDirection: TextDirection.ltr);
    // tp.layout();
    // tp.paint(canvas, new Offset(5.0, 90.0));
    
    // TextSpan col = new TextSpan(
    //   style: new TextStyle(color: Colors.black,fontSize: 20),text: '-----------------------------------------------------------------------------------------------'
    // );
    // TextPainter tpCol = TextPainter(text: col,textAlign: TextAlign.start,textDirection: TextDirection.ltr);
    // tpCol.layout();
    // tpCol.paint(canvas, new Offset(5.0, 150));

    // TextSpan textSpanProduct = new TextSpan(
    //     style: new TextStyle(color: Colors.black,fontSize: 20), text: 'Product');
    // TextPainter tp2 = new TextPainter(text: textSpanProduct, textAlign: TextAlign.start, textDirection: TextDirection.rtl);
    // tp2.layout();
    // tp2.paint(canvas, new Offset(5.0, 170.0));

  
    

    final picture = recorder.endRecording();
    final img = await picture.toImage(600, 200);
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);

    return pngBytes;
  }
  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    final Image imageDecode = decodeImage(pngBytes);
    print(pngBytes);



    Printer.connect('10.10.77.122', port: 9100).then((printer) {
    printer.printImage(imageDecode);
    printer.println('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.println('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: PosCodeTable.westEur));
    printer.println('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: PosCodeTable.westEur));

    printer.println('Bold text', styles: PosStyles(bold: true));
    printer.println('Reverse text', styles: PosStyles(reverse: true));
    printer.println('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);

    printer.println('Align left', styles: PosStyles(align: PosTextAlign.left));
    printer.println('Align center',
        styles: PosStyles(align: PosTextAlign.center));
    printer.println('Align right',
        styles: PosStyles(align: PosTextAlign.right), linesAfter: 1);
    
    printer.println('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    //printer.printImage(imageDecode);

    printer.cut();
    printer.disconnect();
  });
  }


  void printSpecificDevice(String printerIp, BuildContext ctx) {

    Printer.connect(printerIp,
            port: int.parse(portController.text), timeout: Duration(seconds: 5))
        .then((printer) async {

          //fileStorage.downloadPDFFile("url", "filename.pdf");
        
         // Print image from assets folder
      // final ByteData data = await rootBundle.load('assets/images/logo.png');
      // final Uint8List uint8list = data.buffer.asUint8List();
      // final Image imageDecode = decodeImage(uint8list);
      // print(imageDecode);
    
      // Print Canvas Image
      // final dataFile = await generateImage();
      // final file = await fileStorage.writeCounter(Uint8List.view(dataFile.buffer));
      // printer.printImage(decodeImage(file.readAsBytesSync()));


      //Print Image 
      var im = decodeImage(_imageFile.readAsBytesSync());
      Image thumbnail = copyResize(im, width: 600);
      printer.printImage(thumbnail);


      
      printer.cut();
      printer.disconnect();

      final snackBar =
          SnackBar(content: Text('Success', textAlign: TextAlign.center));
      Scaffold.of(ctx).showSnackBar(snackBar);
    }).catchError((dynamic e) {
      print(e);
      final snackBar =
          SnackBar(content: Text('Fail', textAlign: TextAlign.center));
      Scaffold.of(ctx).showSnackBar(snackBar);
    });
  }
  void multiplePrinting(List<String> printerIp, BuildContext ctx) {

    for(int i = 0;i< printerIp.length;i++){

      Printer.connect(printerIp[i],
            port: int.parse(portController.text), timeout: Duration(seconds: 5))
        .then((printer) async {
      printer.println('Normal text Testing by mobile phone using Flutter');
      printer.println('Special កែវ',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          codeTable: PosCodeTable.westEur
        ));
      
     printer.println('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: PosCodeTable.westEur));
    printer.println('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: PosCodeTable.westEur));

    printer.println('Bold text', styles: PosStyles(bold: true));
    printer.println('Reverse text', styles: PosStyles(reverse: true));
    printer.println('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);

    printer.println('Align left', styles: PosStyles(align: PosTextAlign.left));
    printer.println('Align center',
        styles: PosStyles(align: PosTextAlign.center));
    printer.println('Align right',
        styles: PosStyles(align: PosTextAlign.right), linesAfter: 1);
    
    printer.println('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

      printer.cut();
      printer.disconnect();

      final snackBar =
          SnackBar(content: Text('Success', textAlign: TextAlign.center));
      Scaffold.of(ctx).showSnackBar(snackBar);
    }).catchError((dynamic e) {
      print('exception');
      final snackBar =
          SnackBar(content: Text('Fail', textAlign: TextAlign.center));
      Scaffold.of(ctx).showSnackBar(snackBar);
    });

    }
    
  }

  void locaPrintDocs(String deviceIp,BuildContext context){
     NetworkPOSPrinter.connect(deviceIp, 9100).then((printer) {

    printer.writeLineWithStyle('Test with style'.toUpperCase(),
        style: NetworkPOSPrinterStyle(
          justification: NetworkPOSPrinterJustification.center,
          width: NetworkPOSPrinterTextSize.size2,
          height: NetworkPOSPrinterTextSize.size2,
          font: NetworkPOSPrinterFont.fontB,
        ),
        linesAfter: 1);

    // total width of columns must be equal to 12
    printer.writeRow(<NetworkPOSColumn>[
      NetworkPOSColumn(
        text: 'left align',
        width: 6,
        style: NetworkPOSPrinterStyle(
            bold: true, justification: NetworkPOSPrinterJustification.left),
      ),
      NetworkPOSColumn(
        text: 'right align',
        width: 6,
        style: NetworkPOSPrinterStyle(
            bold: true, justification: NetworkPOSPrinterJustification.right),
      ),
    ]);

    printer.setBold(true);

    printer.resetToDefault();

    printer.setInverse(true);
    printer.writeLine('Test inverse');

    printer.resetToDefault();

    printer.setUnderline(NetworkPOSPrinterUnderline.single);

      String stringToEncode = 'lll';

        // encoding

        var bytesInLatin1 = latin1.encode(stringToEncode);
        // [68, 97, 114, 116, 32, 105, 115, 32, 97, 119, 101, 115, 111, 109, 101]

        var base64encoded = base64.encode(bytesInLatin1);
        // RGFydCBpcyBhd2Vzb21l
         var bytesInLatin1_decoded = base64.decode(base64encoded);
        // [68, 97, 114, 116, 32, 105, 115, 32, 97, 119, 101, 115, 111, 109, 101]

        var initialValue = latin1.decode(bytesInLatin1_decoded);
    printer.writeLine('\u1780\u17b6\u179a\u179f\u17b7\u1780\u17d2\u179f\u17b6');

    printer.resetToDefault();

    printer.setJustification(NetworkPOSPrinterJustification.center);
    printer.writeLine(bytesInLatin1);
    


    printer.resetToDefault();
    

    printer.setFont(NetworkPOSPrinterFont.fontB);
    printer.writeLine('Test font');
    // total width of columns must be equal to 12
    printer.writeRow(<NetworkPOSColumn>[
      NetworkPOSColumn(
        text: 'left align',
        width: 6,
        style: NetworkPOSPrinterStyle(
            bold: true, justification: NetworkPOSPrinterJustification.left),
      ),
      NetworkPOSColumn(
        text: 'right align',
        width: 6,
        style: NetworkPOSPrinterStyle(
            bold: true, justification: NetworkPOSPrinterJustification.right),
      ),
    ]);

    // space blanks before cut
    printer.writeLines(List.filled(5, ''));

    printer.cut();

    printer.close().then((v) {
      printer.destroy();
    });
  }).catchError((error) {
    print('error : $error');
  });
  }
  

  @override
  Widget build(BuildContext context) {
     FlutterNativeWeb flutterWebView = new FlutterNativeWeb(
      onWebCreated: onWebCreated,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                        Factory<OneSequenceGestureRecognizer>(
                          () => TapGestureRecognizer(),
                        ),
                      ].toSet(),
    );
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Printers'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: portController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Port',
                    hintText: 'Port',
                  ),
                ),
                SizedBox(height: 10),
                Text('Local ip: $localIp', style: TextStyle(fontSize: 16)),
                SizedBox(height: 15),
                
          
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                    height: 300.0,
                    child: HtmlWidget(
                      Utils.loadHtml(Utils.loadHtml(abc)),
                      // webView: true,
                    )
          
              ),
                ),
                
                SizedBox(height: 15),
                RaisedButton(
                  child: new Text('Print all Printer devices'),
                  onPressed:()=> {},
                  //multiplePrinting(devices, context),
                ),
                RaisedButton(
                    child: Text(
                        '${isDiscovering ? 'Discovering...' : 'Discover'}'),
                    onPressed: isDiscovering ? null : () => discover(context)),
                SizedBox(height: 15),
                found >= 0
                    ? Text('Found: $found device(s)',
                        style: TextStyle(fontSize: 16))
                    : Container(),
                Expanded(
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(devices[index]=='10.10.77.11'){
                        return Container();
                      }else if (devices[index] == '10.10.77.139'){
                        return Container();
                        
                      }
                      return 
                           InkWell(
                          onTap: () => 
                          printSpecificDevice(devices[index], context),
                          //  Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => PreviewScreen()),
                          // ),

     
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 60,
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.print),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            '${devices[index]}:${portController.text}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'Click to print a test receipt',
                                            style: TextStyle(
                                                color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        );
                    },
                  ),
                )
              ],
            ),
          );
          
        },
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: () {
          _imageFile = null;
          screenshotController
              .capture(pixelRatio: 20)
              .then((File image) async {
            //print("Capture Done");
            setState(() {
              _imageFile = image;
              print(_imageFile);
            });
            // final result =
            //     await ImageGallerySaver.save(image.readAsBytesSync()); // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
            // print("File Saved to Gallery");
          }).catchError((onError) {
            print(onError);
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void onWebCreated(webController) {
    this.webController = webController;
    this.webController.loadData(Utils.loadHtml(htmlContent));
    this.webController.onPageStarted.listen((url) =>
        print("Loading $url")
    );
    this.webController.onPageFinished.listen((url) =>
        print("Finished loading $url")
    );
}

}