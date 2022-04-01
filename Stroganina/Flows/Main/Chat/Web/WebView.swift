//
//  WebView.swift
//  Stroganina
//
//  Created by Alex Shipin on 23.03.2022.
//

import SwiftUI
import Combine
import WebKit
import UIKit
import ObjectiveC

enum WebViewContent {
    case url(_ url: URL)
    case html(_ html: String)
    case telegram(_ link: String)
}

struct WebView: View {
    let content: WebViewContent
    @ObservedObject private var viewModel = WebViewViewModel()

    var body: some View {
        WebContentView(
            content: content,
            viewModel: viewModel
        ).frame(
            height: max(content.cutHeight(viewModel.height ?? 10), 10)
        )
    }
}

fileprivate struct WebContentView: UIViewRepresentable {
    private let content: WebViewContent
    private let viewModel: WebViewViewModel

    @Environment(\.colorScheme) var colorScheme

    fileprivate init(content: WebViewContent, viewModel: WebViewViewModel) {
        self.content = content
        self.viewModel = viewModel
    }

    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences

        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)

        webView.contentMode = .scaleToFill
        webView.contentScaleFactor = 10
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = false

        webView.navigationDelegate = viewModel
        webView.backgroundColor = .clear

        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        switch content {
        case .url(let url):
            webView.load(URLRequest(url: url))
        case .html(let html):
            webView.loadHTMLString(html, baseURL: nil)
        case .telegram(let link):
            let urlString = link + "?embed=1&userpic=false&dark=\((colorScheme == .dark ? "1" : "0"))"
            if let url = URL(string: urlString) {
                webView.load(URLRequest(url: url))
            }
        }
    }
}

fileprivate extension WebViewContent {
    func cutHeight(_ height: CGFloat) -> CGFloat {
        switch self {
        case .telegram:
            return height
        default:
            return min(height, UIScreen.main.bounds.height / 2)
        }
    }
}

fileprivate class WebViewViewModel: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var height: CGFloat?

    private let telegramMessageScript = """
        document.getElementsByClassName('tgme_widget_message_user')[0].remove();
        document.getElementsByClassName('tgme_widget_message_bubble_tail')[0].remove();
        document.getElementsByClassName('tgme_widget_message_bubble_logo')[0].remove();
        document.getElementsByClassName('tgme_widget_message js-widget_message')[0].innerHTML =
        document.getElementsByClassName('tgme_widget_message js-widget_message')[0].innerHTML.replace('class=\"tgme_widget_message_bubble\"', '');
    """

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript(telegramMessageScript, completionHandler: { [weak self] (_, _) in
            webView.evaluateJavaScript("document.readyState", completionHandler: {  (complete, error) in
                if complete != nil {
                    webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                        DispatchQueue.main.async {
                            self?.height = (height as? CGFloat)
                        }
                    })
                }
            })
        })
    }
}
