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
    
    var progressBar: UIProgressView?
    var webView: WKWebView!
    var url: String = "https://www.instagram.com/veectorch/"
    

    override func loadView() {

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let progressBar = progressBar else { return }
        view.addSubview(progressBar)
        progressBar.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        
        
        progressBar.progress = 0.0
        webView.navigationDelegate = self
        webView.uiDelegate = self
        guard let myURL = URL(string: url) else { return }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        setupNavigationButtons()
        
    }
    
    fileprivate func setupNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleCancel))
    }
    
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func webView(webView: WKWebView!, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError!) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressBar?.progress = Float(webView.estimatedProgress)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressBar?.isHidden = true
    }
}
