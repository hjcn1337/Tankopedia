//
//  FavouritesCell.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 13.03.2022.
//

import Foundation
import UIKit

class FavouritesCell: UITableViewCell {
    
    static let reuseId = "FavouritesCell"
    
    let cellView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let descriptionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    

    let vehicleImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        overlayFirstLayer()
        overlayCardView()
    }
    
    private func overlayCardView() {
        cellView.addSubview(vehicleImageView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(descriptionLabel)
        
        vehicleImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        vehicleImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
        vehicleImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        vehicleImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: vehicleImageView.trailingAnchor, constant: 10).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: vehicleImageView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.numberOfLines = 0
        
        descriptionLabel.topAnchor.constraint(equalTo: vehicleImageView.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 10).isActive = true
        descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.numberOfLines = 0
    }
    
    override func prepareForReuse() {
        vehicleImageView.set(imageURL: nil)
    }
    
     private func overlayFirstLayer() {
        if #available(iOS 14.0, *) {
            contentView.addSubview(cellView)
        } else {
            addSubview(cellView)
        }
    
        cellView.fillSuperview(padding: Constants.cellInsets)
    }
    
    func set(item: FavouriteVehicleModel) {
        vehicleImageView.set(imageURL: item.imageUrlString)
        titleLabel.text = item.name
        descriptionLabel.text = item.vehicleDescription
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
