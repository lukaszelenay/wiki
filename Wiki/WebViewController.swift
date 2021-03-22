//
//  WebViewController.swift
//  Wiki
//
//  Created by Lukas Zelenay on 20/03/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    var selectedUrl: String?
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = selectedUrl else {
            return
        }
        openPage(urlString: url)
    }
    
    
    func openPage(urlString: String){
        
        guard let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
}
