//
//  FavouritesService.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 13.03.2022.
//

import Foundation

class FavouritesService {
    var coreDataManager: CoreDataManaging
    
    init() {
        self.coreDataManager = CoreDataManager()
    }
    
    func getFavourites() -> [FavouriteVehicle] {
        let vehicles = coreDataManager.getFavourites()
        return vehicles
    }
    
    func deleteVehicleFromFavourites(vehicle: VehicleModel) {
        coreDataManager.deleteVehicleFromFavourites(vehicle: vehicle)
    }
}
