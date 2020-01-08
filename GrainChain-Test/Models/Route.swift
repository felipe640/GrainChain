//
//  Route.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 06/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import Foundation
import RealmSwift

class Route: Object{
    //MARK: static properties
    static let ID_KEY = "id"
    static let NAME_KEY = "name"
    static let START_DATE_KEY = "start"
    static let END_DATE_KEY = "end"
    static let COORDINATES_KEY = "coordinates"
    static let LATITUDE_KEY = "coordinates"
    static let LONGITUDE_KEY = "coordinates"
    static let DISTANCE_KEY = "distance"
    
    //MARK: public properties
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var distance: Double = 0
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    var coordinates = List<RouteCoordinates>()
    
    //MARK: lifecycle function
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //MARK: static functions
    static func getRouteDictionary(route: Route)-> Dictionary<String, Any> {
        var dic = Dictionary<String, Any>()
        dic[ID_KEY] = route.id
        dic[DISTANCE_KEY] = route.distance
        dic[NAME_KEY] = route.name
        dic[START_DATE_KEY] = route.startDate
        dic[END_DATE_KEY] = route.endDate
        
        return dic
    }
    
}
