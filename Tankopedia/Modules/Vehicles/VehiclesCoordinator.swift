//
//  VehiclesCoordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation
import UIKit

final class VehiclesCoordinator: Coordinator {
    var type: CoordinatorType?
    
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController(), parent: Coordinator? = nil) {
        self.navigationController = navigationController
        self.parent = parent
    }
    
    func start() {
        let viewController = VehiclesViewController()
        navigationController.tabBarItem.title = tr("tankopedia.title")
        navigationController.tabBarItem.image = UIImage(systemName: "book.closed.fill")?.withTintColor(.green)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func navigateToVehicleDetails(vehicle: VehicleModel) {
        let vehicleCoordinator = VehicleCoordinator(navigationController: navigationController, parent: self, vehicle: vehicle)
        vehicleCoordinator.start()
        childCoordinators.append(vehicleCoordinator)
    }
    
}
