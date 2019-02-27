//
//  PhotosAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Bruno Barbosa on 25/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit
import MapKit

let PhotosAlbumCellReuseIdentifier = "PhotosAlbumCell"

class PhotosAlbumViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    var mapRegion: MKCoordinateRegion!
    var mapAnnotationView: MKAnnotationView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        setupAlbumMapRegion()
    }
    
    // MARK: Setup
    
    func setupAlbumMapRegion() {
        if let annotation = mapAnnotationView.annotation {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            mapView.setRegion(region, animated: false)
            
            let currentMapRect = mapView.visibleMapRect
            let topPadding: CGFloat = 132;
            let padding = UIEdgeInsets(top: topPadding, left: 0, bottom: 0, right: 0)
            mapView.setVisibleMapRect(currentMapRect, edgePadding: padding, animated: true)
            mapView.addAnnotation(annotation)
        }
    }
}

extension PhotosAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItemsInSection: Int = 0
        
        if numberOfItemsInSection > 0 {
            collectionView.backgroundView = nil
        
        } else {
            let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
            let noDataLabel: UILabel  = UILabel(frame: frame)
            noDataLabel.text = NSLocalizedString("There are no images for this location", comment: "")
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
        }
        
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosAlbumCellReuseIdentifier, for: indexPath)
        return cell
    }
    
}
