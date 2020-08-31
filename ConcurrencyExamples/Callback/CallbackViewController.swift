//
//  CallbackViewController.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/21.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

final class CallbackViewController: BaseViewController {
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .bind(\.isSignInButtonVisible, signInButton, \.isVisible)
            .setScope(&tokenList)
        
        viewModel
            .bind(\.isUserViewVisible, userView, \.isVisible)
            .setScope(&tokenList)
        
        viewModel
            .bind(\.user, usernameLabel, { $0?.username }, \.text)
            .setScope(&tokenList)
        
        viewModel
            .bind(\.user, userImageView, { $0?.userImage }, \.image)
            .setScope(&tokenList)
    }
    
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

