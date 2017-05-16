//
//  UrlWebViewController.swift
//  SafariExtension
//
//  Created by siavash abbasalipour on 16/5/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import Foundation
import UIKit

class UrlWebViewController: UIViewController {
  
  // MARK:- Public Property
  var urlString: String?
  
  // MARK:- View Outlets
  @IBOutlet weak var webView: UIWebView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  // MARK:- View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    webView.delegate = self
    if let url = URL.init(string: urlString ?? "") { // load the WebView if `URL` exists
      spinner.startAnimating()
      let request = URLRequest.init(url: url)
      webView.loadRequest(request)
    }
  }
}
// MARK:- UIWebViewDelegate
extension UrlWebViewController: UIWebViewDelegate {
  func webViewDidFinishLoad(_ webView: UIWebView) {
    spinner.stopAnimating()
  }
}
