//
//  WebViewController.swift
//  Wiki
//
//  Created by Lukas Zelenay on 20/03/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var selectedUrl: String?
    var selectedPageId: String?
    
    @IBOutlet weak var mWKWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedUrl != nil {
            openPage(urlString: selectedUrl!)
        } else if selectedPageId != nil {
            openOfflinePage(id: selectedPageId!)
        }
        
    }

    func openOfflinePage(id: String) {
        let htmlString = SavedPagesController.sharedInstance.getPageData(id: id)
//        print(htmlString)
        if htmlString == "NO_DATA" {
            return
        }
        //MARK: zlozitejsie formatovane stranky sa takto nedaju nacitat https://developer.apple.com/documentation/foundation/urlsessiondownloadtask
        mWKWebView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func openPage(urlString: String){
        guard let url = URL(string: urlString) else {
            return
        }
        mWKWebView.load(URLRequest(url: url))
    }
}
