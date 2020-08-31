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
        
        viewModel.bind(\.signInMessage) { [weak self] in
            guard let message = $0 else { return }
            
            let ac = UIAlertController(
                title: nil,
                message: message,
                preferredStyle: .alert)
            let action1 = UIAlertAction(
                title: "확인",
                style: .default)
            { _ in
                self?.viewModel.signIn()
            }
            let action2 = UIAlertAction(
                title: "취소",
                style: .cancel,
                handler: nil)
            
            ac.addAction(action1)
            ac.addAction(action2)
            
            self?.present(ac, animated: true)
        }.setScope(&tokenList)
        
        viewModel.bind(\.alertMessage) { [weak self] in
            guard let errorMessage = $0 else { return }
            
            let ac = UIAlertController(
                title: nil,
                message: errorMessage,
                preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self?.present(ac, animated: true)
        }.setScope(&tokenList)
    }
    
    // MARK: Private
    
    private let viewModel = CallbackViewModel()
    
    @IBOutlet
    private weak var signInButton: UIButton!
    
    @IBAction
    private func signInAction(_ sender: UIButton) {
        viewModel.tapButton()
    }
    
    @IBOutlet
    private weak var userView: UIStackView!
    
    @IBOutlet
    private weak var userImageView: UIImageView!
    
    @IBOutlet
    private weak var usernameLabel: UILabel!
    
    @IBOutlet
    private weak var listView: UICollectionView!

}

private extension CallbackViewController {
    
    @IBAction
    func toggleAction(_ sender: UISwitch) {
        if sender.isOn { mockSuccess() }
        else { mockFailure() }
    }
    
}
