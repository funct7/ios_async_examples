//
//  ViewController.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/21.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

final class ViewController: BaseViewController {
    
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
            .bind(\.user?.username, usernameLabel, \.text)
            .setScope(&tokenList)
        
        viewModel
            .bind(\.user?.userImage, userImageView, \.image)
            .setScope(&tokenList)
        
        viewModel
            .bind(\.feed) { [unowned listView] _ in
                listView?.reloadData()
            }
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
        
        viewModel
            .bind(\.isLoading, indicator, \.isVisible)
            .setScope(&tokenList)
    }
    
    // MARK: Private
    
    private let viewModel: BaseViewModel = CallbackViewModel()
    
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

    @IBOutlet
    private weak var indicator: UIActivityIndicatorView!
    
}

private extension ViewController {
    
    @IBAction
    private func signInAction(_ sender: UIButton) {
        viewModel.tapButton()
    }
    
    @IBAction
    func toggleAction(_ sender: UISwitch) {
        if sender.isOn { mockSuccess() }
        else { mockFailure() }
    }
    
    @IBAction
    func signOutAction(_ sender: UIButton) {
        viewModel.signOut()
    }
    
}

extension ViewController : UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int)
        -> Int
    {
        return viewModel.feed.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PostCell",
            for: indexPath) as! PostCell
        
        let item = viewModel.feed[indexPath.item]
        
        item.bind(\.username, cell, \.usernameLabel.text)
            .setScope(&cell.tokenList)
        
        item.bind(\.userImage, cell, \.imageView.image)
            .setScope(&cell.tokenList)
        
        item.bind(\.content, cell, \.contentLabel.text)
            .setScope(&cell.tokenList)
        
        return cell
    }
    
}
