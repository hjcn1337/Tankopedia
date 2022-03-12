//
//  VehicleViewController.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation
import UIKit

protocol VehicleDisplayLogic: AnyObject {
    func displayVehicle(vehicle: VehicleItem)
    func displayError(error: APIError)
}

class VehicleViewController: UIViewController, Coordinatable, VehicleDisplayLogic {
    private let vehicleView: VehicleView = {
        let vehicleView = VehicleView()
        vehicleView.translatesAutoresizingMaskIntoConstraints = false
        return vehicleView
    }()
    
    weak var coordinator: Coordinator?
    
    var presenter: VehiclePresenter?
    var iconImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(vehicleView)
        
        vehicleView.backgroundColor = .blue
        vehicleView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        vehicleView.iconImageView.set(imageURL: iconImage)
        
        setup()
        presenter?.presentVehicle(tankID: 1)
    }
    
    
    private func setup() {
        self.presenter = VehiclePresenter(view: self)
    }
    
    func displayVehicle(vehicle: VehicleItem) {
        print(#function)
        print(vehicle)
    }
    
    func displayError(error: APIError) {
        print(#function)
    }
}
