//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Bruno Barbosa on 25/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit
import MapKit

class TravelsMapViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setupLongPressAction()
        setupLastViewedMapRegion()
    }
    
    // MARK: Setup
    
    func setupLongPressAction() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(dropPin(_:)))
        mapView.addGestureRecognizer(longPress)
    }
    
    func setupLastViewedMapRegion() {
        if let lastViewedMapRegion = UserPreferences.lastViewedMapRegion {
            mapView.setRegion(lastViewedMapRegion, animated: true)
        }
    }
    
    // MARK: Actions
    
    @objc func dropPin(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: Helper
    
    func updateLastViewedMapRegion(_ region: MKCoordinateRegion) {
        UserPreferences.lastViewedMapRegion = region
    }
}

extension TravelsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateLastViewedMapRegion(mapView.region)
    }
}

