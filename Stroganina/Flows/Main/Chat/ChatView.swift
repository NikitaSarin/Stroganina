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
        VStack(spacing: 4) {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 4) {
                        content
                    }
                }
            }
            .padding(.horizontal, 8)
            .flip()
            .transition(.opacity)
            .animation(.easeInOut)
            .edgesIgnoringSafeArea(.bottom)
            .background(Color.tg_white)
            .navigationTitle(viewModel.chat.title)
        }
    }

    private var bottomSpacer: some View {
        Spacer(minLength: 20)
    }

    private var content: some View {
        Group {
            Spacer(minLength: 20)
            ForEach(viewModel.history) { wrapper in
                factory.bubble(for: wrapper.type) {
                    viewModel.didTapMessage(with: wrapper)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .flip()
                .id(wrapper.id)
                .onAppear {
                    if wrapper.id == viewModel.history.last?.id {
                        viewModel.loadNewMessagesIfNeeded()
                    }
                }
            }
            if viewModel.history.isEmpty {
                Text("No messages\nhere yet")
                    .foregroundColor(.tg_grey)
                    .font(.reqular(size: 17))
                    .multilineTextAlignment(.center)
                    .flip()
            }
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
