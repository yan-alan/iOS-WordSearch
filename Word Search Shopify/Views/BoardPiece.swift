//
//  BoardPiece.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//
import AlanYanHelpers
import UIKit

class BoardPiece: AYUIView {
    /// index of the piece in buttonList
    var index: Int!
    /// variable to see whether the board piece was a random generated letter or if it was set
    lazy var notRandomlySet = false
    /// the letter on the board piece
    lazy var text: UILabel = {
        let label = UILabel()
        label.setFont(name: "Futura-Bold", size: 20).textColor = .black
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    /// the back colour view
    lazy var colourView = UIView()
    override func setupView() {
        //view setup
        backgroundColor = .clear
        colourView.setSuperview(self).done()
        
        //text constraint and subview setup
        text.setSuperview(self).done()
        text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        text.addWidth(withConstant: 23).done()
        
        //colourView constraint and subview setup
        colourView.addHeight(withConstant: 30).done()
        colourView.widthAnchor.constraint(equalTo: text.widthAnchor, constant: 5).isActive = true
        colourView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        colourView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        colourView.addCorners(5).setColor(UIColor(hex: 0xF8F2E1)).done()
    }
}


class BiggerBoardPiece: AYUIView {
    /// index of the piece in buttonList
    var index: Int!
    /// variable to see whether the board piece was a random generated letter or if it was set
    lazy var notRandomlySet = false
    /// the letter on the board piece
    lazy var text: UILabel = {
        let label = UILabel()
        label.setFont(name: "Futura-Bold", size: 25).textColor = .black
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    /// the back colour view
    lazy var colourView = UIView()
    override func setupView() {
        //view setup
        backgroundColor = .clear
        colourView.setSuperview(self).done()
        
        //text constraint and subview setup
        text.setSuperview(self).done()
        text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        text.addWidth(withConstant: 30).done()
        
        //colourView constraint and subview setup
        colourView.addHeight(withConstant: 35).done()
        colourView.widthAnchor.constraint(equalTo: text.widthAnchor, constant: 5).isActive = true
        colourView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        colourView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        colourView.addCorners(5).setColor(UIColor(hex: 0xF8F2E1)).done()
    }
}
