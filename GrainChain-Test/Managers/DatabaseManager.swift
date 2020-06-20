//
//  DatabaseManager.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 06/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import Foundation
import RealmSwift

struct DatabaseManager{
    //MARK: private properties
    private var coordinates = List<RouteCoordinates>()
    
    //MARK: public functions
    func addCordinates(latitude: Double, longitude: Double){
        let coord = RouteCoordinates.createRouteCoordinates(latitude: latitude, longitude: longitude)
        
        coordinates.append(coord)
    }
    
    func saveRoute(name: String?, startTime: Date, endTime: Date, distance: Double){
        guard let realm = try? Realm() else { return }
        let end = Date()
        let routes = realm.objects(Route.self).count
        var finalName = ""
        let route = Route()
        
        if let name = name, name.count != 0 {
            finalName = name
        }else {
            finalName = "\(routes)º \(startTime.currentDateToStringFormated(type: .full))"
        }
        
        route.id = startTime.currentDateToStringFormated(type: .interval)
        route.name = finalName
        route.distance = distance
        route.startDate = startTime
        route.endDate = end
        route.coordinates = coordinates
         
        try! realm.write {
            realm.add(route)
        }
    }
    
    mutating func removeCoordinates() {
        coordinates = List<RouteCoordinates>()
    }
    
    func deleteRoute(id: String){
        guard let realm = try? Realm() else { return }
        guard let query = realm.objects(Route.self).filter("id == %@", id).first else { return }
        
        try! realm.write {
            realm.delete(query)
        }
    }
    
    func getRoutesList()->[Dictionary<String, Any>]{
        guard let realm = try? Realm() else { return [Dictionary<String, Any>]() }
        let list = realm.objects(Route.self)
        var results = [Dictionary<String, Any>]()
        
        for item in list {
            let route = Route.getRouteDictionary(route: item)
            
            results.append(route)
        }
        
        return results
    }
    
    func getRoute(id: String)-> Route? {
        guard let realm = try? Realm() else { return nil }
        let query = realm.objects(Route.self).filter("id == %@", id).first
        return query
    }
}
