//
//  DateRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 03.06.2021.
//

import SwiftUI

struct DateRow: View {

    let date: Date

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private var dateString: String {
        Self.dateFormatter.string(from: date).uppercased()
    }

    private var timeString: String {
        Self.timeFormatter.string(from: date)
    }

    var body: some View {
        HStack(spacing: 0) {
            Text(dateString)
            Spacer(minLength: 4)
            Text(timeString)
        }
        .font(.reqular(size: 14))
        .foregroundColor(.tg_grey)
    }
}

struct DateRow_Previews: PreviewProvider {
    static var previews: some View {
        DateRow(date: Date())
    }
}
