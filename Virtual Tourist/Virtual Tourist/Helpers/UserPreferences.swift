//
//  UserPreferences.swift
//  Virtual Tourist
//
//  Created by Bruno Barbosa on 25/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation
import MapKit

class UserPreferences {
    
    private enum Keys {
        static let lastViewedMapLatitude = "lastViewedMapLatitude"
        static let lastViewedMapLongitude = "lastViewedMapLongitude"
        static let lastViewedMapLatitudeDelta = "lastViewedMapLatitudeDelta"
        static let lastViewedMapLongitudeDelta = "lastViewedMapLongitudeDelta"
    }
    
    static var lastViewedMapRegion: MKCoordinateRegion? {
        get {
            guard lastViewedMapLatitude != 0 &&
                lastViewedMapLongitude != 0 &&
                lastViewedMapLatitudeDelta != 0 &&
                lastViewedMapLongitudeDelta != 0 else {
                return nil
            }
            
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lastViewedMapLatitude, longitude: lastViewedMapLongitude),
                span: MKCoordinateSpan(latitudeDelta: lastViewedMapLatitudeDelta, longitudeDelta: lastViewedMapLongitudeDelta)
            )
        }
        
        set {
            lastViewedMapLatitude = newValue?.center.latitude ?? 0
            lastViewedMapLongitude = newValue?.center.longitude ?? 0
            lastViewedMapLatitudeDelta = newValue?.span.latitudeDelta ?? 0
            lastViewedMapLongitudeDelta = newValue?.span.longitudeDelta ?? 0
        }
    }
    
    private static var lastViewedMapLatitude: Double {
        get {
            return UserDefaults.standard.double(forKey: Keys.lastViewedMapLatitude)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastViewedMapLatitude)
        }
    }
    
    private static var lastViewedMapLongitude: Double {
        get {
            return UserDefaults.standard.double(forKey: Keys.lastViewedMapLongitude)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastViewedMapLongitude)
        }
    }
    
    private static var lastViewedMapLatitudeDelta: Double {
        get {
            return UserDefaults.standard.double(forKey: Keys.lastViewedMapLatitudeDelta)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastViewedMapLatitudeDelta)
        }
    }
    
    private static var lastViewedMapLongitudeDelta: Double {
        get {
            return UserDefaults.standard.double(forKey: Keys.lastViewedMapLongitudeDelta)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.lastViewedMapLongitudeDelta)
        }
    }
}
