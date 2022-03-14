//
//  Coordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 14.03.2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var parent: Coordinator? { get set }

    var navigationController: UINavigationController { get set }

    var childCoordinators: [Coordinator] { get set }

    var type: CoordinatorType? { get set }

    func start()
}

protocol Coordinatable: AnyObject {
    var coordinator: Coordinator? { get set }
}

enum CoordinatorType {
    case app, tab
}
