import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static Future<void> launchURL(String url) async {
    if (url.isEmpty) return;
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently or show a snackbar
      print('Error launching URL: $e');
    }
  }
}