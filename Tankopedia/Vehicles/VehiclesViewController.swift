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
    
    private lazy var footerView = FooterView()
    
    private var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var vehiclesTableView: UITableView!
    private var vehicles: [VehiclesItem] = [] {
        didSet {
            vehiclesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
        
        presenter?.presentVehicles()
        
    }
    
    private func setup() {
        self.presenter = VehiclesPresenter(view: self)
    }
    
    private func setupTableView() {
        vehiclesTableView = UITableView(frame: view.bounds)
        vehiclesTableView.register(VehiclesCell.self, forCellReuseIdentifier: VehiclesCell.reuseId)
        vehiclesTableView.dataSource = self
        vehiclesTableView.delegate = self
        
        vehiclesTableView.addSubview(refreshControl)
        vehiclesTableView.tableFooterView = footerView
        self.view.addSubview(vehiclesTableView)
    }
    
    func displayVehicles(vehicles: [VehiclesItem]) {
        self.vehicles = vehicles
        print(#function)
        print(vehicles)
    }
    
    func displayError(error: APIError) {
        print(error.errorDescription)
    }
    
    @objc private func refresh() {
        presenter?.presentVehicles()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.2 {
            presenter?.presentVehicles()
            footerView.showLoader()
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VehiclesCell.reuseId, for: indexPath as IndexPath) as! VehiclesCell
        cell.set(item: vehicles[indexPath.row])
        return cell
    }
}

