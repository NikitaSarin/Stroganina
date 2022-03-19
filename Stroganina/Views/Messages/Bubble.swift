//
//  Bubble.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 24.05.2021.
//

import SwiftUI

enum BubbleStyle {
    case plain, transparent, service

    func backgroundColor(isOutgoing: Bool) -> Color {
        switch self {
        case .plain:
            return isOutgoing ? .sgn_brand : .sgn_surface
        case .transparent:
            return .clear
        case .service:
            return .sgn_surface
        }
    }

    var insets: EdgeInsets {
        switch self {
        case .plain:
            return EdgeInsets(
                top: 4,
                leading: 12,
                bottom: 8,
                trailing: 12
            )
        case .transparent:
            return .init()
        case .service:
            return EdgeInsets(
                top: 2,
                leading: 8,
                bottom: 4,
                trailing: 8
            )
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .plain: return 16
        case .transparent: return 0
        case .service: return 8
        }
    }
}

enum BubbleInsets: CGFloat {
    case horizontal = 16
}

struct Bubble<Content: View>: View {

    private let padding = BubbleInsets.horizontal.rawValue

    @ObservedObject var message: Message
    private let content: Content
    private let style: BubbleStyle
    private let detailsBlock: VoidClosure?

    private var hasSender: Bool {
        message.sender != nil && userMessage
    }

    private var userMessage: Bool {
        style != .service
    }

    init(
        message: Message,
        style: BubbleStyle = .plain,
        detailsBlock: VoidClosure? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.message = message
        self.style = style
        self.detailsBlock = detailsBlock
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 0) {
            if message.isOutgoing, userMessage {
                Spacer(minLength: padding)
            }
            bubble
            if !message.isOutgoing, userMessage {
                Spacer(minLength: padding)
            }
        }
    }

    private var bubble: some View {
        VStack(alignment: .leading, spacing: 0) {
            info
            content
                .padding(style.insets)
        }
        .background(style.backgroundColor(isOutgoing: message.isOutgoing))
        .cornerRadius(style.cornerRadius)
        .onTapGesture {
            detailsBlock?()
        }
    }

    private var info: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let sender = message.sender, userMessage {
                Text(sender)
                    .font(.medium(size: 14))
                    .foregroundColor(color(for: sender))
            }
        }
        .padding(.top, 4)
        .padding(.horizontal, 12)
    }

    func color(for name: String) -> Color {
        let colors: [Color] = [.tg_orange, .tg_green, .tg_red, .tg_purple]
        let index = abs(name.hashValue) % colors.count
        return colors[index]
    }
}

struct Bubble_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                Bubble(
                    message: .mock(),
                    style: .plain
                ) {
                    Text("Who?")
                        .bubble(isOutgoing: false)
                }
                Bubble(
                    message: .mock(),
                    style: .transparent
                ) {
                    EmojiMessageRow(message: .init(base: .mock(), text: "😎"))
                }
            }
        }
    }
}
