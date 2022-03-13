//
//  VehiclePresenter.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation

protocol VehiclePresentationLogic {
    func presentVehicle(tankID: Int, completion: (() -> Void)?)
    func presentError(error: APIError)
}

class VehiclePresenter: VehiclePresentationLogic {
    var service: VehicleService
    private unowned let view: VehicleDisplayLogic

    init(view: VehicleDisplayLogic) {
        self.view = view
        self.service = VehicleService()
    }
    
    func presentVehicle(tankID: Int, completion: (() -> Void)? = nil) {
        service.getVehicle(tankID: tankID) { [weak self] (result)  in
            switch result {
            case .success(let vehicle):
                self?.view.displayVehicle(vehicle: vehicle)
                completion?()
            case .failure(let error):
                self?.view.displayError(error: error)
            }
        }
    }
    
    func presentError(error: APIError) {
        self.view.displayError(error: error)
    }
    
}
