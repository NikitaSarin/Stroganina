//
//  ContactEntity.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 02.06.2021.
//

import UIKit
import TDLib

final class ContactEntity: Identifiable, ObservableObject {
    let id: Int
    let phone: String
    let name: String
    @Published var image: UIImage?
    @Published var status: UserStatus
    private var requested = false
    private let loader: SingleFileLoader?

    private(set) lazy var trimmedName: String = {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "#" : trimmed
    }()

    init(
        id: Int,
        name: String,
        phone: String,
        status: UserStatus,
        image: UIImage?,
        loader: SingleFileLoader? = nil
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.status = status
        self.image = image
        self.loader = loader
    }

    init?(user: User?, fileLoader: FileLoadable) {
        guard let user = user else { return nil }
        id = user.id
        phone = user.phoneNumber
        name = user.firstName + " " + user.lastName
        status = user.status
        loader = SingleFileLoader(
            loader: fileLoader,
            file: user.profilePhoto?.small,
            type: .fileTypeProfilePhoto
        )
    }

    func loadPhoto() {
        guard !requested, image == nil else { return }
        loader?.load { [weak self] path in
            self?.image = UIImage(contentsOfFile: path)
        }
    }
}
