//
//  ProfileView.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 24.05.2021.
//

import SwiftUI
import UIKit
import CryptoKit

struct ProfileView: View {

    enum Mode {
        case image(UIImage)
        case text(String)
    }

    enum Size: CaseIterable {
        case small, medium, large

        var edge: CGFloat {
            switch self {
            case .small:
                return 24
            case .medium:
                return 52
            case .large:
                return 80
            }
        }

        var fontSize: CGFloat {
            switch self {
            case .small:
                return 12
            case .medium:
                return 22
            case .large:
                return 40
            }
        }
    }

    let mode: Mode
    let size: Size
    let backgroundColor: Color

    init(user: User) {
        self.size = .medium
        self.mode = .text(user.picture?.emoji ?? user.fullName)
        self.backgroundColor = user.picture?.color ?? user.name.color
    }

    init(
        mode: Mode,
        size: Size = .small,
        backgroundColor: Color? = nil
    ) {
        self.mode = mode
        self.size = size
        switch mode {
        case .image:
            self.backgroundColor = .sgn_brand
        case let .text(string):
            self.backgroundColor = string.color
        }
    }

    init(
        image: UIImage?,
        text: String,
        size: Size = .small,
        backgroundColor: Color = .sgn_brand
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
                    .foregroundColor(.tg_white)
            }
        }
        .frame(edge: size.edge)
        .background(backgroundColor)
        .cornerRadius(size.edge / 2)
    }
}

private extension String {
    var color: Color {
        let data = self.data(using: .utf8) ?? Data()
        let digest = Insecure.MD5.hash(data: data)
        let hashString = digest.map {
            String(format: "%02hhx", $0)
        }
        .joined()
        .prefix(6)
        let number = Int(hashString, radix: 16) ?? 0
        let colors: [Color] = [
            .tg_red,
            .tg_green,
            .tg_orange,
            .sgn_brand,
            .tg_purple,
        ]
        return colors[number % colors.count]
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
