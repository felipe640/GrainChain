//
//  MapView.swift
//  GrainChain-Test
//
//  Created by Felipe Rosas on 06/01/20.
//  Copyright © 2020 Felipe Rosas. All rights reserved.
//

import UIKit
import GoogleMaps

//MARK: delegate
protocol MapViewDelegate {
    func mapViewOnRouteCoordinte(latitude: Double, longitude: Double)
    func mapViewError(error: MapViewError)
}

//MARK: errors
enum MapViewError : Error {
    case earlyVersion
    case mapDidFail
}

class MapView: UIView {
    //MARK: private enum
    private enum MarkerPosition {
        case start
        case end
    }
    
    //MARK: public properties
    var delegate: MapViewDelegate?
    var viewModel : MapViewViewModel?
    
    //MARK: private properties
    private var mapView: GMSMapView!
    private var route = GMSMutablePath()
    private var routeTimer: Timer?
    private var distance: Double?
    fileprivate var isInRoute = false
    
    
    fileprivate let locationManager: CLLocationManager = {
       let manager = CLLocationManager()
       manager.requestWhenInUseAuthorization()
       return manager
    }()
    
    //MARK: lifecycle functions
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        setupMap()
    }
    
    //MARK: public functions
    func loadRoute(with id: String){
        
        let alert = AlertManager()
        alert.showSpinner(view: self)
        
        viewModel?.loadCoordinatesbyRoute(id: id, completion: { [weak self] (path)  in
            guard let coords = path else { return }
            self?.route = coords
            
            alert.stopSpinner()
        })
    }
    
    func startRoute(){
        if isInRoute {
            return
        }
        mapView.clear()
        isInRoute = true
        locationManager.startUpdatingLocation()
        routeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(drawLine), userInfo: nil, repeats: true)
    }
    
    func stopRoute(){
        isInRoute = false
        setMarker(position: .end)
        let currentDistance = route.length(of: .geodesic) as Double
        distance = currentDistance.metersToKilometers()
        routeTimer?.invalidate()
        locationManager.stopUpdatingLocation()
        
        route = GMSMutablePath()
    }
    
    func getDistance()-> Double{
        return  distance ?? 0
    }
    
    //MARK: private functions
    private func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: GoogleMapsValues.APPLE_COORDS_LAT,
                                              longitude:GoogleMapsValues.APPLE_COORDS_LONG ,
                                              zoom: GoogleMapsValues.MAPS_DEFAULT_ZOOM)
        self.mapView = GMSMapView.map(withFrame: self.frame, camera: camera)
        self.mapView?.isMyLocationEnabled = true
        self.mapView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.mapView)
        
        let constraints = [
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            mapView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(constraints)

        if viewModel == nil{
            currentLocation()
        }else {
            self.showLoadedRoute()
        }
    }
    
    private func currentLocation() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest

       if #available(iOS 11.0, *) {
          locationManager.showsBackgroundLocationIndicator = true
       } else {
        delegate?.mapViewError(error: .earlyVersion)
       }
        
        locationManager.startUpdatingLocation()
    }
    
    @objc private func drawLine(){
        mapView.clear()

        setMarker(position: .start)
        let line = GMSPolyline(path: route)
        line.map = self.mapView
    }
    
    private func setMarker(position: MarkerPosition){
        let marker = GMSMarker()
        let coordinate = route.coordinate(at: position == .start ? 0 : route.count() - 1)
        marker.position = coordinate

        marker.map = self.mapView
    }
    
    private func showLoadedRoute(){
        self.drawLine()
        self.setMarker(position: .end)
        setCamera(latitude: route.coordinate(at: 0).latitude, longitude: route.coordinate(at: 0).longitude)
    }
    
    fileprivate func setCamera(latitude:Double, longitude: Double) {
        let camera = GMSCameraPosition.camera(withLatitude: (latitude), longitude: (longitude), zoom: GoogleMapsValues.MAPS_DEFAULT_ZOOM)
        
        self.mapView.animate(to: camera)
    }
}

//MARK: - CLLocationManagerDelegate methods
extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        setCamera(latitude: latitude, longitude: longitude)
        
        if isInRoute {
            route.add(location.coordinate)
            
            delegate?.mapViewOnRouteCoordinte(latitude: latitude, longitude: longitude)
        }else{
            locationManager.stopUpdatingLocation()
        }
     }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.mapViewError(error: .mapDidFail)
    }
}


