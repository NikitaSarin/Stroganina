//
//  ChatsListView.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 30.10.2021.
//

import Foundation
import SwiftUI

struct ChatsListView: View {
    @ObservedObject var viewModel: ChatsListViewModel
    
    let factory: ChatMessagesFactory
    
    var body: some View {
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
            }.background(Color.sgn_background)
        }.navigationTitle("Chats")
    }

    private var chats: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 4) {
                    Color.clear
                        .frame(height: 8)
                    ForEach(viewModel.chats) { chat in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(chat.title)
                                    .font(.medium(size: 17))
                                if let message = chat.lastMessage {
                                    factory.content(for: message.type)
                                } else {
                                    Text("No messages here yet")
                                }
                                Divider()
                            }
                        }.onTapGesture {
                            viewModel.tapInChat(chat)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct ChatsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatsListView(
                viewModel: ChatsListViewModel(
                    service: Service(),
                    routing: ChatListRoutingMock()
                ),
                factory: ChatMessagesFactory()
            )
        }
    }

    struct Service: ChatsListServiceProtocol {
        var delegate: ChatsListServiceDelegate? {
            didSet {
                sendChat()
            }
        }
        
        private func sendChat() {
            delegate?.didChange(chats: [.mock])
        }
    }
}
