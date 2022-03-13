//
//  VehiclesService.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation

class VehiclesService {
    private var apiClient: APIClient
    private var coreDataManager: CoreDataManaging
    
    private var vehicles: [VehiclesItem]?
    
    init() {
        self.apiClient = APIClient()
        self.coreDataManager = CoreDataManager()
    }
    
    func getVehicles(page: Int, completion: @escaping (Result<[VehiclesItem], APIError>) -> Void) {
        apiClient.getVehicles(page: page) { [weak self] (result)  in
            switch result {
            case .success(let result):
                self?.vehicles = Array(result.values)
                guard let vehicles = self?.vehicles else { return }
                completion(.success(vehicles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func getFavourites() -> [FavouriteVehicle] {
        return coreDataManager.getFavourites()
    }
    
    func favouritesAction(vehicle: VehicleModel) {
        if vehicle.isFavourite {
            coreDataManager.deleteVehicleFromFavourites(vehicle: vehicle)
        } else {
            coreDataManager.addVehicleToFavourites(vehicle: vehicle)
        }
    }
}
