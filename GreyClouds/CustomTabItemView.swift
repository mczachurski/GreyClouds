//
//  CustomTabItemView.swift
//  ClearSky
//
//  Created by Marcin Czachurski on 14.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

class CustomTabItemView : TabItemView {

    public var imageName: String? {
        didSet {
            imageView.image = UIImage(named: imageName ?? "clear")
        }
    }
    public var details: String? {
        didSet {
            detailsLabel.text = details
        }
    }

    public var isBoldTitle = false

    private var imageView: UIImageView!
    private var detailsLabel: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        titleLabel = UILabel(frame: CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: 14))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: self.isBoldTitle ? UIFont.Weight.bold : UIFont.Weight.light)
        titleLabel.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.85)
        titleLabel.backgroundColor = UIColor.clear
        addSubview(titleLabel)

        imageView = UIImageView(frame: CGRect(x: bounds.origin.x, y: bounds.origin.y, width: 24, height: 24))
        addSubview(imageView)

        detailsLabel = UILabel(frame: CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: 14))
        detailsLabel.textAlignment = .center
        detailsLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.light)
        detailsLabel.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.85)
        detailsLabel.backgroundColor = UIColor.clear
        addSubview(detailsLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            detailsLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            detailsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            detailsLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
