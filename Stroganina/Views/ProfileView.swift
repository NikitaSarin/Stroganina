//
//  ProfileView.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 24.05.2021.
//

import SwiftUI
import UIKit

struct ProfileView: View {

    enum Mode {
        case image(UIImage)
        case text(String)
    }

    enum Size: CaseIterable {
        case small, medium

        var side: CGFloat {
            switch self {
            case .small:
                return 24
            case .medium:
                return 44
            }
        }

        var fontSize: CGFloat {
            switch self {
            case .small:
                return 12
            case .medium:
                return 20
            }
        }
    }

    let mode: Mode
    let size: Size
    let backgroundColor: Color

    init(
        mode: Mode,
        size: Size = .small
    ) {
        self.mode = mode
        self.size = size
        self.backgroundColor = .tg_blue
    }

    init(
        image: UIImage?,
        text: String,
        size: Size = .small,
        backgroundColor: Color = .tg_blue
    ) {
        self.size = size
        self.mode = image != nil ? .image(image!) : .text(text)
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        Group {
            switch mode {
            case let .image(image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case let .text(title):
                Text(title.prefix(1))
                    .font(.system(size: size.fontSize))
            }
        }
        .frame(side: size.side)
        .background(backgroundColor)
        .cornerRadius(size.side / 2)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            ForEach(ProfileView.Size.allCases, id: \.self) { size in
                HStack(spacing: 10) {
                    ProfileView( mode: .image(.mops), size: size)
                    ProfileView( mode: .text("Арбуз"), size: size)
                }
            }
        }
    }
}
