import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:printer/utis/utils.dart';

class PreviewScreen extends StatelessWidget {
  String htmlContent = "<p><br></p><table class=\"table table-bordered\"><tbody><tr><td><span style=\"background-color: rgb(255, 255, 255);\">Testing</span></td><td><font face=\"Comic Sans MS\">Testing</font><br></td></tr><tr><td>Testing<br></td><td><font face=\"Courier New\">Testing</font><br></td></tr></tbody></table><p><span style=\"color: rgb(34, 34, 34); font-size: small;\"><font face=\"Arial\"><br></font></span></p><ol><li><font color=\"#222222\" face=\"Helvetica\" size=\"2\">Helvetica</font></li></ol><p><span style=\"color: rgb(34, 34, 34); font-size: small;\"><font face=\"Arial\"></p>";
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 100,
      child: WebviewScaffold(
        url: Utils.loadHtml(htmlContent),
        appBar: new AppBar(
          title: new Text("Widget WebView"),
        ), 
      ),
    );
    
  }
}