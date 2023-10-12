//
//  LocationManager.swift
//  RainOrShine
//
//  Created by Yessenia Valencia-Juarez on 10/11/23.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, ObservableObject {
    @Published var currentLocation: CLLocation?
    
    private let clLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        clLocationManager.requestWhenInUseAuthorization()
        clLocationManager.delegate = self
        DispatchQueue.main.async {
            self.clLocationManager.startUpdatingLocation()
        }
    }

    
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{
            return
        }
        DispatchQueue.main.async {
            self.currentLocation =  location
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
