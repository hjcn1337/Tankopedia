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
    func favouritesAction(vehicle: VehicleModel)
}

class VehiclesPresenter: VehiclesPresentationLogic {
    
    var service: VehiclesService
    private unowned let view: VehiclesDisplayLogic

    init(view: VehiclesDisplayLogic) {
        self.view = view
        self.service = VehiclesService()
    }
    
    func presentVehicles(page: Int, completion: (() -> Void)? = nil) {
        var vehicles = [VehicleModel]()
        let favouriteVehicles = service.getFavourites()
        print(favouriteVehicles)
        
        service.getVehicles(page: page) { [weak self] (result)  in
            switch result {
            case .success(let vehiclesResponse):
                for vehicleItem in vehiclesResponse {
                    vehicles.append(VehicleModel(tankID: vehicleItem.tankID,
                                                 vehicleDescription: vehicleItem.vehicleDescription,
                                                 name: vehicleItem.name,
                                                 imageUrlString: vehicleItem.images.bigIcon,
                                                 priceGold: vehicleItem.priceGold,
                                                 priceCredit: vehicleItem.priceCredit,
                                                 nation: vehicleItem.nation,
                                                 tier: vehicleItem.tier,
                                                 isWheeled: vehicleItem.isWheeled,
                                                 isGift: vehicleItem.isGift,
                                                 isPremium: vehicleItem.isPremium,
                                                 isFavourite: favouriteVehicles.contains { $0.tankID == "\(vehicleItem.tankID)" }))
                }
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
    
    func favouritesAction(vehicle: VehicleModel) {
        service.favouritesAction(vehicle: vehicle)
    }
    
}
