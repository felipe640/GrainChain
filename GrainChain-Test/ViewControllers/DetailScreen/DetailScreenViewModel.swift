//
//  DetailScreenViewModel.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 07/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import Foundation


struct DetailScreenViewModel {
    //MARK: public properties
    var route: Dictionary<String, Any> = Dictionary<String, Any>()
    
    func deleteRoute(){
        guard let id = route[Route.ID_KEY] as? String else { return }
        
        let dbm = DatabaseManager()
        dbm.deleteRoute(id: id)
    }
}
