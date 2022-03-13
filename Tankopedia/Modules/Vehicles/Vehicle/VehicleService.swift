//
//  VehicleService.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation

class VehicleService {
    private var apiClient: APIClient
    
    private var vehicle: VehicleItem?
    
    init() {
        self.apiClient = APIClient()
    }
    
    func getVehicle(tankID: Int, completion: @escaping (Result<VehicleItem, APIError>) -> Void) {
        apiClient.getVehicle(tankID: tankID) { [weak self] (result)  in
            switch result {
            case .success(let result):
                self?.vehicle = result.values.first
                guard let vehicle = self?.vehicle else { return }
                completion(.success(vehicle))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
