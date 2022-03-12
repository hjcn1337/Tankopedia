//
//  VehicleCoordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation
import UIKit

final class VehicleCoordinator: Coordinator {
    
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let navController: UINavigationController
    
    private let iconImage: String
    
    init(navController: UINavigationController, parent: Coordinator? = nil, iconImage: String) {
        self.navController = navController
        self.parent = parent
        self.iconImage = iconImage
    }
    
    func start() {
        let viewController = VehicleViewController()
        viewController.coordinator = self
        viewController.iconImage = iconImage
        navController.pushViewController(viewController, animated: true)
    }
    
}
