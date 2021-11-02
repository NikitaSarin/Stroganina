//
//  ChatListView.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation
import SwiftUI

struct ChatList: View {

    @ObservedObject var viewModel: ChatListViewModel

    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Chats", displayMode: .large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.makeChatButtonTapped()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }

    var content: some View {
        ZStack {
            Color.sgn_surface
                .ignoresSafeArea(.container, edges: .bottom)
            Group {
                if viewModel.chats.isEmpty {
                    Spacer()
                    Text("No chats")
                        .foregroundColor(.tg_grey)
                        .font(.reqular(size: 17))
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    chats
                }
            }
            .background(Color.sgn_background)
        }
    }

    private var chats: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 4) {
                    Color.clear
                        .frame(height: 8)
                    ForEach(viewModel.chats) { chat in
                        ChatRow(chat: chat)
                            .onTapGesture {
                                viewModel.didTap(on: chat)
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatList(
                viewModel: ChatListViewModel(
                    service: Service(),
                    store: Store(),
                    routing: ChatListRoutingMock()
                )
            )
        }
    }

    struct Service: ChatListServiceProtocol {
        var delegate: ChatListServiceDelegate? {
            didSet {
                sendChat()
            }
        }
        
        private func sendChat() {
            delegate?.didChange(chats: [.mock])
        }
    }
}
