//
//  PostCell.swift
//  Callback
//
//  Created by Joshua Park on 2020/09/04.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

final class PostCell : UICollectionViewCell {
    
    var tokenList: [NSKeyValueObservation] = []
    
    @IBOutlet
    weak var imageView: UIImageView!
    
    @IBOutlet
    weak var usernameLabel: UILabel!
    
    @IBOutlet
    weak var contentLabel: UILabel!
    
    deinit {
        tokenList.forEach { $0.invalidate() }
    }
    
}
