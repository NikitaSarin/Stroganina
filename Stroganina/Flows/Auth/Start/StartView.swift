//
//  StartView.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 28.10.2021.
//

import SwiftUI

struct StartView: View {

    let router: AuthRouting

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("Stroganina club")
                .font(.title)
                .bold()
            Spacer()
            ActionButton("Login") {
                router.openLoginScene()
            }
            ActionButton("Register") {
                router.openRegistrationScene()
            }
            Spacer()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(router: AuthRouterMock())
    }
}
