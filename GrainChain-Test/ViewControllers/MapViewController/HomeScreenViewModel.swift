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
    private var databaseManager: DatabaseManager?
    private var startTime: Date?
    
    //MARK: public properties
    var routes = [Dictionary<String, Any>]()
    
    //MARK: lifecycle functions
    init(){
        databaseManager = DatabaseManager()
        loadRoutes()
    }
    
    //MARK: public functions
    mutating func setStartRouteTime(){
        startTime = Date()
    }
    
    func addCoordinates(latitude: Double, longitude: Double){
        databaseManager?.addCordinates(latitude: latitude, longitude: longitude)
    }
    
    mutating func stopRoute(name: String?, distance: Double){
        saveRoute(name: name, distance: distance)
        databaseManager?.removeCoordinates()
    }
    
    mutating func loadRoutes(){
        guard let dbm = databaseManager else { return }
        routes = dbm.getRoutesList()
    }
    
    //MARK: private functions
    private mutating func saveRoute(name: String?, distance: Double){
        guard let start = startTime else { return }
        databaseManager?.saveRoute(name: name, startTime: start, endTime: Date(), distance: distance)
    }
    

}
