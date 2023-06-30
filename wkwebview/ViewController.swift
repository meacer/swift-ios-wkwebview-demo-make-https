//
//  ViewController.swift
//  wkwebview
//
//  Created by Afrar Malakooth on 6/5/20.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set a content filter:
      let blockRules = """
          [{
              "trigger": {
                  "url-filter": "http://.*",
                  "resource-type": ["image", "media"],
                  "if-top-url" : ["https://.*" ]
              },
              "action": {
                  "type": "make-https"
              }
          }]
       """
      WKContentRuleListStore.default().compileContentRuleList(
          forIdentifier: "ContentBlockingRules",
          encodedContentRuleList: blockRules) { (contentRuleList, error) in
              assert (error == nil)
              let configuration = self.webView.configuration
              configuration.userContentController.add(contentRuleList!)
      }

        // HTTP image on an HTTPS page:
        // let url = URL(string: "https://www.mixedcontentexamples.com/Test/NonSecureImage")!

        // HTTP Image with a dynamic response:
         let url = URL(string: "https://regular-puzzling-leo.glitch.me")!

        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

}

extension ViewController: WKNavigationDelegate {

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("Finished navigating to url: \(webView.url)")

    // webView.hasOnlySecureContent should be true with make-https:
    print("Has only secure content: \(webView.hasOnlySecureContent)");
  }

}
