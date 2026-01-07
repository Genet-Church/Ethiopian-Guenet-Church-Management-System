import 'dart:html' as html;

class UrlLauncherService {
  void openInNewTab(String url) {
    // Uses the dart:html package to open a new browser tab.
    // This is the most reliable method for Flutter Web.
    html.window.open(url, '_blank');
  }
}