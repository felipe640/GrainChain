//
//  HomeScreenViewModel.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 06/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import Foundation

struct HomeScreenViewModel {
    //MARK: private properties
    private var startTime: Date?
    
    //MARK: public properties
    var routes = [Dictionary<String, Any>]()
    
    //MARK: lifecycle functions
    init(){
        loadRoutes()
    }
    
    //MARK: public functions
    mutating func setStartRouteTime(){
        startTime = Date()
    }
    
    func addCoordinates(latitude: Double, longitude: Double){
        DatabaseManager.shared.addCordinates(latitude: latitude, longitude: longitude)
    }
    
    mutating func stopRoute(name: String?, distance: Double){
        saveRoute(name: name, distance: distance)
    }
    
    mutating func loadRoutes(){
        routes = DatabaseManager.shared.getRoutesList()
    }
    
    //MARK: private functions
    private mutating func saveRoute(name: String?, distance: Double){
        guard let start = startTime else { return }
        DatabaseManager.shared.saveRoute(name: name, startTime: start, endTime: Date(), distance: distance)
    }
    

}
