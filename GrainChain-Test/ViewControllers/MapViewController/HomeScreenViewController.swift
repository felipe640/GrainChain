//
//  HomeScreenViewController.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 06/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    //MARK: private properties
    fileprivate var viewModel: HomeScreenViewModel?
    private var isInRoute = false
    let identifier = String(describing: RoutesTableViewCell.self)
    
    //MARK: IBOutlet
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var routesTableView: UITableView!
    @IBOutlet weak var recordButton: UIButton!
    
    //MARK: lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadRoutes()
    }
    
    //MARK: private functions
    private func setup() {
        viewModel = HomeScreenViewModel()
        mapView.delegate = self
        
        loadRoutes()
        
        routesTableView.delegate = self
        routesTableView.dataSource = self
        routesTableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    private func routeButtonPressed(){
        if isInRoute {
            recordButton.setTitle("RECORD".localized ,for: .normal)
            
            mapView.stopRoute()
            askForName()
        }else {
            recordButton.setTitle("STOP_RECORD".localized ,for: .normal)
            
            viewModel?.setStartRouteTime()
            mapView.startRoute()
        }
        
        isInRoute = !isInRoute
    }
    
    private func loadRoutes(){
        viewModel?.loadRoutes()
        routesTableView.reloadData()
    }
    
    private func stopRoute(name: String?){
        viewModel?.stopRoute(name: name, distance: mapView.getDistance())
        
        loadRoutes()
    }
    
    private func askForName(){
        let alert = AlertManager()
        alert.showAlertWithTextField(with: "NAME_TITLE".localized, message: "NAME_MESSAGE".localized,
                                     placeholder: "NAME_PH".localized, controller: self) { [weak self] (name) in
                                        
            self?.stopRoute(name: name)
        }
    }
    
    fileprivate func checkRoute(){
        if isInRoute{
            stopRoute(name: nil)
            
            isInRoute = !isInRoute
        }
    }
    
    //MARK: IBAction
    @IBAction func routeAction(_ sender: Any) {
        routeButtonPressed()
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DetailScreenViewController.vcIdentifier {
            guard let currentRoute = sender as? Dictionary<String, Any>  else { return }
            guard let detail = segue.destination as? DetailScreenViewController else { return }
            let detailViewModel = DetailScreenViewModel()

            detail.viewModel = detailViewModel
            detail.viewModel?.route = currentRoute
        }
    }
}

//MARK: MapViewDelegate methods
extension HomeScreenViewController: MapViewDelegate{
    func mapViewOnRouteCoordinte(latitude: Double, longitude: Double) {
        viewModel?.addCoordinates(latitude: latitude, longitude: longitude)
    }
    
    func mapViewError(error: MapViewError) {
        
    }
}

//MARK: UITableViewDelegate UITableViewDelegate methods
extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm = viewModel else { return 0 }
        return vm.routes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? RoutesTableViewCell else {
            return UITableViewCell()
        }
        
        guard let vm = viewModel else { return UITableViewCell() }
        
        cell.configure(data: vm.routes[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vm = viewModel else { return }
        performSegue(withIdentifier: DetailScreenViewController.vcIdentifier, sender: vm.routes[indexPath.row])
        
        checkRoute()
    }
}
