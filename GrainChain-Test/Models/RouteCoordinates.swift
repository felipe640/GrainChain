//
//  RouteCoordinates.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 06/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import Foundation
import RealmSwift

class RouteCoordinates: Object{
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    static func createRouteCoordinates(latitude: Double, longitude: Double) -> RouteCoordinates{
        let coordinates = RouteCoordinates()
        coordinates.latitude = latitude
        coordinates.longitude = longitude
        
        return coordinates
    }
}
