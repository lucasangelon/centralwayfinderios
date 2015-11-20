//
//  IndoorMap.swift
//  Central Wayfinder-2
//
//  Created by Lucas Angelon Arouca on 20/11/2015.
//  Copyright © 2015 Lucas Angelon Arouca. All rights reserved.
//

import Foundation
import UIKit

class IndoorMap: NSObject {
    
    var image: UIImage = UIImage()
    init(image: UIImage) {
        self.image = image
    }
    
    var title: String = String()
    init(title: String) {
        self.title = title
    }
    
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
    }
    
    override init() {
        self.image = UIImage()
        self.title = "Unable to Download"
    }
}