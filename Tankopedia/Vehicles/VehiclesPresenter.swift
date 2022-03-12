//
//  VehiclesPresenter.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation

protocol VehiclesPresentationLogic {
    func presentVehicles()
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
    
    func presentVehicles() {
        service.getVehicles { [weak self] (result)  in
            switch result {
            case .success(let vehicles):
                self?.view.displayVehicles(vehicles: vehicles)
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
