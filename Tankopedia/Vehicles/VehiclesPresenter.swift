//
//  VehiclesPresenter.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation

protocol VehiclesPresentationLogic {
    func presentVehicles(page: Int, completion: (() -> Void)?)
    func presentError(error: APIError)
    func favoriteAction()
}

class VehiclesPresenter: VehiclesPresentationLogic {
    var service: VehiclesService
    private unowned let view: VehiclesDisplayLogic

    init(view: VehiclesDisplayLogic) {
        self.view = view
        self.service = VehiclesService()
    }
    
    func presentVehicles(page: Int, completion: (() -> Void)? = nil) {
        service.getVehicles(page: page) { [weak self] (result)  in
            switch result {
            case .success(let vehicles):
                self?.view.displayVehicles(vehicles: vehicles)
                completion?()
            case .failure(let error):
                self?.view.displayError(error: error)
            }
        }
    }
    
    func presentError(error: APIError) {
        self.view.displayError(error: error)
    }
    
    func favoriteAction() {
        print(#function)
    }
    
}
