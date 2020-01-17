//
//  GameView.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-09.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers

class GameView: AYUIView {
    lazy var timeLayer = UIView()
    lazy var stackList: [UIStackView] = []
    lazy var buttonList: [BoardPiece] = []
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Score: 0"
        label.setFont(name: "Futura-Bold", size: 20).done()
        label.textColor = .black
        return label
    }()
    var wordsModel: [String] = []
    {
        didSet {
            var placed = false
            while !placed {
                print("placing")
                placed = placeWords()
            }
        }
    }
    lazy var hStack : UIStackView = {
        let hStack = UIStackView()
        hStack.alignment = .fill
        hStack.axis = .vertical
        hStack.spacing = 1
        hStack.distribution = .fillEqually
        return hStack
    }()
    lazy var timer: UILabel = {
        let timer = UILabel()
        timer.text = "00:00"
        timer.textColor = .black
        timer.textAlignment = .center
        return timer
    }()
    override func setupView() {
        backgroundColor = UIColor(hex: 0xFFFBF1)
        //timeLayer constraint and subview setup
        timeLayer.setSuperview(self)
            .addLeft()
            .addRight()
            .addBottom()
            .addHeight(withConstant: UIScreen.main.bounds.height).setColor(UIColor(hex: 0xF5E3AD)).done()
        
        //scoreLabel constraint and subview setup
        scoreLabel.setSuperview(self)
            .addRight(anchor: safeAreaLayoutGuide.rightAnchor, constant: -20)
            .addBottom(anchor: safeAreaLayoutGuide.bottomAnchor, constant: -10)
            .addHeight(withConstant: 20).done()
        
        //timerImageView constraint and subview setup
        let timerImageView = UIImageView()
            .setSuperview(self)
            .addBottom(anchor: safeAreaLayoutGuide.bottomAnchor, constant: -10)
            .addLeft(anchor: safeAreaLayoutGuide.leftAnchor, constant: 20)
        if #available(iOS 13.0, *) {
            timerImageView.image = UIImage(systemName: "timer")
        } else {
            // Fallback on earlier versions
        }
        //timer constraint setup and subview setup
        timer.setFont(name: "Futura", size: 20).setSuperview(self)
            .addBottom(anchor: safeAreaLayoutGuide.bottomAnchor, constant: -10)
            .addHeight(withConstant: 20)
            .addLeft(anchor: timerImageView.rightAnchor, constant: 20).done()
        
        //hStack constraint setup and subview setup
        hStack.setSuperview(self)
            .addHeight(withConstant: 350)
            .addLeft(constant: 5)
            .addRight(constant: -5).done()
        hStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        hStack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        
        //topImageView constraint setup and subview setup
        let topImageView = ContentFitImageView().setSuperview(self)
            .addTop(anchor: safeAreaLayoutGuide.topAnchor, constant: 20)
            .addRight(constant: -50)
            .addLeft(constant: 50)
            .addBottom(anchor: hStack.topAnchor, constant: -20)
        topImageView.image = UIImage(named: "magnify")


        //sets up 10x10 board
        setupStacks()
    }
    /**
        Creates a 10x10 board of board pieces
     */
    private func setupStacks() {
        var stack: UIStackView
        for i in 0..<10 {
            stack = UIStackView()
            stack.alignment = .fill
            stack.axis = .horizontal
            stack.spacing = 1
            stack.distribution = .fillEqually
            for j in 0..<10 {
                let piece = BoardPiece()
                piece.index = i*10 + j
                piece.text.text = randomString(length: 1)
                stack.addArrangedSubview(piece)
                buttonList.append(piece)
            }
            hStack.addArrangedSubview(stack)
            stackList.append(stack)
        }
    }
    /**
        Finds a random character in the alphabet
     
        - Returns: A string of a random character
     */
    private func randomString(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    /**
       Finds a random character in the alphabet
    
       - Returns: A string of a random character
    */
    private func placeWords() -> Bool {
        for anyCaseWord in wordsModel {
            let word = anyCaseWord.uppercased() //uppercases the word
            var startingIndex = Int.random(in: 0..<100)
            while(startingIndex % 10 > (9-word.count) && (10-(startingIndex/10) < word.count)) {
                startingIndex = Int.random(in: 0..<100)
            } //finds a random starting place
            var currentIndex = startingIndex
            var found = false
            while(!found) { //while a spot to the put the word is not found
                let direction = Direction.allCases.randomElement() //choose a random direction
                
                switch direction {
                case .horizontal: //if horizontal attempt horizontal first and then vertical if that doesnt find a spot
                    found = attemptHorizontal(startingAt: currentIndex, word: word)
                    if(!found) {
                        found = attemptVertical(startingAt: currentIndex, word: word)
                        if(!found) {
                            
                        }
                    }
                case .vertical: //if vertical attempt vertical first and then horizontal if that doesnt find a spot
                    found = attemptVertical(startingAt: currentIndex, word: word)
                    if(!found) {
                        found = attemptHorizontal(startingAt: currentIndex, word: word)
                        if(!found) {
                            
                        }
                    }
                case .diagonal:
                    #warning("Implement")
                case .none:
                    fatalError()
                }
                currentIndex += 1 //move to the next index to see if that works for a position
                if(currentIndex == 100) {
                    currentIndex = 0 //loop back
                }
                if(currentIndex == startingIndex) { //if we arrive back at the starting index then this board cannot place our word
                    print("failed")
                    buttonList.forEach({$0.notRandomlySet = false})
                    return false //so return false
                }
            }
        }
        return true //return true if we make it through the for loop
    }
    /**
       Attempts to place the line starting at the starting index horizontally
    
       - Returns: Boolean, true if word can be placed horizontally
    */
    private func attemptHorizontal(startingAt: Int, word: String) -> Bool {
        let previous = startingAt
        for x in startingAt..<startingAt+word.count {
            if(x/10 != previous/10 || x > 99) {
                return false
            }
            let index = word.index(word.startIndex, offsetBy: (x-startingAt))
            if(String(word[index]) != buttonList[x].text.text && buttonList[x].notRandomlySet) {
                return false
            }
        }
        for x in 0..<word.count {
            let index = word.index(word.startIndex, offsetBy: (x))
            buttonList[x+startingAt].text.text = String(word[index])
            buttonList[x+startingAt].notRandomlySet = true

        }
        return true
    }
    /**
       Attempts to place the line starting at the starting index vertically
    
       - Returns: Boolean, true if word can be placed vertically
    */
    private func attemptVertical(startingAt: Int, word: String) -> Bool {
        for x in 0..<word.count {
            if(startingAt + x*10 > 99) { //if overflows the board
                return false
            }
            let index = word.index(word.startIndex, offsetBy: (x))
            if(String(word[index]) != buttonList[startingAt + x*10].text.text && buttonList[startingAt + x*10].notRandomlySet) {
                return false
            }
        }
        for x in 0..<word.count {
            let index = word.index(word.startIndex, offsetBy: (x))
            buttonList[x*10+startingAt].text.text = String(word[index])
            buttonList[x*10+startingAt].notRandomlySet = true
        }
        return true
    }
}

