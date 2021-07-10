//
//  BankWebViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/07/10.
//

import UIKit
import WebKit

class BankWebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    public static var initialController: Self {
        get{
            let storyboard = UIStoryboard(name: "BankWeb", bundle: nil)
            let viewController = storyboard.instantiateViewController(identifier: "BankWebViewController") as! Self
            return viewController
        }
    }
    
    private func openUrl(strUrl: String) {
        let url = URL(string: strUrl)!
        let request = URLRequest(url: url)
        webView.load(request)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        openUrl(strUrl: URLCollection.mizuhoDirectLogin)
//        // Do any additional setup after loading the view.
    }
    
    @IBAction func scrapingButtonClick(_ sender: Any) {
        let jsExecutor = WebViewJsExecutor(webView: webView)
        jsExecutor.executeJs(jsScript: "document.body.innerHTML")
    }
    
}
