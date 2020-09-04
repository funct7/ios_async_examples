//
//  UIView+Visible.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/31.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

extension UIView {
    
    var isVisible: Bool {
        get { !isHidden }
        set { isHidden = !newValue }
    }
    
}
