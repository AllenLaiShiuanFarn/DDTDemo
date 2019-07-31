//
//  PlantTableViewCell.swift
//  DDTDemo
//
//  Created by Allen Lai on 2019/7/29.
//  Copyright © 2019 Allen Lai. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    // MARK: - Properties
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: nil)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .subheadline, compatibleWith: nil)
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    let featureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: nil)
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    let pictureImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = .defaultCornerRadius
        return imageView
    }()
    
    var viewModel: PlantCellViewModel?
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public method
    func setup(viewModel: PlantCellViewModel) {
        nameLabel.text = viewModel.name
        locationLabel.text = viewModel.location
        featureLabel.text = viewModel.feature
        pictureImageView.loadImage(from: viewModel.pictureURL)
        
        setNeedsLayout()
    }
    
    // MARK: - Private method
    private func setupUI() {
        addSubview(nameLabel)
        addSubview(locationLabel)
        addSubview(featureLabel)
        addSubview(pictureImageView)
        
        let defaultEdgeInsets = UIEdgeInsets(top: .defaultMargin, left: .defaultMargin, bottom: .defaultMargin, right: .defaultMargin)
        pictureImageView.anchor(top: topAnchor,
                                leading: leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                padding: defaultEdgeInsets,
                                size: CGSize(width: 88, height: 88))
        nameLabel.anchor(top: topAnchor,
                         leading: pictureImageView.trailingAnchor,
                         bottom: nil,
                         trailing: trailingAnchor,
                         padding: defaultEdgeInsets)
        locationLabel.anchor(top: nameLabel.bottomAnchor,
                             leading: pictureImageView.trailingAnchor,
                             bottom: nil,
                             trailing: trailingAnchor,
                             padding: defaultEdgeInsets)
        featureLabel.anchor(top: locationLabel.bottomAnchor,
                            leading: pictureImageView.trailingAnchor,
                            bottom: bottomAnchor,
                            trailing: trailingAnchor,
                            padding: defaultEdgeInsets)
    }
}
