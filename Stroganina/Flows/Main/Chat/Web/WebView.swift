//
//  WebView.swift
//  Stroganina
//
//  Created by Alex Shipin on 23.03.2022.
//

import SwiftUI
import Combine

enum WebViewContent {
    case url(_ url: String)
    case html(_ html: String)
    case telegram(_ link: String)
}

struct WebView: View {
    @ObservedObject var viewModel: WebViewViewModel

    var body: some View {
        VStack(alignment: .leading) {
            switch viewModel.content {
            case .url(let url), .telegram(let url):
                Button {
                    if let url = URL(string: url) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    if viewModel.base.isOutgoing {
                        Text(url.description)
                            .foregroundColor(.tg_link)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(url.description)
                            .multilineTextAlignment(.leading)
                    }
                }
            default:
                EmptyView()
            }
            WebContentView(
                content: viewModel.content,
                viewModel: viewModel
            ).frame(
                height: max(viewModel.content.cutHeight(viewModel.height ?? 10), 10)
            ).frame(
                maxWidth: min((viewModel.width ?? 500), 500)
            )
        }
    }
}

fileprivate extension WebViewContent {
    func cutHeight(_ height: CGFloat) -> CGFloat {
        switch self {
        case .telegram:
            return height
        default:
            break
        }
        return min(height, UIScreen.main.bounds.height / 2)
    }
}
