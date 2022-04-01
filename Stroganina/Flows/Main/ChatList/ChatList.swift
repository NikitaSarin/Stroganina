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
        content
            .navigationBarTitle("Chats", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            viewModel.newPersonalChatButtonTapped()
                        } label: {
                            Label(
                                "New personal chat",
                                systemImage: "person"
                            )
                        }
                        Button {
                            viewModel.newGroupButtonTapped()
                        } label: {
                            Label(
                                "New group",
                                systemImage: "person.2"
                            )
                        }
                    }
                    label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(11)
                            .frame(edge: 40)
                    }
                }
            }
            .onAppear {
                viewModel.start()
            }
    }

    var content: some View {
        ScrollView(showsIndicators: false) {
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
        }.padding(.horizontal, 6)
    }

    private var chats: some View {
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
        .animation(.easeIn, value: viewModel.chats)
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatList(
                viewModel: ChatListViewModel(
                    router: ChatListRoutingMock(),
                    service: Service(),
                    store: Store()
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
