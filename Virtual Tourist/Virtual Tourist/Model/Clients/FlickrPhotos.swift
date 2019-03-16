//
//  FlickrPhotos.swift
//  Virtual Tourist
//
//  Created by Bruno Barbosa on 13/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation

class FlickrPhotos: Decodable {
    
    var page: Int
    var photo: [FlickrPhoto]?
    
}
