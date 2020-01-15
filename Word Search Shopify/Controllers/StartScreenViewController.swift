//
//  StartScreenViewController.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-13.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit
import AlanYanHelpers

/// View Controller that consists of the start screen view and controls the input handling on this screen
class StartScreenViewController: UIViewController, UITextFieldDelegate {
    /// The current words to pass on to the Game View Controller
    private var words = ["Swift", "Kotlin", "Java", "Mobile", "Variable", "ObjectiveC"]
    /// the collection view that holds the current words
    private var collectionView: UICollectionView!
    /// the bottom view that consists of the input label
    private var bottomShelf: UIView!
    /// button with a plus image
    private var addButton: UIButton!
    /// the text field that takes in entered words
    private var searchBar: UITextField!
    /// the stack view for the 5 buttons to start the game
    private var stackView: UIStackView!
    /// the button list for the 5 buttons
    private var buttonList: [BiggerBoardPiece]!
    /// boolean representing if the pan gesture has started on the right tile
    private var startRight = false
    /// label for trying to enter a new words once there are 10 words
    private var errorLabel: UILabel!
    /// label for entries that are too long
    private var charWarningLabel: UILabel!
    /// array of board pieces representing the current pieces selected
    private var currentPieces: [BiggerBoardPiece] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))

        let newView = StartScreenView()
        bottomShelf = newView.shadowBottomView
        buttonList = newView.buttonList
        addButton = newView.searchButton
        stackView = newView.startStack
        errorLabel = newView.errorLabel
        charWarningLabel = newView.tooLongLabel
        searchBar = newView.searchBar
        newView.searchBar.delegate = self
        newView.addGestureRecognizer(gesture)
        newView.searchButton.addTarget(self, action: #selector(addWord), for: .touchUpInside)

        collectionView = newView.collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StartScreenCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.view = newView
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOutside))
               tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: Text Field Interaction Methods
    /**
        Dismisses the keyboard and brings the bottomShelf back down

        - Parameters: None
     
        - Returns: Void
    */
    @objc func tappedOutside() {
        self.view.endEditing(true)
        bottomShelf.userDefinedConstraintDict["height"]!.constant = 120
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    /**
        Dismisses the keyboard, brings the bottomShelf back down and adds the word if valid

        - Parameters:
            - textField: text field that should conclude editing
     
        - Returns: Void
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        bottomShelf.userDefinedConstraintDict["height"]!.constant = 120
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        if(textField.text != "" && textField.text != nil) {
            addWord()
        }
        return true
    }
    /**
        If less than 10 words returns true

        - Parameters:
            - textField: text field that should begin editing
     
        - Returns: whether the text field should begin editing
    */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Should adjust height")
        if(words.count < 10) {
            bottomShelf.userDefinedConstraintDict["height"]!.constant = 410
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            return true
        } else {
            showLabel(label: errorLabel)
            return false
        }
    }
    /**
        If textField should add the input character, returns true if less than 10 characters and not a space
     
        - Returns: whether the text field should accept string
    */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string != "") {
            if string == " " {
                print("no spaces")
                return false
            }
            addButton.isHidden = false
            UIView.animate(withDuration: 0.2) {
                self.addButton.alpha = 1
            }
            if(textField.text!.count == 10) {
                showLabel(label: charWarningLabel)
                return false
            }
        } else {
            if let text = textField.text {
                if(text.count == 1) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.addButton.alpha = 0
                    }) { (valid) in
                    self.addButton.isHidden = true
                    }
                }
            }
        }
        return true
    }
    /**
        Shows a label by changing the height constraint with animation
     
        - Precondition: label must have a height constraint added with AlanYanHelpers
     
        - Parameters:
            - label: error label that should be opened
     
        - Returns: whether the text field should begin editing
    */
    private func showLabel(label: UILabel) {
        label.userDefinedConstraintDict["height"]!.constant = 30
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            label.userDefinedConstraintDict["height"]?.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    /**
        Shifts bottom shelf back to bottom and sets errors down
     
        - Precondition: bottomShelf, errorLabel and charWarning must have a height constraint added with AlanYanHelpers
     
        - Parameters:
            - label: error label that should be opened
     
        - Returns: whether the text field should begin editing
    */
    @objc private func addWord() {
       self.view.endEditing(true)
       bottomShelf.userDefinedConstraintDict["height"]!.constant = 120
       UIView.animate(withDuration: 0.2) {
           self.view.layoutIfNeeded()
       }
       if(words.count < 10) {
           errorLabel.userDefinedConstraintDict["height"]!.constant = 0
           charWarningLabel.userDefinedConstraintDict["height"]!.constant = 0
           UIView.animate(withDuration: 0.2) {
               self.view.layoutIfNeeded()
           }
           words.append(searchBar.text!)
           collectionView.reloadData()
       }
       searchBar.text = nil
       addButton.isHidden = true
    }
    //MARK: Start Button Interaction
    /**
        Method to handle pan gesture handling
          
        - Parameters:
            - sender: pan gesture that recognized the tap
     
        - Returns: Void
    */
    @objc private func didPan(sender: UIPanGestureRecognizer) {
        let panLocation = sender.location(in: stackView)
        let width = stackView.bounds.maxX/5
        
        let pieceIndex = Int((panLocation.x/width).rounded(.down))
        
        guard (pieceIndex < 5 && pieceIndex >= 0), panLocation.y < 50 else {
            checkGesture(sender: sender)
            return
        }
        guard currentPieces.contains(buttonList[pieceIndex]) == false else {
            checkGesture(sender: sender)
            return
        }
        currentPieces.append(buttonList[pieceIndex])
        buttonList[pieceIndex].colourView.backgroundColor = .gray
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        checkGesture(sender: sender)
    }
    /**
           Method to see if the gesture has ended, or if the finger has been lifted
             
           - Parameters:
               - sender: pan gesture that recognized the tap
        
           - Returns: Void
    */
    private func checkGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            buttonList.forEach({$0.colourView.backgroundColor = UIColor(hex: 0xF8F2E1)})
            if currentPieces.count == 5 && currentPieces.first == buttonList.first {
                createLine()
                self.startGame()
            }
            currentPieces = []
        }
    }
    /**
            Creates a horizontal line view to display the line
     
           - Parameters: None
        
           - Returns: Void
    */
    private func createLine() {
        HorizontalLineView()
            .setSuperview(stackView!)
            .addTop(anchor: stackView.centerYAnchor, constant: -1)
            .addLeading(anchor: stackView.leadingAnchor, constant: 15)
            .addTrailing(anchor: stackView.trailingAnchor, constant: -15)
            .addBottom(anchor: stackView.centerYAnchor, constant: 1).done()
    }
    /**
            Starts the game by presenting the GameViewController
     
           - Parameters: None
        
           - Returns: Void
    */
    private func startGame() {
        print("presenting")
        let newVC = GameViewController()
        let upperCasedWords = words.map({$0.uppercased()})
        newVC.words = upperCasedWords
        navigationController?.pushViewController(newVC, animated: true)
    }
}

extension StartScreenViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //MARK: Collection View Interaction Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let typeCell = cell as? StartScreenCollectionViewCell else {
            return cell
        }
        typeCell.text.text = words[indexPath.item]
        
        return typeCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.item < 6) {
            let alert = UIAlertController(title: "Can't Remove", message: "You Must Have This Word", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
        } else {
            words.remove(at: indexPath.item)
            collectionView.reloadData()
        }
    }
    
    
}


import SwiftUI


@available(iOS 13.0.0, *)
struct StartScreenControllerPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIViewController
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<StartScreenControllerPreview.ContainerView>) -> StartScreenControllerPreview.ContainerView.UIViewControllerType {
            return StartScreenViewController()
        }
        
        func updateUIViewController(_ uiViewController: StartScreenControllerPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<StartScreenControllerPreview.ContainerView>) {
            
        }
    }
}
