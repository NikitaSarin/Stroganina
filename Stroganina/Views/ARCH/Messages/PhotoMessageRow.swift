//
//  PhotoMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 24.05.2021.
//

import SwiftUI
import TDLib

struct PhotoMessageRow: View {

    @ObservedObject var message: PhotoMessage
    private let imageFrame: CGSize
    private let isOutgoing: Bool

    init(
        message: PhotoMessage,
        isOutgoing: Bool? = nil
    ) {
        self.message = message
        self.imageFrame = prefferedContentSize(
            for: message.size,
            maxHeight: safeScreenHeight
        )
        self.isOutgoing = isOutgoing ?? message.isOutgoing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if let image = message.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    if message.isLoading {
                        LoadingView()
                    } else {
                        Image("download")
                            .resizable()
                            .padding(8)
                            .foregroundColor(.tg_white)
                            .background(Color.tg_blue)
                            .frame(side: 30)
                            .cornerRadius(22)
                            .onTapGesture {
                                message.load()
                            }
                    }
                }
            }
            .frame(size: imageFrame)
            .background(Color.tg_greyPlatter)
            if !message.text.isEmpty {
                HStack(spacing: 0) {
                    Text(message.text)
                        .bubble(isOutgoing: isOutgoing)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                    Spacer(minLength: 0)
                }
                .background(BubbleStyle.plain.backgroundColor(isOutgoing: isOutgoing))
            }
        }
        .frame(width: imageFrame.width)
        .cornerRadius(14)
        .onAppear {
            if AppContext.shared.settings.autoDownload.allowed {
                message.load()
            } else {
                message.loadLocal()
            }
        }
    }
}

struct PhotoMessageRow_Previews: PreviewProvider {

    static let message = PhotoMessage(
        id: 1,
        time: "",
        isOutgoing: true,
        image: nil,
        size: .mops,
        text: "Caption 2"
    )

    static var previews: some View {
        ScrollView {
            VStack {
                PhotoMessageRow(message: message)
                Button("Image") {
                    message.image = UIImage(named: "mops")
                }
                Button("Nil") {
                    message.image = nil
                }
            }
        }
    }

}
