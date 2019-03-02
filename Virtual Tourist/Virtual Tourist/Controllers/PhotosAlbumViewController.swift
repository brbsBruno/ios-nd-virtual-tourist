//
//  PhotosAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Bruno Barbosa on 25/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit
import MapKit

class PhotosAlbumViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var mapRegion: MKCoordinateRegion!
    var mapAnnotationView: MKAnnotationView!
    
    private let PhotosAlbumCellReuseIdentifier = "PhotosAlbumCell"
    private let totalColors: Int = 100
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        setupMapView()
        setupCollectionViewLayout()
    }
    
    // MARK: Setup
    
    private func setupMapView() {
        if let annotation = mapAnnotationView.annotation {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            
            mapView.setRegion(region, animated: false)
            
            let currentMapRect = mapView.visibleMapRect
            
            var topPadding: CGFloat = 0
            if let safeAreaTopInset = UIApplication.shared.keyWindow?.safeAreaInsets.top,
                let navigationBarHeight = navigationController?.navigationBar.frame.height {
                topPadding = safeAreaTopInset + navigationBarHeight
            }
            
            let padding = UIEdgeInsets(top: topPadding, left: 0.0, bottom: 0.0, right: 0.0)
            mapView.setVisibleMapRect(currentMapRect, edgePadding: padding, animated: true)
            mapView.addAnnotation(annotation)
        }
    }
    
    private func setupCollectionViewLayout() {
        let itemsPerRow: CGFloat = 3
        let itemsPadding: CGFloat = 5.0
        
        let paddingSpace = itemsPadding * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        collectionViewFlowLayout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        collectionViewFlowLayout.minimumLineSpacing = itemsPadding
        collectionViewFlowLayout.minimumInteritemSpacing = itemsPadding
        
        collectionView.contentInset = UIEdgeInsets(top: itemsPadding,
                                                   left: itemsPadding,
                                                   bottom: itemsPadding,
                                                   right: itemsPadding)
    }
    
    // MARK: Helper
    
    private func colorForIndexPath(indexPath: IndexPath) -> UIColor {
        if indexPath.row >= totalColors {
            return UIColor.black
        }
        
        let hueValue: CGFloat = CGFloat(indexPath.row) / CGFloat(totalColors)
        return UIColor(hue: hueValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
}

extension PhotosAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let numberOfItemsInSection: Int = totalColors
        
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosAlbumCellReuseIdentifier, for: indexPath)
        cell.backgroundColor = colorForIndexPath(indexPath: indexPath)
        return cell
    }
    
}
