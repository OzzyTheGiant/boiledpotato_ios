//
//  ViewController.swift
//  BoiledPotato
//
//  Created by Oziel Perez on 10/4/19.
//  Copyright © 2019 DreamCraft. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private var layout : MainViewLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout = MainViewLayout(rootView: view)
    }
}

