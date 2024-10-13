import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, required this.url});

  final String url;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  late WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress;  // Update progress value
            });
          },
          onPageStarted: (String url) {
            // You can add any logic here when a page starts loading
          },
          onPageFinished: (String url) {
            // You can add any logic here when a page finishes loading
          },
          onWebResourceError: (WebResourceError error) {
            // Handle errors if necessary
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.url, style: const TextStyle(color: Colors.white),),
        bottom: _progress < 100
            ? PreferredSize(
          preferredSize: const Size(double.infinity, 4.0),
          child: LinearProgressIndicator(
            value: _progress / 100.0,  // Show progress as a fraction
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        )
            : null,
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_ios, color: Colors.white,)),

        actions: [
          IconButton(onPressed: () {
            Clipboard.setData(ClipboardData(text: widget.url));  // Copy text to clipboard
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Link Copied to Clipboard', style: TextStyle(color: Colors.white),), backgroundColor: Colors.blueAccent, elevation: 8,),
            );
          }, icon: const Icon(Icons.copy, color: Colors.white,))
        ],
      ),
      
      body: WebViewWidget(controller: _controller),
    );
  }
}

