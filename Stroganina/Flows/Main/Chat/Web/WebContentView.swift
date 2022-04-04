//
//  WebContentView.swift
//  Stroganina
//
//  Created by Alex Shipin on 02.04.2022.
//

import Foundation
import WebKit
import UIKit
import SwiftUI

struct WebContentView: UIViewRepresentable {
    private let content: WebViewContent
    private let viewModel: WebViewViewModel

    @Environment(\.colorScheme) var colorScheme

    init(content: WebViewContent, viewModel: WebViewViewModel) {
        self.content = content
        self.viewModel = viewModel
    }

    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = [.all, .audio, .video]

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
            if let url = URL(string: url) {
                webView.load(URLRequest(url: url))
            }
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
