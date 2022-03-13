//
//  FavouritesPresenter.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 13.03.2022.
//

import Foundation

protocol FavouritesPresentationLogic {
    func presentFavourites()
}

class FavouritesPresenter: FavouritesPresentationLogic {
    
    var service: FavouritesService
    unowned let view: FavouritesDisplayLogic
    
    init(view: FavouritesDisplayLogic) {
        self.view = view
        self.service = FavouritesService()
    }
    
    func presentFavourites() {
        let favouriteVehicles = service.getFavourites()
        
        var vehicles = [FavouriteVehicleModel]()
        
        for favouriteVehicle in favouriteVehicles {
            guard let tankID = favouriteVehicle.tankID,
                  let name = favouriteVehicle.name,
                  let desc = favouriteVehicle.desc,
                  let imageUrlString = favouriteVehicle.imageUrlString
            else { return }
            
            vehicles.append(FavouriteVehicleModel(tankID: tankID, vehicleDescription: desc, name: name, imageUrlString: imageUrlString))
        }
        
        self.view.displayFavourites(vehicles: vehicles)
    }

}
