//
//  AppCoordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 14.03.2022.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol: Coordinator {
    func showMainFlow()
}

class AppCoordinator: NSObject, AppCoordinatorProtocol {
    var type: CoordinatorType? = .app
    
    weak var parent: Coordinator?
    
    var navigationController: UINavigationController
    var window: UIWindow
    
    var childCoordinators = [Coordinator]()
        
    required init(navigationController: UINavigationController = UINavigationController(), window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }

    func start() {
        showMainFlow()
    }
    
    func showMainFlow() {
        let tabCoordinator = TabCoordinator.init(parent: self)
        tabCoordinator.start()
        
        window.rootViewController = tabCoordinator.tabBarController
        
        window.makeKeyAndVisible()
        
        childCoordinators.append(tabCoordinator)
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
