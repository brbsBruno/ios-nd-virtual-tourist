//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Bruno Barbosa on 03/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation

class FlickrClient {
    
    let session: URLSession
    
    // MARK: Shared Instance
    
    static var shared = FlickrClient()
    
    // Initialization
    
    private init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
}
