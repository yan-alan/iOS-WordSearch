//
//  GameOverView.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers


class GameOverView: AYUIView {
    lazy var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.setFont(name: "Futura-Bold", size: 28).done()
        label.text = "Game Over"
        return label
    }()
    lazy var tableView = UITableView()
    lazy var tableTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setFont(name: "Futura-Bold", size: 20).done()
        label.text = "High Scores:"
        return label
    }()
    lazy var restartButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Restart Game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Futura-Bold", size: 17)
        return button
    }()
    override func setupView() {
        backgroundColor = UIColor(hex: 0xFFFBF1)

        title.setSuperview(self)
            .addTop(anchor: safeAreaLayoutGuide.topAnchor, constant: 10)
            .addRight()
            .addLeft().done()
        
        tableTitle.setSuperview(self)
            .addTop(anchor: title.bottomAnchor, constant: 30)
            .addRight(constant: -30)
            .addLeft(constant: 30).done()
        
        restartButton.setSuperview(self)
            .addBottom(anchor: safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .addWidth(withConstant: 200)
            .addHeight(withConstant: 50)
            .addCorners(8)
            .centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        restartButton.backgroundColor = UIColor(hex: 0xF5E3AD)
        
        tableView.setSuperview(self)
            .addTop(anchor: tableTitle.bottomAnchor, constant: 10)
            .addRight(constant: -50)
            .addLeft(constant: 50)
            .addBottom(anchor: restartButton.topAnchor, constant: -20).setColor(.clear)
    }
}
