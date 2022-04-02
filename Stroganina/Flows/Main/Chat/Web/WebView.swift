//
//  WebView.swift
//  Stroganina
//
//  Created by Alex Shipin on 23.03.2022.
//

import SwiftUI
import Combine

enum WebViewContent {
    case url(_ url: URL)
    case html(_ html: String)
    case telegram(_ link: String)
}

struct WebView: View {
    @ObservedObject var viewModel: WebViewViewModel

    var body: some View {
        WebContentView(
            content: viewModel.content,
            viewModel: viewModel
        ).frame(
            width: min((viewModel.width ?? 500), 500),
            height: max(viewModel.content.cutHeight(viewModel.height ?? 10), 10)
        )
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
