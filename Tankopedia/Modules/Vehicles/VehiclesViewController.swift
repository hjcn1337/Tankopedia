//
//  ViewController.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 11.03.2022.
//

import UIKit

protocol VehiclesDisplayLogic: AnyObject {
    func displayVehicles(vehicles: [VehicleModel])
    func displayError(error: APIError)
}

protocol VehiclesViewDelegate {
    func didSelectVehicle(vehicle: VehicleModel)
}

class VehiclesViewController: UIViewController, Coordinatable, VehiclesDisplayLogic, VehiclesCellDelegate, VehicleDetailsFavouritesLogic {
    var coordinator: Coordinator?

    private var vehiclesCoordinator: VehiclesCoordinator? { coordinator as? VehiclesCoordinator }
    
    private var presenter: VehiclesPresenter?
    private var currentPage = 1
    private var isLoading = false
    private var isRefreshRequested = false
    
    private lazy var footerView = FooterView()
    
    private var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var vehiclesTableView: UITableView!
    private var vehicles: [VehicleModel] = []
    
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = tr("tankopedia.title")
        
        setup()
        setupTableView()
        
        presenter?.presentVehicles(page: currentPage) { [weak self] in
            self?.endLoading(needToIncreasePageIndex: true)
        }
        isLoading = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    private func setup() {
        self.presenter = VehiclesPresenter(view: self)
    }
    
    private func setupTableView() {
        vehiclesTableView = UITableView(frame: view.bounds)
        if let tabBarController = self.tabBarController {
            let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarController.tabBar.frame.height, right: 0)
            vehiclesTableView.contentInset = adjustForTabbarInsets
            vehiclesTableView.scrollIndicatorInsets = adjustForTabbarInsets
        }
        vehiclesTableView.register(VehiclesCell.self, forCellReuseIdentifier: VehiclesCell.reuseId)
        vehiclesTableView.dataSource = self
        vehiclesTableView.delegate = self
        vehiclesTableView.rowHeight = UITableView.automaticDimension
        vehiclesTableView.estimatedRowHeight = 150
        
        vehiclesTableView.addSubview(refreshControl)
        footerView.setTitle(tr("loading.title"))
        vehiclesTableView.tableFooterView = footerView
        self.view.addSubview(vehiclesTableView)
    }
    
    func displayVehicles(vehicles: [VehicleModel]) {
        if isRefreshRequested {
            self.vehicles = vehicles
        } else {
            self.vehicles.append(contentsOf: vehicles)
        }
        self.vehiclesTableView.reloadData()
    }
    
    func displayError(error: APIError) {
        showAlert(withTitle: tr("error.title"), withMessage: error.errorDescription ?? tr("error.loading_error")) {
            self.endLoading()
        }
    }
    
    @objc private func refresh() {
        guard !isLoading else { return }
        
        currentPage = 1
        isRefreshRequested = true
        
        presenter?.presentVehicles(page: currentPage) { [weak self] in
            self?.endLoading()
        }
        isLoading = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !isLoading else { return }
        
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.9 {
            presenter?.presentVehicles(page: currentPage) { [weak self] in
                self?.endLoading(needToIncreasePageIndex: true)
            }
            isLoading = true
            footerView.showLoader()
        }
    }
    
    private func increasePageIndex() {
        self.currentPage += 1
    }
    
    private func endLoading(needToIncreasePageIndex: Bool = false) {
        if needToIncreasePageIndex {
            self.increasePageIndex()
        }
        self.isLoading = false
        self.isRefreshRequested = false
        self.refreshControl.endRefreshing()
    }
    
    func favouritesAction(cell: VehiclesCell) {
        guard let indexPath = vehiclesTableView.indexPath(for: cell) else { return }
        let vehicle = vehicles[indexPath.row]
        if vehicle.isFavourite {
            cell.favouritesButton.setBackgroundImage(Constants.favouritesFalseBtnImg, for: .normal)
            vehicles[indexPath.row].isFavourite = false
        } else {
            cell.favouritesButton.setBackgroundImage(Constants.favouritesTrueBtnImg, for: .normal)
            vehicles[indexPath.row].isFavourite = true
        }
        presenter?.favouritesAction(vehicle: vehicle)
    }
    
    func vehicleDetailsFavouritesAction(vehicle: VehicleModel?) {
        guard
            let vehicle = vehicle,
            let selectedIndexPath = selectedIndexPath,
            let cell = vehiclesTableView.cellForRow(at: selectedIndexPath) as? VehiclesCell
        else { return }

        presenter?.favouritesAction(vehicle: vehicles[selectedIndexPath.row])
        
        if vehicle.isFavourite {
            cell.favouritesButton.setBackgroundImage(Constants.favouritesTrueBtnImg, for: .normal)
            vehicles[selectedIndexPath.row].isFavourite = true
        } else {
            cell.favouritesButton.setBackgroundImage(Constants.favouritesFalseBtnImg, for: .normal)
            vehicles[selectedIndexPath.row].isFavourite = false
            
        }
        
    }
    
}

extension VehiclesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vehicle = vehicles[indexPath.row]
        selectedIndexPath = indexPath
        didSelectVehicle(vehicle: vehicle)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VehiclesCell.reuseId, for: indexPath as IndexPath) as! VehiclesCell
        cell.set(item: vehicles[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension VehiclesViewController: VehiclesViewDelegate {
    
    func didSelectVehicle(vehicle: VehicleModel) {
        vehiclesCoordinator?.navigateToVehicleDetails(vehicle: vehicle)
    }
}
