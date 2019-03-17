//
//  PhotosAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Bruno Barbosa on 25/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit
import MapKit

enum CollectionViewState {
    case loading
    case populated([FlickrPhoto])
    case empty
    case error(NSError)
}

class PhotosAlbumViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var dataController: DataController!
    
    var pin: Pin!
    
    var state = CollectionViewState.loading {
        didSet {
            pin.photos = NSSet()
            
            switch state {
            case .loading:
                newCollectionButton.isEnabled = false
                
                let activityIndicator = UIActivityIndicatorView(style: .gray)
                activityIndicator.center = collectionView.center
                collectionView.backgroundView  = activityIndicator
                activityIndicator.startAnimating()
                
            case .populated(let resultPhotos):
                newCollectionButton.isEnabled = true
                collectionView.backgroundView = nil
                
                for resultPhoto in resultPhotos {
                    let photo = Photo(context: dataController.viewContext)
                    photo.url = resultPhoto.url
                    pin.addToPhotos(photo)
                }
                
            case .empty:
                newCollectionButton.isEnabled = true
                
                let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
                let noDataLabel = UILabel(frame: frame)
                noDataLabel.text = NSLocalizedString("There are no images for this location", comment: "")
                noDataLabel.textAlignment = .center
                collectionView.backgroundView  = noDataLabel
                
            case .error(let error):
                newCollectionButton.isEnabled = true
                
                let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
                let errorLabel = UILabel(frame: frame)
                errorLabel.text = error.localizedDescription
                errorLabel.textAlignment = .center
                collectionView.backgroundView  = errorLabel
            }
            
            self.collectionView.reloadData()
        }
    }
    
    private let PhotosAlbumCellReuseIdentifier = "PhotosAlbumCell"
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupCollectionView()
    }
    
    // MARK: Setup
    
    private func setupMapView() {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: pin.coordinate, span: span)
        
        mapView.setRegion(region, animated: false)
        
        let currentMapRect = mapView.visibleMapRect
        
        var topPadding: CGFloat = 0
        if let safeAreaTopInset = UIApplication.shared.keyWindow?.safeAreaInsets.top,
            let navigationBarHeight = navigationController?.navigationBar.frame.height {
            topPadding = safeAreaTopInset + navigationBarHeight
        }
        
        let padding = UIEdgeInsets(top: topPadding, left: 0.0, bottom: 0.0, right: 0.0)
        mapView.setVisibleMapRect(currentMapRect, edgePadding: padding, animated: true)
        mapView.addAnnotation(pin)
        
        mapView.isUserInteractionEnabled = false
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupCollectionViewLayout()
        
        if (pin.photos == nil || (pin.photos != nil && pin.photos!.count == 0)) {
            loadPhotos()
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
    
    // MARK: Actions
    
    private func loadPhotos() {
        guard let bbox = FlickrClient.BoundingBox(latitude: pin.latitude, longitude: pin.longitude) else {
            return
        }
        
        state = .loading
        let pinPage = Int(pin.page)
        
        let loadTask = FlickrClient.shared.searchPhotos(bbox: bbox, page: pinPage) { (data, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.state = .error(error!)
                    return
                }
                
                if let data = data {
                    if let resultPhotos = data.photo, resultPhotos.count > 0 {
                        self.state = .populated(resultPhotos)
                        
                    } else {
                        self.state = .empty
                    }
                }
            }
        }
        
        loadTask?.resume()
    }
    
    @IBAction func newCollection(_ sender: Any) {
        pin.page += 1
        loadPhotos()
    }
    
    private func storeImageData(_ imageData: Data, photo: Photo) {
        photo.image = imageData
        try? dataController.viewContext.save()
    }
    
}

extension PhotosAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let numberOfItemsInSection: Int = pin.photos?.count ?? 0
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosAlbumCellReuseIdentifier, for: indexPath)
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = collectionView.center
        cell.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        
        return cell
    }
    
}

extension PhotosAlbumViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let photo = pin.photos?.allObjects[indexPath.row] as? Photo {
            if let imageData = photo.image {
                let image = UIImage(data: imageData)
                cell.backgroundView = UIImageView(image: image)
                
            } else {
                if let urlString = photo.url {
                    let imageURL = URL(string: urlString)!
                    
                    URLSession.shared.dataTask(with: imageURL) { (data, _, _) in
                        if let data = data {
                            let image = UIImage(data: data)
                            self.storeImageData(data, photo: photo)
                            
                            DispatchQueue.main.async {
                                cell.backgroundView = UIImageView(image: image)
                            }
                        }
                        }.resume()
                }
            }
        }
    }
}
