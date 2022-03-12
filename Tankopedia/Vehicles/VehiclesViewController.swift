//
//  ViewController.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 11.03.2022.
//

import UIKit

protocol VehiclesDisplayLogic: AnyObject {
    func displayVehicles(vehicles: [VehiclesItem])
    func displayError(error: APIError)
}

class VehiclesViewController: UIViewController, VehiclesDisplayLogic {
    
    var presenter: VehiclesPresenter?
    var currentPage = 1
    var isLoading = false
    private var isRefreshRequested = false
    
    private lazy var footerView = FooterView()
    
    private var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var vehiclesTableView: UITableView!
    private var vehicles: [VehiclesItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Танковедение"
        
        setup()
        setupTableView()
        
        
        presenter?.presentVehicles(page: currentPage) { [weak self] in
            self?.isLoading = false
            self?.increasePageIndex()
        }
        isLoading = true
    }
    
    private func setup() {
        self.presenter = VehiclesPresenter(view: self)
    }
    
    private func setupTableView() {
        vehiclesTableView = UITableView(frame: view.bounds)
        vehiclesTableView.register(VehiclesCell.self, forCellReuseIdentifier: VehiclesCell.reuseId)
        vehiclesTableView.dataSource = self
        vehiclesTableView.delegate = self
        vehiclesTableView.rowHeight = UITableView.automaticDimension
        vehiclesTableView.estimatedRowHeight = 150
        
        vehiclesTableView.addSubview(refreshControl)
        footerView.setTitle("Loading...")
        vehiclesTableView.tableFooterView = footerView
        self.view.addSubview(vehiclesTableView)
    }
    
    func displayVehicles(vehicles: [VehiclesItem]) {
        if isRefreshRequested {
            self.vehicles = vehicles
        } else {
            self.vehicles.append(contentsOf: vehicles)
        }
        self.vehiclesTableView.reloadData()
    }
    
    func displayError(error: APIError) {
        print(error.errorDescription)
    }
    
    @objc private func refresh() {
        guard !isLoading else { return }
        
        currentPage = 1
        isRefreshRequested = true
        
        presenter?.presentVehicles(page: currentPage) { [weak self] in
            self?.isLoading = false
            self?.isRefreshRequested = false
            self?.refreshControl.endRefreshing()
        }
        isLoading = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !isLoading else { return }
        
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.9 {
            presenter?.presentVehicles(page: currentPage + 1) { [weak self] in
                self?.increasePageIndex()
                self?.isLoading = false
            }
            isLoading = true
            footerView.showLoader()
        }
    }
    
    private func increasePageIndex() {
        self.currentPage += 1
    }
    
}

extension VehiclesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(vehicles[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VehiclesCell.reuseId, for: indexPath as IndexPath) as! VehiclesCell
        cell.set(item: vehicles[indexPath.row])
        return cell
    }
}

