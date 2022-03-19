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

protocol VehicleDetailsFavouritesLogic: AnyObject {
    func vehicleDetailsFavouritesAction(vehicle: VehicleModel?)
}

class VehicleViewController: UIViewController, Coordinatable, VehicleDisplayLogic, VehicleViewDelegate {
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
    
    weak var delegate: VehicleDetailsFavouritesLogic?
    
    private var presenter: VehiclePresenter?
    var vehicle: VehicleModel?
    
    var needToUpdateVehicle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        scrollView.addSubview(vehicleView)
        vehicleView.delegate = self
        
        vehicleView.backgroundColor = .white
        vehicleView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
        vehicleView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        vehicleView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        vehicleView.favoriteButton.isHidden = true
        
        setup()
        
        guard let tankID = vehicle?.tankID else { return }
        
        presenter?.presentVehicle(tankID: tankID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    deinit {
        if needToUpdateVehicle {
            delegate?.vehicleDetailsFavouritesAction(vehicle: vehicle)
        }
        
    }
    
    private func setup() {
        self.presenter = VehiclePresenter(view: self)
    }
    
    func displayVehicle(vehicle: VehicleItem) {
        DispatchQueue.main.async {
            self.vehicleView.hpTitleLabel.text = tr("tankopedia.hp")
            self.vehicleView.weightTitleLabel.text = tr("tankopedia.weight")
            self.vehicleView.profileIDTitleLabel.text = tr("tankopedia.profile_id")
            self.vehicleView.iconImageView.set(imageURL: self.vehicle?.imageUrlString)
            self.vehicleView.titleLabel.text = self.vehicle?.name
            
            self.vehicleView.hpLabel.text = "\(vehicle.hp)"
            self.vehicleView.weightLabel.text = "\(vehicle.weight)"
            self.vehicleView.profileIDLabel.text = vehicle.profileID
            if let isFavourite = self.vehicle?.isFavourite, isFavourite {
                self.vehicleView.favoriteButton.setBackgroundImage(Constants.favouritesTrueBtnImg, for: .normal)
            } else {
                self.vehicleView.favoriteButton.setBackgroundImage(Constants.favouritesFalseBtnImg, for: .normal)
            }
            
            self.vehicleView.favoriteButton.isHidden = false
        }
        
    }
    
    func displayError(error: APIError) {
        showAlert(withTitle: tr("error.title"), withMessage: error.errorDescription ?? tr("error.loading_error")) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func favouritesAction() {
        if vehicle?.isFavourite ?? false {
            self.vehicleView.favoriteButton.setBackgroundImage(Constants.favouritesFalseBtnImg, for: .normal)
        } else {
            self.vehicleView.favoriteButton.setBackgroundImage(Constants.favouritesTrueBtnImg, for: .normal)
        }
        vehicle?.isFavourite.toggle()
        needToUpdateVehicle.toggle()
        
    }
}
