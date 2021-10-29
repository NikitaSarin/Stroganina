//
//  ChatView.swift
//  Pentagram WatchKit Extension
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
        .navigationTitle(viewModel.chat.title)
    }

    private var content: some View {
        VStack(spacing: 0) {
            if viewModel.history.isEmpty {
                Spacer()
                Text("No messages\nhere yet")
                    .foregroundColor(.tg_grey)
                    .font(.reqular(size: 17))
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
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 4) {
                    Color.clear
                        .frame(height: 8)
                    ForEach(viewModel.history) { wrapper in
                        factory.bubble(for: wrapper.type) {}
                        .flip()
                            .id(wrapper.id)
                            .onAppear {
                                if wrapper.id == viewModel.history.last?.id {
                                    viewModel.loadNewMessagesIfNeeded()
                                }
                            }
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


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(
            viewModel: ChatViewModel(
                chat: .mock,
                service: Service()
            ),
            factory: ChatMessagesFactory()
        )
    }

    struct Service: ChatServiceProtocol {
        var allMessagesFetched = true
        weak var delegate: ChatServiceDelegate?

        func send(text: String, completion: @escaping BoolClosure) {}

        func fetch(from messageId: Message.ID?) {
            let messages: [MessageWrapper] = (0...20).map { index in
                MessageWrapper(
                    type: .text(.init(base: .mock(id: index), text: "Hello"))
                )
            }
            delegate?.didChange(messages: messages)
        }
    }
}
