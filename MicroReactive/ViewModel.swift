//
//  ViewModel.swift
//  MicroReactive
//
//  Created by D'Alberti, Luca on 6/18/17.
//  Copyright © 2017 dalu93. All rights reserved.
//

import Foundation

final class ViewModel {
    
    let toCall = Property(false)
    
    func toggleToCall() {
        toCall.value = !toCall.value
    }
}
