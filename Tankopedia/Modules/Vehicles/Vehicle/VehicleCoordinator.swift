//
//  VehicleCoordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation
import UIKit

final class VehicleCoordinator: Coordinator {    
    var type: CoordinatorType?
    
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    private let vehicle: VehicleModel
    
    init(navigationController: UINavigationController, parent: Coordinator? = nil, vehicle: VehicleModel) {
        self.navigationController = navigationController
        self.parent = parent
        self.vehicle = vehicle
    }
    
    func start() {
        let viewController = VehicleViewController()
        viewController.coordinator = self
        viewController.delegate = navigationController.viewControllers.first as? VehicleDetailsFavouriteLogic
        viewController.vehicle = vehicle
        navigationController.pushViewController(viewController, animated: true)
        
    }
    
}
