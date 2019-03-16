//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Bruno Barbosa on 25/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit
import MapKit
import CoreData

let showPhotosAlbumSegue = "showPhotosAlbum"

class TravelsMapViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    
    var pins: [Pin]?
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setupLongPressAction()
        setupLastViewedMapRegion()
        loadPins()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showPhotosAlbumSegue {
            if let controller = segue.destination as? PhotosAlbumViewController,
                let annotation = sender as? Pin {
                controller.pin = annotation
                controller.dataController = dataController
            }
        }
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
            
            let pin = Pin(context: dataController.viewContext)
            pin.latitude = coordinate.latitude
            pin.longitude = coordinate.longitude
            try? dataController.viewContext.save()
            
            mapView.addAnnotation(pin)
        }
    }
    
    func loadPins() {
        let pinRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        if let result = try? dataController.viewContext.fetch(pinRequest) {
            pins = result
            mapView.addAnnotations(result)
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pin = view.annotation as? Pin {
            performSegue(withIdentifier: showPhotosAlbumSegue, sender: pin)
        }
    }
}

