//
//  MessageStatusView.swift
//  Stroganina
//
//  Created by Nikita Sarin on 22.03.2022.
//

import SwiftUI

struct MessageStatusView: View {

    let status: Message.Status
    let bubbleStyle: BubbleStyle

    private var systemImageName: String {
        switch status {
        case .awaiting: return "clock"
        case .sent, .read: return "checkmark"
        case .failed: return "exclamationmark.circle.fill"
        case .unknown: return ""
        }
    }

    private var color: Color {
        switch status {
        case .sent, .read, .awaiting:
            switch bubbleStyle {
            case .plain: return .white
            case .transparent, .service:
                return .sgn_primary
            }

        case .failed: return .tg_red
        case .unknown: return .clear
        }
    }

    private var insets: EdgeInsets {
        switch status {
        case .awaiting:
            return EdgeInsets(all: 3)
        case .sent, .read:
            return EdgeInsets(vertical: 3.5, horizontal: 2.5)
        case .failed, .unknown: return .zero
        }
    }

    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .foregroundColor(color)
            .padding(insets)
            .frame(edge: 14)
    }
}

extension EdgeInsets {

    static var zero: EdgeInsets {
        EdgeInsets(all: 0)
    }

    init(all: CGFloat) {
        self.init(
            top: all,
            leading: all,
            bottom: all,
            trailing: all
        )
    }

    init(
        vertical: CGFloat = 0,
        horizontal: CGFloat = 0
    ) {
        self.init(
            top: vertical,
            leading: horizontal,
            bottom: vertical,
            trailing: horizontal
        )
    }
}

struct MessageStatusView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(Message.Status.allCases, id: \.self) {
                MessageStatusView(
                    status: $0,
                    bubbleStyle: .plain
                )
            }
        }
        .padding()
        .background(Color.sgn_brand)
    }
}
