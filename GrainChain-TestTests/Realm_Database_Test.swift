//
//  Realm_Database_Test.swift
//  GrainChain-TestTests
//
//  Created by Felipe Rosas on 21/06/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import XCTest
@testable import GrainChain_Test

class Realm_Database_Test: XCTestCase {
    //MARK: Helpers
    func getDatabaseManagerHelper()->DatabaseManager{
        return DatabaseManager.test
    }
    
    //MARK: Test Cases
    func testAddRoute(){
        let test = getDatabaseManagerHelper()
        let expectedEelements = test.getRoutesList().count + 1
        test.addCordinates(latitude: 0, longitude: 1)
        
        test.saveRoute(name: "add", startTime: Date(), endTime: Date(), distance: 5)
        
        XCTAssertEqual(test.getRoutesList().count, expectedEelements)
    }
    
    func testRemoveRoute(){
        let name = "removeTest"
        let test = getDatabaseManagerHelper()
        
        test.addCordinates(latitude: 0, longitude: 1)
        test.saveRoute(name: name, startTime: Date(), endTime: Date(), distance: 5)
        
        let element = test.getRoutesList().last
        let id = element?[Route.ID_KEY] as? String
        
        XCTAssertNotNil(id, "This must have an string id")
        
        let routeToRemove = test.getRoute(id: id!)
        
        XCTAssertNotNil(routeToRemove, "This must have a Route")
        XCTAssertEqual(routeToRemove?.name, name)
        
        test.deleteRoute(id: id!)
        
        XCTAssertNil(test.getRoute(id: id!), "Element removed")
    }
    
    func testReturnNilRoute(){
        let test = getDatabaseManagerHelper()
        let fakeId = "-1a"
        
        let route = test.getRoute(id: fakeId)
        
        XCTAssertNil(route)
    }

}
