//
//  PhotoMessage.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 24.05.2021.
//

import TDLib
import UIKit

final class PhotoMessage: BaseMessage {

    var image: UIImage? {
        willSet {
            objectWillChange.send()
        }
    }
    let size: CGSize?
    let text: String
    private(set) var isLoading: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }

    private let loader: SingleFileLoader?

    init(
        base: BaseMessage,
        image: UIImage?,
        size: CGSize?,
        text: String,
        loader: SingleFileLoader? = nil
    ) {
        self.image = image
        self.size = size
        self.text = text
        self.loader = loader
        super.init(base)
    }

    init(
        id: Int64,
        time: String,
        user: UserInfo? = nil,
        isOutgoing: Bool,
        showSenders: Bool = true,
        image: UIImage?,
        size: CGSize?,
        text: String
    ) {
        self.image = image
        self.size = size
        self.text = text
        self.loader = nil
        super.init(
            id: id,
            time: time,
            user: user,
            isOutgoing: isOutgoing,
            showSenders: showSenders
        )
    }

    func load() {
        guard loader?.requested == false, image == nil else { return }
        isLoading = true
        loader?.load { [weak self] in
            self?.image = UIImage(contentsOfFile: $0)
            self?.isLoading = false
        }
    }

    func loadLocal() {
        guard let path = loader?.localPath() else { return }
        image = UIImage(contentsOfFile: path)
    }
}
