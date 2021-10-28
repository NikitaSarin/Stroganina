//
//  MapView.swift
//  EasyMessenger WatchKit Extension
//
//  Created by Сарин Никита Сергеевич on 30.05.2021.
//

import SwiftUI
import MapKit
import TDLib

let sharedMap = WKInterfaceMap()

struct MapView: WKInterfaceObjectRepresentable {

    @Binding var location: Location
    let pin: Location?

    init(
        location: Binding<Location>,
        pin: Location? = nil
    ) {
        self._location = location
        self.pin = pin
    }

    func makeWKInterfaceObject(context: Context) -> WKInterfaceMap {
        let map = WKInterfaceMap()
        if let pin = pin {
            let location = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            map.addAnnotation(location, with: .red)
        }
        return map
    }

    func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceMap, context: Context) {
        let region = correctRegion(from: location)
        wkInterfaceObject.setRegion(region)
    }

    private func correctRegion(from location: Location) -> MKCoordinateRegion {
        let scale: Double = 500
        var center = location.toCL
        center.latitude += 0.0004
        return MKCoordinateRegion(
            center: center,
            latitudinalMeters: scale * 0.75,
            longitudinalMeters: scale
        )
    }
}
