//
//  ChatSetupView.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import SwiftUI

protocol ChatSetupOutputHandler {
    func process(output name: String)
}

struct ChatSetupView: View {

    @ObservedObject var viewModel: ChatSetupViewModel

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Choose\nthe chat name")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            Spacer()
            TextField("Name", text: $viewModel.name)
                .multilineTextAlignment(.center)
                .frame(height: 60)
                .modifier(Shake(animatableData: CGFloat(viewModel.emptyNameCount)))
            ActionButton("Create") {
                withAnimation(.default) {
                    viewModel.createButtonTapped()
                }
            }
            Spacer()
        }
    }
}

struct ChatSetupView_Previews: PreviewProvider {

    struct Handler: ChatSetupOutputHandler {
        func process(output name: String) {}
    }

    static var previews: some View {
        NavigationView {
            ChatSetupView(
                viewModel: ChatSetupViewModel(
                    handler: Handler()
                )
            )
        }
    }
}
