//
//  VehiclesCoordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation
import UIKit

final class VehiclesCoordinator: Coordinator {
    
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let navController: UINavigationController
    
    init(navController: UINavigationController, parent: Coordinator? = nil) {
        self.navController = navController
        self.parent = parent
    }
    
    func start() {
        let viewController = VehiclesViewController()
        viewController.coordinator = self
        navController.pushViewController(viewController, animated: true)
    }
    
    func navigateToVehicleDetails(iconImage: String) {
        let vehicleCoordinator = VehicleCoordinator(navController: navController, parent: self, iconImage: iconImage)
        vehicleCoordinator.start()
        childCoordinators.append(vehicleCoordinator)
    }
    
}
