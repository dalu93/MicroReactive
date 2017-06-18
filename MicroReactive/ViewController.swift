//
//  ViewController.swift
//  MicroReactive
//
//  Created by D'Alberti, Luca on 6/18/17.
//  Copyright © 2017 dalu93. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    let disposes = DisposableCollection()
    var timer: Timer!
    var times: UInt = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewModel.toCall.bind {
            print("Changed to \($0)")
        }.disposed(by: disposes)
        
        viewModel.toCall.bind { _ in
            print("Other bind called")
        }.disposed(by: disposes)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            guard let weakSelf = self else {
                fatalError("No self")
            }
            
            print("Timer block called")
            
            guard weakSelf.times != 5 else {
                print("Disposed everything")
                weakSelf.disposes.dispose()
                weakSelf.times += 1
                return
            }
            
            print("Toggle is being called")
            weakSelf.viewModel.toggleToCall()
            weakSelf.times += 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

