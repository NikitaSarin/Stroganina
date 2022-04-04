//
//  WebViewViewModel.swift
//  Stroganina
//
//  Created by Alex Shipin on 02.04.2022.
//

import Combine
import WebKit

class WebViewViewModel: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var height: CGFloat?
    @Published var width: CGFloat?

    let content: WebViewContent
    let base: Message

    private let decorator = TelegramMessageScriptDecorator()

    init(content: WebViewContent, base: Message) {
        self.content = content
        self.base = base
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(decorator.createScript(isSelf: base.isOutgoing), completionHandler: { [weak self] (_, error) in
            webView.evaluateJavaScript("document.readyState", completionHandler: {  (complete, error) in
                if complete != nil {
                    webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                        DispatchQueue.main.async {
                            self?.height = (height as? CGFloat)
                        }
                    })
                    webView.evaluateJavaScript("document.body.scrollWidth", completionHandler: { (width, error) in
                        DispatchQueue.main.async {
                            self?.width = (width as? CGFloat)
                        }
                    })
                }
            })
        })
    }
}
