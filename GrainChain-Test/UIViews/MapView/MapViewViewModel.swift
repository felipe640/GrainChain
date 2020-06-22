//
//  MapViewViewModel.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 07/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import Foundation
import GoogleMaps

struct MapViewViewModel {
    
    //MARK: public functions
    func loadCoordinatesbyRoute(id: String, completion:  @escaping (_ coordinates: GMSMutablePath?) -> Void){
        let routeCoord = GMSMutablePath()
        let route = DatabaseManager.shared.getRoute(id: id)
        
        guard let coordinates = route?.coordinates else {
            completion(nil)
            return
        }
        
        for coord in coordinates {
            let locationCoordinate =  CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            routeCoord.add(locationCoordinate)
        }
        
        completion(routeCoord)
    }
}
