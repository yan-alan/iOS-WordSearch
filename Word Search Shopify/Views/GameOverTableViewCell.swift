//
//  GameOverTableViewCell.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//
import UIKit
import AlanYanHelpers

class GameOverTableViewCell: UITableViewCell {
    lazy var nameLabel = UILabel()
    lazy var scoreLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear
        scoreLabel.setSuperview(self).addTop().addBottom().addRight(anchor: rightAnchor, constant: -20).addWidth(withConstant: 50).done()
        nameLabel.setSuperview(self).addTop().addLeft(constant: 10).addBottom().addRight(anchor: scoreLabel.leftAnchor, constant: -5).done()

        nameLabel.setFont(name: "Futura", size: 18).done()
        scoreLabel.setFont(name: "Futura", size: 18).done()
        nameLabel.textColor = .black
        scoreLabel.textColor = .black
        nameLabel.textAlignment = .left
        scoreLabel.textAlignment = .right
    }
    
}
