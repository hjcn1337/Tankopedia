//
//  FavouritesCoordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 13.03.2022.
//

import Foundation
import UIKit

final class FavouritesCoordinator: Coordinator {
    var type: CoordinatorType?
    
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController(), parent: Coordinator? = nil) {
        self.navigationController = navigationController
        self.parent = parent
    }
    
    func start() {
        let viewController = FavouritesViewController()
        navigationController.tabBarItem.title = tr("favourites.title")
        navigationController.tabBarItem.image = UIImage(systemName: "star.fill")
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
