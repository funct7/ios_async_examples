//
//  CallbackViewModel.swift
//  ConcurrencyExamples
//
//  Created by Joshua Park on 2020/08/28.
//  Copyright © 2020 Knowre. All rights reserved.
//

import UIKit

final class CallbackViewModel : NSObject {
    
    // MARK: Interface
    
    @objc
    private(set) dynamic var user: UserModel? = nil
    
    @objc
    private(set) dynamic var userImage: UIImage? = nil
    
    @objc
    private(set) dynamic var feed: [PostModel] = []
    
    @objc
    private(set) dynamic var alertMessage: String? = nil
    
    func tapButton() {
        alertMessage = "로그인 하시겠습니까?"
        alertMessage = nil
    }
    
    func signIn() {
        UserRepository.shared.signIn { [weak self] (user, error) in
            do {
                guard let user = user else { throw error! }
                
            } catch {
                self?.alertMessage = error.localizedDescription
                self?.alertMessage = nil
            }
        }
    }
    
}
