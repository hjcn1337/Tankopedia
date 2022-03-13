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
    
    private let vehicle: VehicleDetails
    
    init(navController: UINavigationController, parent: Coordinator? = nil, vehicle: VehicleDetails) {
        self.navController = navController
        self.parent = parent
        self.vehicle = vehicle
    }
    
    func start() {
        let viewController = VehicleViewController()
        viewController.coordinator = self
        viewController.vehicle = vehicle
        navController.pushViewController(viewController, animated: true)
    }
    
}
