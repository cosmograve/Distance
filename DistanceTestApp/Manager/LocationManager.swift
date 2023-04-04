//
//  LocationManager.swift
//  DistanceTestApp
//
//  Created by Алексей Авер on 02.04.2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    var completion: ((CLLocation) -> Void)?
    let manager = CLLocationManager()
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        completion?(location)
        manager.stopUpdatingLocation()
    }
}
