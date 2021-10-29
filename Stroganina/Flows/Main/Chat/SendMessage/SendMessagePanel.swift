//
//  SendMessagePanel.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 29.10.2021.
//

import SwiftUI

protocol SendMessagePanelDelegate: AnyObject {
    func sendButtonTapped()
}

struct SendMessagePanel: View {

    private let inputHeight = 32.0

    @Binding var text: String
    weak var delegate: SendMessagePanelDelegate?
    
    private var sendEnabled: Bool {
        text.count > 1
    }

    var body: some View {
        HStack(spacing: 7) {
            TextField("Message", text: $text)
                .padding(.horizontal, 15)
                .frame(height: inputHeight)
                .background(Color.sgn_background)
                .cornerRadius(15)
                .padding(.leading, 7)
                .padding(.vertical, 12)
            Button(action: {
                delegate?.sendButtonTapped()
            }, label: {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(edge: inputHeight)
            })
            .frame(edge: 44)
            .disabled(!sendEnabled)
            .animation(.spring())
        }
        .padding(.horizontal, 5)
        .background(Color.sgn_surface)
    }
}

struct SendMessagePanel_Previews: PreviewProvider {
    static var previews: some View {
        SendMessagePanel(text: .constant(""))
    }
}
