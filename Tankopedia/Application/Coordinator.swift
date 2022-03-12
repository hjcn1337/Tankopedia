//
//  Coordinator.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var parent: Coordinator? { get set }
    
    func start()
}

protocol Coordinatable: AnyObject {
    var coordinator: Coordinator? { get set }
}
