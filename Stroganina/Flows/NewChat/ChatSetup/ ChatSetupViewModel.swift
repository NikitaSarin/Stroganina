//
//  ChatSetupViewModel.swift
//  Stroganina
//
//  Created by Aleksandr Shipin on 31.10.2021.
//

import Combine

final class ChatSetupViewModel: ObservableObject {

    @Published var emptyNameCount: Int = 0
    @Published var name: String = ""

    private let handler: ChatSetupOutputHandler

    init(
        handler: ChatSetupOutputHandler
    ) {
        self.handler = handler
    }

    func createButtonTapped() {
        if name.isEmpty {
            emptyNameCount += 1
            return
        }
        handler.process(output: name)
    }
}
