//
//  WebSocialMediaViewController.swift
//  CVApp
//
//  Created by Victor Chang on 07/11/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import WebKit

class WebSocialMediaViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
//    var progressBar: UIProgressView
    var webView: WKWebView!
    var url: String = "http://www.github.com/ChangVictor"
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let myURL = URL(string: url) else { return }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        
    }
    
    
}
