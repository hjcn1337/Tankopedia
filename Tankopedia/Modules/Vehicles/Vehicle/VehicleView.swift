//
//  VehicleView.swift
//  Tankopedia
//
//  Created by Rostislav Ermachenkov on 12.03.2022.
//

import Foundation
import UIKit

protocol VehicleViewDelegate: AnyObject {
    func favouritesAction()
}

class VehicleView: UIView {
    
    weak var delegate: VehicleViewDelegate?
    
    let iconImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        return imageView
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let hpTitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let hpLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    let weightTitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let weightLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    let profileIDTitleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let profileIDLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    let favoriteButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(Constants.favouritesFalseBtnImg, for: .normal)
        button.tintColor = .favourites
        return button
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(hpTitleLabel)
        self.addSubview(hpLabel)
        self.addSubview(weightTitleLabel)
        self.addSubview(weightLabel)
        self.addSubview(profileIDTitleLabel)
        self.addSubview(profileIDLabel)
        self.addSubview(favoriteButton)
        
        iconImageView.aspectRation(1.0/1.0).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        hpTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        hpTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        hpTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        hpTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        hpLabel.topAnchor.constraint(equalTo: hpTitleLabel.bottomAnchor, constant: 20).isActive = true
        hpLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        hpLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        hpLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        weightTitleLabel.topAnchor.constraint(equalTo: hpLabel.bottomAnchor, constant: 40).isActive = true
        weightTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        weightTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        weightTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        weightLabel.topAnchor.constraint(equalTo: weightTitleLabel.bottomAnchor, constant: 20).isActive = true
        weightLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        weightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        weightLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        profileIDTitleLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 40).isActive = true
        profileIDTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        profileIDTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        profileIDTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        profileIDLabel.topAnchor.constraint(equalTo: profileIDTitleLabel.bottomAnchor, constant: 20).isActive = true
        profileIDLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        profileIDLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        profileIDLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        favoriteButton.topAnchor.constraint(equalTo: profileIDLabel.bottomAnchor, constant: 40).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        favoriteButton.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor).isActive = true
        
        favoriteButton.addTarget(self, action: #selector(favouritesTouch), for: .touchUpInside)
    }
    
    @objc func favouritesTouch() {
        delegate?.favouritesAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

