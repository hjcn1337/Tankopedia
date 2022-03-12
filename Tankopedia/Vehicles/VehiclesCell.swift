//
//  VehiclesCell.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation
import UIKit

protocol VehiclesCellDelegate: AnyObject {
    func favoriteAction(cell: VehiclesCell)
}

class VehiclesCell: UITableViewCell {
    
    static let reuseId = "VehiclesCell"
    
    weak var delegate: VehiclesCellDelegate?
    
    let cellView: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()

    let vehicleImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        return imageView
    }()
    
    let favoriteButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(Constants.isFavoriteFalseBtnImg, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        favoriteButton.addTarget(self, action: #selector(favoriteTouch), for: .touchUpInside)
        
        overlayFirstLayer()
        overlayCardView()
    }
    
    @objc func favoriteTouch() {
        delegate?.favoriteAction(cell: self)
    }
    
    private func overlayCardView() {
        cellView.addSubview(vehicleImageView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(favoriteButton)
        
        vehicleImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        vehicleImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
        vehicleImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        vehicleImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: vehicleImageView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -30).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: vehicleImageView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.numberOfLines = 0
        
        favoriteButton.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 40).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 10).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: vehicleImageView.centerYAnchor).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
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
    
    func set(item: VehiclesItem) {
//        if viewModel.isFavorite {
//            favoriteButton.setBackgroundImage(Constants.isFavoriteTrueBtnImg, for: .normal)
//        } else {
//            favoriteButton.setBackgroundImage(Constants.isFavoriteFalseBtnImg, for: .normal)
//        }
        
        vehicleImageView.set(imageURL: item.images.bigIcon)
        titleLabel.text = item.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate enum Constants {
    
    static let cellInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 24)
    static let cellHeight: CGFloat = 150
    static let isFavoriteTrueBtnImg = UIImage(systemName: "star.fill")
    static let isFavoriteFalseBtnImg = UIImage(systemName: "star")
}
