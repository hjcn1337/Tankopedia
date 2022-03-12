//
//  Coordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation
import UIKit

final class AppCoordinator: NSObject, Coordinator {
    
    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private let navController: UINavigationController
    private let window: UIWindow
    
    init(navController: UINavigationController = UINavigationController(), window: UIWindow) {
        self.navController = navController
        self.window = window
    }
    
    func start() {
        navController.delegate = self
        window.rootViewController = navController
        
        let vehiclesCoordinator = VehiclesCoordinator(navController: navController, parent: self)
        vehiclesCoordinator.start()
        
        window.makeKeyAndVisible()
        
        childCoordinators.append(vehiclesCoordinator)
    }
    
}

extension AppCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(fromViewController) else {
                return
        }
        
        if let viewController = fromViewController as? Coordinatable {
            let parent = viewController.coordinator?.parent
            parent?.childCoordinators.removeAll { $0 === viewController.coordinator }
        }
    }
}

