//
//  BlueDot.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 06.06.2021.
//

import SwiftUI

struct Dot: View {
    var body: some View {
        Circle()
            .fill(Color.tg_blue)
            .frame(side: 6)
    }
}

struct Dot_Previews: PreviewProvider {
    static var previews: some View {
        Dot()
    }
}
