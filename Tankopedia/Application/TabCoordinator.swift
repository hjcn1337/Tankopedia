//
//  TabCoordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 14.03.2022.
//

import Foundation
import UIKit

class TabCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController = UINavigationController()
    
    weak var parent: Coordinator?
    
    var type: CoordinatorType? = .tab
        
    var childCoordinators: [Coordinator] = []
    
    var tabBarController: UITabBarController

    
    required init(parent: Coordinator? = nil) {
        self.parent = parent
        self.tabBarController = .init()
    }

    func start() {
        let vehiclesCoordinator = VehiclesCoordinator(parent: self)
        vehiclesCoordinator.start()

        let favouritesCoordinator = FavouritesCoordinator(parent: self)
        favouritesCoordinator.start()

        let controllers: [UINavigationController] = [
            vehiclesCoordinator.navigationController,
            favouritesCoordinator.navigationController
        ]

        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.tabBar.isTranslucent = true
    }
}
