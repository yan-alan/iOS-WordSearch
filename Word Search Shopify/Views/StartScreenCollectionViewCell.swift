//
//  StartScreenCollectionViewCell.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers

class StartScreenCollectionViewCell: UICollectionViewCell {
    lazy var text: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.setFont(name: "Futura-Bold", size: 17).done()
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addCorners(8).setColor(UIColor(hex: 0xF5E3AD))
        
        //text on the collection view
        text.setSuperview(self)
            .addLeading(anchor: leadingAnchor, constant: 10)
            .addTrailing(anchor: trailingAnchor, constant: -10).done()
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
