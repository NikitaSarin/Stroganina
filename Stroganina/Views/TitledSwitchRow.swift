//
//  TitledSwitchRow.swift
//  Stroganina
//
//  Created by Сарин Никита Сергеевич on 03.06.2021.
//

import SwiftUI

struct TitledSwitchRow: View {

    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(title, isOn: $isOn)
            .padding(.horizontal, 9)
            .frame(height: 44)
            .background(Color.tg_greyPlatter)
            .cornerRadius(9)
    }
}

struct TitledSwitch_Previews: PreviewProvider {
    static var previews: some View {
        TitledSwitchRow(title: "Title", isOn: .constant(false))
    }
}
