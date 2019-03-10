//
//  Pin+MKAnnotation.swift
//  Virtual Tourist
//
//  Created by Bruno Barbosa on 10/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation
import MapKit

extension Pin: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
