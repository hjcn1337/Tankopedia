//
//  FavouritesViewController.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 13.03.2022.
//

import Foundation
import UIKit

protocol FavouritesDisplayLogic: AnyObject {
    func displayFavourites(vehicles: [FavouriteVehicleModel])
}

class FavouritesViewController: UIViewController, Coordinatable, FavouritesDisplayLogic {
    weak var coordinator: Coordinator?
    
    var presenter: FavouritesPresentationLogic?
    
    private var vehicles: [FavouriteVehicleModel] = []
    
    private var favouritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = tr("favourites.title")
        
        setup()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.presentFavourites()
    }
    
    private func setup() {
        self.presenter = FavouritesPresenter(view: self)
    }
    
    private func setupTableView() {
        favouritesTableView = UITableView(frame: view.bounds)
        if let tabBarController = self.tabBarController {
            let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: tabBarController.tabBar.frame.height, right: 0)
            favouritesTableView.contentInset = adjustForTabbarInsets
            favouritesTableView.scrollIndicatorInsets = adjustForTabbarInsets
        }
        favouritesTableView.register(FavouritesCell.self, forCellReuseIdentifier: FavouritesCell.reuseId)
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        favouritesTableView.rowHeight = UITableView.automaticDimension
        favouritesTableView.estimatedRowHeight = 150
        
        self.view.addSubview(favouritesTableView)
    }
    
    func displayFavourites(vehicles: [FavouriteVehicleModel]) {
        self.vehicles = vehicles
        self.favouritesTableView.reloadData()
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesCell.reuseId, for: indexPath) as! FavouritesCell
        let vehicle = vehicles[indexPath.row]
        cell.set(item: vehicle)

        return cell
    }
}
