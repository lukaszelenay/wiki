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
    var selectedPageId: String?
    
    
    override func loadView() {
        //toto nikdy nesmies volat
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedUrl != nil {
            openPage(urlString: selectedUrl!)
        } else {
            return
        }
        
    }
    
    
    //tato funkcia bude nahradena
    func openPage(id: String) {
        let htmlString = SavedPagesController.sharedInstance.getPageData(id: id)
        print(htmlString)
        if htmlString == "NO_DATA" {
            return
        }

        let webView = WKWebView()
        webView.loadHTMLString(htmlString, baseURL: nil)
        
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
