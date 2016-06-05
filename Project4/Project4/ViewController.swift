//
//  ViewController.swift
//  Project4
//
//  Created by Daniel Loureda Arteaga on 3/6/16.
//  Copyright © 2016 Daniel Loureda Arteaga. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView : WKWebView!
    var progressView : UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.allowsBackForwardNavigationGestures = true
        openPageWithUrl(websites[0])
        addRightBarButtonItem()
        addToolbarItems()
        addProgressObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // MARK: - Observer methods
    
    func addProgressObserver() {
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // MARK: - Webview delegate methods
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.URL
        
        if let host = url!.host {
            for website in websites {
                if host.rangeOfString(website) != nil {
                    decisionHandler(.Allow)
                    return
                }
            }
        }
        
        decisionHandler(.Cancel)
    }
    
    // MARK: - Configure view methods
    
    func addToolbarItems(){
        let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        progressView = UIProgressView(progressViewStyle: .Default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.toolbarHidden = false
    }
    
    func addRightBarButtonItem(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .Plain, target: self, action: #selector(openTapped))
    }
    
    func openTapped(){
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .ActionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .Default, handler: openPageWithAction))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func openPageWithAction(action : UIAlertAction!){
        openPageWithUrl(action.title!)
    }
    
    func openPageWithUrl(url : String){
        loadPage("https://" + url)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        title = webView.title
    }
    
    func loadPage(stringUrl : String){
        let url = NSURL(string: stringUrl)!
        webView.loadRequest(NSURLRequest(URL: url))
    }
}

