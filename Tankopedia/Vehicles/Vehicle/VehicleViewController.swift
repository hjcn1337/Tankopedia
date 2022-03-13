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
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
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
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        scrollView.addSubview(vehicleView)
        
        vehicleView.backgroundColor = .white
        vehicleView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
        vehicleView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        vehicleView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        vehicleView.favoriteButton.isHidden = true
        
        setup()
        guard let tankID = vehicle?.tankID else { return }
        
        presenter?.presentVehicle(tankID: tankID)
    }
    
    
    private func setup() {
        self.presenter = VehiclePresenter(view: self)
    }
    
    func displayVehicle(vehicle: VehicleItem) {
        DispatchQueue.main.async {
            self.vehicleView.hpTitleLabel.text = tr("tankopedia.hp")
            self.vehicleView.weightTitleLabel.text = tr("tankopedia.weight")
            self.vehicleView.profileIDTitleLabel.text = tr("tankopedia.profile_id")
            self.vehicleView.iconImageView.set(imageURL: self.vehicle?.imageURLString)
            self.vehicleView.titleLabel.text = self.vehicle?.name
            
            self.vehicleView.hpLabel.text = "\(vehicle.hp)"
            self.vehicleView.weightLabel.text = "\(vehicle.weight)"
            self.vehicleView.profileIDLabel.text = vehicle.profileID
            self.vehicleView.favoriteButton.isHidden = false
        }
        
    }
    
    func displayError(error: APIError) {
        showAlert(withTitle: tr("error.title"), withMessage: error.errorDescription ?? tr("error.loading_error")) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
