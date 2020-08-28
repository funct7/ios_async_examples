//
//  CallbackViewController.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/21.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

final class CallbackViewController: UIViewController {
    
    // MARK: Private
    
    private let viewModel = CallbackViewModel()
    
    @IBOutlet
    private weak var signInButton: UIButton!
    
    @IBOutlet
    private weak var userView: UIStackView!
    
    @IBOutlet
    private weak var userImageView: UIImageView!
    
    @IBOutlet
    private weak var usernameLabel: UILabel!
    
    @IBOutlet
    private weak var listView: UICollectionView!

}
