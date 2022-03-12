//
//  VehicleViewController.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation
import UIKit

class VehicleViewController: UIViewController, Coordinatable {
    
    weak var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        print("VehicleViewController" + #function)
    }
}
