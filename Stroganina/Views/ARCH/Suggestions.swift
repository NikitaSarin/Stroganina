//
//  Suggestions.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 30.05.2021.
//

import SwiftUI

protocol SuggestionsDelegate {
    func didTapSuggestion(with text: String)
}

struct Suggestions: View {
    let delegate: SuggestionsDelegate?
    let suggestions = [
        "Hello!",
        "What's up!",
        "on my way.",
        "OK"
    ]

    var body: some View {
        Section("Suggestions") {
            ForEach(suggestions, id: \.self) { text in
                Button(action: {
                    delegate?.didTapSuggestion(with: text)
                }, label: {
                    HStack {
                    Text(text)
                        Spacer()
                    }
                })
            }
        }
    }
}

struct Suggestions_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            Suggestions(delegate: nil)
        }
    }
}

//struct Suggestion: View {
//
//    let text: String
//    let tap: ((String) -> Void)?
//
//    init(_ text: String, tap: ((String) -> Void)?) {
//        self.text = text
//        self.tap = tap
//    }
//
//    var body: some View {
//        HStack {
//            Text(text)
//            Spacer()
//        }
//        .padding(.horizontal, 11)
//        .padding(.vertical, 9)
//        .background(Color.tg_greyPlatter)
//        .cornerRadius(9)
//        .onTapGesture {
//            tap?(text)
//        }
//    }
//}
