//
//  VehiclesCell.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation
import UIKit

protocol VehiclesCellDelegate: AnyObject {
    func favouritesAction(cell: VehiclesCell)
}

class VehiclesCell: UITableViewCell {
    
    static let reuseId = "VehiclesCell"
    
    weak var delegate: VehiclesCellDelegate?
    
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
    
    let priceTitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    let priceTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let priceLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()

    let vehicleImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        return imageView
    }()
    
    let favouritesButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(Constants.favouritesFalseBtnImg, for: .normal)
        button.tintColor = .favourites
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        favouritesButton.addTarget(self, action: #selector(favouritesTouch), for: .touchUpInside)
        
        overlayFirstLayer()
        overlayCardView()
    }
    
    @objc func favouritesTouch() {
        delegate?.favouritesAction(cell: self)
    }
    
    private func overlayCardView() {
        cellView.addSubview(vehicleImageView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(favouritesButton)
        cellView.addSubview(descriptionLabel)
        cellView.addSubview(priceTitleLabel)
        cellView.addSubview(priceLabel)
        cellView.addSubview(priceTypeImageView)
        
        vehicleImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        vehicleImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
        vehicleImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        vehicleImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: vehicleImageView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: vehicleImageView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: favouritesButton.leadingAnchor, constant: -30).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.numberOfLines = 0
        
        priceTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        priceTitleLabel.leadingAnchor.constraint(equalTo: vehicleImageView.trailingAnchor, constant: 10).isActive = true
        priceTitleLabel.trailingAnchor.constraint(equalTo: favouritesButton.leadingAnchor, constant: -30).isActive = true
        priceTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        priceTypeImageView.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 4).isActive = true
        priceTypeImageView.leadingAnchor.constraint(equalTo: vehicleImageView.trailingAnchor, constant: 10).isActive = true
        priceTypeImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        priceTypeImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 4).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: priceTypeImageView.trailingAnchor, constant: 2).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: favouritesButton.leadingAnchor, constant: -30).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        favouritesButton.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 40).isActive = true
        favouritesButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 10).isActive = true
        favouritesButton.centerYAnchor.constraint(equalTo: vehicleImageView.centerYAnchor).isActive = true
        favouritesButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
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
    
    func set(item: VehicleModel) {
        if item.isFavourite {
            favouritesButton.setBackgroundImage(Constants.favouritesTrueBtnImg, for: .normal)
        } else {
            favouritesButton.setBackgroundImage(Constants.favouritesFalseBtnImg, for: .normal)
        }
        
        vehicleImageView.set(imageURL: item.imageUrlString)
        titleLabel.text = item.name
        descriptionLabel.text = item.vehicleDescription
        
        if !item.isGift, !item.isPremium {
            priceTitleLabel.text = tr("tankopedia.price")
            if let priceCredit = item.priceCredit {
                priceTypeImageView.image = UIImage(named: "silver")
                priceLabel.text = "\(priceCredit)"
            } else if let priceGold = item.priceGold {
                priceTypeImageView.image = UIImage(named: "gold")
                priceLabel.text = "\(priceGold)"
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Constants {
    
    static let cellInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 24)
    static let cellHeight: CGFloat = 150
    static let favouritesTrueBtnImg = UIImage(systemName: "star.fill")
    static let favouritesFalseBtnImg = UIImage(systemName: "star")
}
