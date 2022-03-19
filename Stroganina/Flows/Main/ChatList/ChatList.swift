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
                            viewModel.newChatButtonTapped()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            viewModel.start()
        }
    }

    var content: some View {
        Group {
            if viewModel.chats.isEmpty {
                Spacer()
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("No chats")
                        .foregroundColor(.tg_grey)
                        .font(.regular(size: 17))
                        .multilineTextAlignment(.center)
                }
                Spacer()
            } else {
                chats
            }
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
                .transition(.opacity)
                .animation(.easeIn)
            }
        }
        .padding(.horizontal, 6)
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
        var delegate: ChatListServiceDelegate?

        func fetchChats() {
            delegate?.didChange(chats: [.mock])
        }
    }
}
