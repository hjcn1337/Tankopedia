//
//  FavouritesCoordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 13.03.2022.
//

import Foundation
import UIKit

final class FavouritesCoordinator: Coordinator {
    
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let navController: UINavigationController
    
    init(navController: UINavigationController, parent: Coordinator? = nil) {
        self.navController = navController
        self.parent = parent
    }
    
    func start() {
        let viewController = FavouritesViewController()
        viewController.coordinator = self
        navController.pushViewController(viewController, animated: true)
    }
}
