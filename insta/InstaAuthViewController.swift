//
//  TMDBAuthViewController.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit
import OAuthSwift

class InstaAuthViewController: OAuthWebViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var targetURL : NSURL = NSURL()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.frame = UIScreen.mainScreen().applicationFrame
        self.webView.scalesPageToFit = true
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        loadAddressURL()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func setUrl(url: NSURL) {
        targetURL = url
    }
    func loadAddressURL() {
        let req = NSURLRequest(URL: targetURL)
        self.webView.loadRequest(req)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.URL!.scheme == "instaplaces"){
            println(request.URL)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        return true
    }

    func cancelAuth() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}