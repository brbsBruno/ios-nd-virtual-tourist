//
//  FlickrPhoto.swift
//  Virtual Tourist
//
//  Created by Bruno Barbosa on 13/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation

class FlickrPhoto: Decodable {
    
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url_m"
    }

}
