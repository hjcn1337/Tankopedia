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
    
    private var presenter: VehiclePresenter?
    var vehicle: VehicleDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(vehicleView)
        
        vehicleView.backgroundColor = .blue
        vehicleView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        setup()
        guard let tankID = vehicle?.tankID else { return }
        
        presenter?.presentVehicle(tankID: tankID)
    }
    
    
    private func setup() {
        self.presenter = VehiclePresenter(view: self)
    }
    
    func displayVehicle(vehicle: VehicleItem) {
        DispatchQueue.main.async {
            self.vehicleView.hpTitleLabel.text = "Прочность"
            self.vehicleView.weightTitleLabel.text = "Масса"
            self.vehicleView.profileIDTitleLabel.text = "Profile ID"
            self.vehicleView.iconImageView.set(imageURL: self.vehicle?.imageURLString)
            self.vehicleView.titleLabel.text = self.vehicle?.name
            
            self.vehicleView.hpLabel.text = "\(vehicle.hp)"
            self.vehicleView.weightLabel.text = "\(vehicle.weight)"
            self.vehicleView.profileIDLabel.text = vehicle.profileID
        }
        
    }
    
    func displayError(error: APIError) {
        showAlert(withTitle: "ОШИБКА", withMessage: error.errorDescription ?? "ОШИБКА") {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
