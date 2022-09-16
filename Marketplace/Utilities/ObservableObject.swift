//
//  ObservableObject.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 06/09/2022.
//

import Foundation

final class ObservableObject<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: ((T) -> Void)?) {
        listener?(value)
        self.listener = listener

    }
    
}
