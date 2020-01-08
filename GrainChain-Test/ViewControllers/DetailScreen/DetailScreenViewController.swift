//
//  DetailScreenViewController.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 07/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import UIKit

class DetailScreenViewController: UIViewController {
    //MARK: public static properties
    static let vcIdentifier: String = String(describing: DetailScreenViewController.self)
    var viewModel: DetailScreenViewModel?
    //MARK: private properties
    
    
    //MARK: IBOutlet properties
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    //MARK: private functions
    private func setup(){
        let mapViewModel = MapViewViewModel()
        mapView.viewModel = mapViewModel
        
        let id = viewModel?.route[Route.ID_KEY]as? String
        mapView.loadRoute(with: id ?? "")
        
        let name = viewModel?.route[Route.NAME_KEY]as? String
        self.title = name ?? ""
        
        if let distance = viewModel?.route[Route.DISTANCE_KEY]as? Double {
            distanceLabel.text = distance.formateDistanceToString()
        }
        
        if let start = viewModel?.route[Route.START_DATE_KEY]as? Date,
            let end = viewModel?.route[Route.END_DATE_KEY]as? Date {
            
            timeLabel.text = "\(start.getTime(from: end))"
        }
        
        
    }
    
    //MARK: IBAction
    @IBAction func deleteButton(_ sender: Any) {
        
        let alert = AlertManager()
        alert.showAlertWithOptions(with: "DELETE_ROUTE_TITLE".localized, message: "DELETE_ROUTE_MESSAGE".localized,
                                   controller: self) { [weak self] (response) in
            if response{
                self?.viewModel?.deleteRoute()
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
}
