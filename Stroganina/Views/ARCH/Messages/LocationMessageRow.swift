//
//  LocationMessageRow.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 30.05.2021.
//

import SwiftUI
import TDLib
import MapKit

struct LocationMessageRow: View {

    @ObservedObject var message: LocationMessage

    private let isOutgoing: Bool

    init(
        message: LocationMessage,
        isOutgoing: Bool? = nil
    ) {
        self.message = message
        self.isOutgoing = isOutgoing ?? message.isOutgoing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: -20) {
            ZStack {
                MapView(
                    location: .constant(message.location),
                    pin: nil
                )
                pin
            }
            .frame(height: message.text?.isEmpty == false ? 140 : 120)
            .background(Color.tg_greyPlatter)
            if let text = message.text, !text.isEmpty {
                HStack(spacing: 0) {
                    Text(text)
                        .bubble(isOutgoing: isOutgoing)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                    Spacer(minLength: 0)
                }
                .background(BubbleStyle.plain.backgroundColor(isOutgoing: isOutgoing))
            }
        }
        .frame(width: 160)
        .cornerRadius(14)
    }

    var pin: some View {
        Group {
            if message.isLive {
                VStack(spacing: -21) {
                    ZStack {
                        Image("user_pin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 56)
                        ProfileView(
                            image: message.user?.image,
                            text: message.user?.name ?? "",
                            size: .medium
                        )
                        .padding(.top, -8)
                        .opacity(message.isExpired ? 0.6 : 1)
                    }
                    ZStack {
                        if !message.isExpired {
                            Image("live_location")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.trailing, -23)
                                .padding(.top, 23)

                        }
                        Circle()
                            .foregroundColor(Color.blue)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .frame(side: 10)
                    }
                    .frame(side: 50)
                }
                .padding(.top, -8)
            } else {
                Image("pin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60)
                    .padding(.top, -20)
            }
        }
    }
}

struct LocationMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        LocationMessageRow(
            message: LocationMessage(
                base: .mock(),
                location: .mock,
                livePeriod: 1,
                text: ""
            )
        )
    }
}

extension Location {
    static let mock = Location(
        horizontalAccuracy: 1,
        latitude: 55.751694,
        longitude: 37.617218
    )

    var toCL: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
