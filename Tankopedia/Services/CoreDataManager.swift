//
//  CoreDataManager.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 13.03.2022.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManaging {
    func addVehicleToFavourites(vehicle: VehicleModel)
    func getFavourites() -> [FavouriteVehicle]
    func deleteVehicleFromFavourites(vehicle: VehicleModel)
}

struct CoreDataManager: CoreDataManaging {

    var context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
    
    func getFavourites() -> [FavouriteVehicle] {
        let fetchRequest: NSFetchRequest<FavouriteVehicle> = FavouriteVehicle.fetchRequest()
        
        do {
            let vehicles = try context.fetch(fetchRequest)
            return vehicles
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func addVehicleToFavourites(vehicle: VehicleModel) {
        guard let entity = NSEntityDescription.entity(forEntityName: "FavouriteVehicle", in: context) else { return }
        let vehicleObject = FavouriteVehicle(entity: entity, insertInto: context)
        vehicleObject.tankID = "\(vehicle.tankID)"
        vehicleObject.imageUrlString = vehicle.imageUrlString
        vehicleObject.name = vehicle.name
        vehicleObject.desc = vehicle.vehicleDescription
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteVehicleFromFavourites(vehicle: VehicleModel) {
        let fetchRequest: NSFetchRequest<FavouriteVehicle> = FavouriteVehicle.fetchRequest()
        let predicate = NSPredicate(format: "tankID == %@", "\(vehicle.tankID)")
        fetchRequest.predicate = predicate
        
        do {
            let vehiclesArray = try context.fetch(fetchRequest)
            guard let vehicleToDelete = vehiclesArray.first else { return }
            context.delete(vehicleToDelete)
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
