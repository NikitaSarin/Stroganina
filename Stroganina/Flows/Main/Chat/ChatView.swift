//
//  ChatView.swift
//  Pentagram
//
//  Created by Сарин Никита Сергеевич on 21.03.2021.
//

import SwiftUI

struct ChatView: View {

    @ObservedObject var viewModel: ChatViewModel
    @State private var initialScroll = true

    let factory: ChatMessagesFactory

    var body: some View {
        ZStack {
            Color.sgn_surface
                .ignoresSafeArea(.container, edges: .bottom)
            content
        }
        .navigationBarTitle(viewModel.chat.title, displayMode: .inline)
        .onAppear {
            viewModel.start()
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ZStack {
                    if viewModel.isEnabledAddNewUser {
                        Button {
                            viewModel.addUsersInChat()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }

    private var content: some View {
        VStack(spacing: 0) {
            if viewModel.history.isEmpty {
                Spacer()
                Text("No messages\nhere yet")
                    .foregroundColor(.tg_grey)
                    .font(.regular(size: 17))
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                messages
            }
            SendMessagePanel(
                text: $viewModel.messageText,
                delegate: viewModel
            )
        }
        .background(Color.sgn_background)
    }

    private var messages: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 4) {
                Color.clear
                    .frame(height: 8)
                ForEach(viewModel.history) { item in
                    HistoryItemView(item: item, factory: factory)
                        .onAppear {
                            viewModel.viewDidShow(item)
                        }
                }
            }
        }
        .flip()
        .padding(.horizontal, 8)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct HistoryItemView: View {
    let item: HistoryItem
    let factory: ChatMessagesFactory

    var body: some View {
        ZStack {
            switch item {
            case .new:
                Spacer(minLength: 10)
            case .empty:
                Spacer(minLength: 100)
            case .message(let wrapper):
                factory.bubble(for: wrapper.type) {}.flip()
            }
        }
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(
                viewModel: ChatViewModel(
                    chat: .mock,
                    service: ChatService.Mock(),
                    router: ChatRoutingMock()
                ),
                factory: ChatMessagesFactory()
            )
        }
    }
}
