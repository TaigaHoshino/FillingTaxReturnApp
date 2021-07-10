//
//  HtmlScraper.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/07/10.
//

import Foundation
import WebKit

class WebViewJsExecutor {
    
    private let webView: WKWebView
    
    init(webView: WKWebView) {
        self.webView = webView
    }
    
    public func executeJs(jsScript: String) {
        webView.evaluateJavaScript(jsScript){(result, error) in
            
            print(result)
            
        }
    }
}
