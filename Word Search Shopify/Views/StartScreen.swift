//
//  StartScreen.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-13.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers

class StartScreenView: AYUIView {
    lazy var buttonList: [BiggerBoardPiece] = []
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.setFont(name: "Futura-Bold", size: 32).done()
        label.text = "iOS Word Search"
        return label
    }()
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.setFont(name: "Futura", size: 22).done()
        label.text = "Alan Yan"
        return label
    }()
    lazy var startStack = UIStackView()
    lazy var wordsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.setFont(name: "Futura", size: 18).done()
        label.text = "Current Words (Tap To Remove): "
        return label
    }()
    lazy var introParagraph: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.setFont(name: "Futura", size: 16).done()
        label.numberOfLines = 0
        label.text = "Welcome to my iOS Word Search game. The goal of the game is to find the words below within 90 seconds, along with any other English words longer than 2 letters. You can add custom words below. Once ready to start, drag your finger across the START"
        return label
    }()
    lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        // note: since the labels are "auto-width-stretching", the height here defines the actual height of the cells
        layout.estimatedItemSize = CGSize(width: 30, height: 35)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.allowsSelection = true
        collection.showsVerticalScrollIndicator = false

        return collection
    }()
    lazy var bottomView = UIView()
    lazy var shadowBottomView = ShadowUIView(radius: 2, subLayer: bottomView)
    lazy var searchBar: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.placeholder = "add a word..."
        textField.text = ""
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words


        textField.textAlignment = .left

        return textField
    }()
    lazy var errorLabel = UILabel()
    lazy var tooLongLabel = UILabel()

    lazy var searchButton = UIButton()
    override func setupView() {
        backgroundColor = UIColor(hex: 0xFFFBF1)
        //Title Set Up
        title.setSuperview(self)
            .addTop(anchor: safeAreaLayoutGuide.topAnchor, constant: 10)
            .addLeading(anchor: safeAreaLayoutGuide.leadingAnchor)
            .addTrailing(anchor: safeAreaLayoutGuide.trailingAnchor).done()
        //SubTitle Set Up
        subTitle.setSuperview(self)
            .addTop(anchor: title.bottomAnchor, constant:5)
            .addLeading(anchor: safeAreaLayoutGuide.leadingAnchor)
            .addTrailing(anchor: safeAreaLayoutGuide.trailingAnchor).done()
        //Start Stack View Setup
        startStack.setSuperview(self)
            .addTop(anchor: subTitle.bottomAnchor, constant: 15)
            .addHeight(withConstant: 40)
            .addWidth(withConstant: 195).setColor(.clear).done()
        startStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        setupStack()
        //Into Paragraph Constraints
        introParagraph.setSuperview(self)
            .addTop(anchor: startStack.bottomAnchor, constant:20)
            .addLeading(anchor: safeAreaLayoutGuide.leadingAnchor, constant: 30)
            .addTrailing(anchor: safeAreaLayoutGuide.trailingAnchor, constant: -30).done()
        wordsLabel.setSuperview(self)
            .addTop(anchor: introParagraph.bottomAnchor, constant:20)
            .addLeading(anchor: safeAreaLayoutGuide.leadingAnchor, constant: 30)
            .addTrailing(anchor: safeAreaLayoutGuide.trailingAnchor, constant: -30).done()
        //Collection View Setup
        collectionView.setSuperview(self)
            .addLeft(constant: 30)
            .addRight(constant: -30)
            .addBottom()
            .addTop(anchor: wordsLabel.bottomAnchor, constant: 15).setColor(.clear).done()
        
        //Add Bar Setup
        bottomView.setColor(.white).done()
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 25
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        shadowBottomView.setSuperview(self).addBottom().addRight().addLeft().addHeight(withConstant: 120).done()
        
        //Search View Setup
        let searchView = UIView()
        searchView.setSuperview(self)
            .addLeft(constant: 30).addRight(constant: -30)
            .addTop(anchor: bottomView.topAnchor, constant: 20)
            .addHeight(withConstant: 50)
            .addCorners(25).done()
        searchView.layer.borderWidth = 1.5
        searchView.layer.borderColor = UIColor.black.cgColor
        
        //Search Button Setup
        searchButton.setSuperview(self)
            .addTop(anchor: searchView.topAnchor)
            .addRight(anchor: searchView.rightAnchor)
            .addBottom(anchor: searchView.bottomAnchor)
            .addWidth(withConstant: 50).done()
        searchButton.isHidden = true
        
        // Search Bar Image Setup
        let image = ContentFitImageView()
        image.setSuperview(searchButton).addConstraints(padding: 10).done()
        image.image = UIImage(named:"add")
        
        // Word Label Setup
        let addWordLabel = UILabel()
        addWordLabel.setSuperview(self)
            .addLeft(anchor: searchView.leftAnchor, constant: 20)
            .addWidth(withConstant: 100)
            .centerYAnchor.constraint(equalTo: searchView.topAnchor).isActive = true
        addWordLabel.textColor = .black
        addWordLabel.textAlignment = .center
        addWordLabel.backgroundColor = .white
        addWordLabel.text = "Add Word"
        
        // Error Label Setup
        errorLabel.setSuperview(self).addLeft(anchor: searchView.leftAnchor, constant: 20).addWidth(withConstant: 160).addBottom(anchor: searchView.topAnchor, constant: -10).addHeight(withConstant: 0).addCorners(7).setColor(UIColor(hex: 0xDC4545)).done()
        errorLabel.textAlignment = .center
        errorLabel.text = "At Max Words"
        errorLabel.textColor = .black
        
        // Too Long Label Setup
        tooLongLabel.setSuperview(self)
            .addLeft(anchor: searchView.leftAnchor, constant: 20)
            .addWidth(withConstant: 160)
            .addBottom(anchor: searchView.topAnchor, constant: -10)
            .addHeight(withConstant: 0)
            .addCorners(7).setColor(UIColor(hex: 0xDC4545)).done()
        tooLongLabel.textAlignment = .center
        tooLongLabel.text = "Max 10 Characters"
        tooLongLabel.textColor = .black

        
        // Search Bar Setup
        searchBar.setSuperview(self)
            .addTop(anchor: searchView.topAnchor)
            .addLeading(anchor: searchView.leadingAnchor, constant: 20)
            .addBottom(anchor: searchView.bottomAnchor)
            .addTrailing(anchor: searchButton.leadingAnchor, constant: -20).done()
    }
    private func setupStack() {
        startStack.alignment = .fill
        startStack.axis = .horizontal
        startStack.spacing = 1
        startStack.distribution = .fillEqually
        let start = ["S","T","A","R","T"]
        for i in 0..<5 {
            let piece = BiggerBoardPiece()
            piece.index = i
            piece.text.text = start[i]
            startStack.addArrangedSubview(piece)
            buttonList.append(piece)
        }
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
