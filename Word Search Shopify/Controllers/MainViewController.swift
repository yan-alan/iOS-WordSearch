//
//  MainController.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-09.
//  Copyright © 2020 Alan Yan. All rights reserved.
//
import UIKit
import AlanYanHelpers

/**
    Direction of a finger drag

    - diagonal: For a diagonal pan gesture
    - horizontal:  For a horizontal pan gesture
    - vertical: For a vertical pan gesture
*/
enum Direction: CaseIterable {
    case diagonal
    case horizontal
    case vertical
}

/// View Controller that consists of the game screen when playing
class GameViewController: UIViewController {
    /// Words sent by the start screen
    var words: [String] = []
    /// All 100 buttons on the board
    private var buttonList: [BoardPiece]!
    /// The vStack defined in the WordView, containts the other 10 hStacks
    private var stackView: UIStackView!
    /// The score label at the bottom of the screen
    private var scoreLabel: UILabel!
    /// The timer label at the bottom of the screen
    private var timerLabel: UILabel!
    /// The timer label at the bottom of the screen
    private var builtWord: [Character] = []
    /// The current selected pieces in the current pan gesture
    private var currentSelectedPieces: [BoardPiece] = []
    /// An array of line objects representing the current lines on the screren
    private var displayedLines: [Line] = []
    /// The current score
    private var score = 0
    /// The current pan gesture direction
    private var currentDirection: Direction?
    /// The diagonal direction, either top left to bottom right or bottom left to top right
    private var diagonalDifference = 0
    /// The seconds remaining in the game
    private var secondsRemaining = 90
    /// The background colour loweing on the screen as time goes on
    private var timeLayer = UIView()
    /// A timer that fires every second
    private var everySecondTimer: Timer!
    /// A boolean that represents whether the game has starting or not after the animation
    private var start = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttonAnimation(index: 0)
    }
    /**
        Animates in the 10x10 board of BoardPieces

        - Parameters:
            - index: the BoardPiece index to start with
     
        - Returns: Void
    */
    private func buttonAnimation(index: Int) {
        if(index == 100) {
            start = true
            return
        }
        buttonList[index].alpha = 1
        buttonList[index].transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        UIView.animate(withDuration: 0.1) {
            self.buttonList[index].transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03, execute: {
            self.buttonAnimation(index: index+1)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let newView = GameView()
        newView.wordsModel = words
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        newView.addGestureRecognizer(gesture)
        newView.isUserInteractionEnabled = true
        scoreLabel = newView.scoreLabel
        buttonList = newView.buttonList
        stackView = newView.hStack
        timeLayer = newView.timeLayer
        timerLabel = newView.timer
        self.view = newView
        
        everySecondTimer = Timer.scheduledTimer(timeInterval: TimeInterval(exactly: 1.0)!, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        buttonList.forEach({$0.alpha = 0})
    }
    /**
        Decreases seconds by one and lowers the timer score and view

        - Parameters: None
     
        - Returns: Void
    */
    @objc private func updateTimer() {
        guard start == true else {
            return
        }
        guard secondsRemaining != 0 else {
            everySecondTimer.invalidate()
            let newVC = GameOverViewController()
            newVC.givenScore = score
            newVC.givenName = UIDevice.current.name
            navigationController?.pushViewController(newVC, animated: true)
            return
        }
        secondsRemaining -= 1
        timeLayer.userDefinedConstraintDict["height"]?.constant = (UIScreen.main.bounds.height/90) * CGFloat(secondsRemaining)
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
        let minutes = secondsRemaining/60
        let hours = secondsRemaining/3600
        let seconds = secondsRemaining % 60
        if(seconds < 10) {
            timerLabel.text = "\(hours)\(minutes):0\(seconds)"
        } else {
            timerLabel.text = "\(hours)\(minutes):\(seconds)"
        }
    }
    /**
        Figures out which board piece is being dragged over and infers the direction

        - Parameters:
            - sender: The pan gesture that recognized this pan gesture
     
        - Returns: Void
    */
    @objc private func didPan(sender: UIPanGestureRecognizer) {
        let panLocation = sender.location(in: stackView)
        let height = stackView.bounds.maxY/10
        let width = stackView.bounds.maxX/10
        if(panLocation.y < stackView.bounds.minY || panLocation.y > stackView.bounds.maxY ||
            panLocation.x < stackView.bounds.minX || panLocation.x > stackView.bounds.maxX) {
            checkIfGestureEnded(gesture: sender)
            return
        }
        let row = Int((panLocation.y/height).rounded(.down))
        let column = Int((panLocation.x/width).rounded(.down))
        let pieceIndex = (row*10+column)
        guard (pieceIndex < 100 && pieceIndex >= 0) else {
            return
        }
        let piece = buttonList[pieceIndex]
        
        guard currentSelectedPieces.contains(piece) == false else {
            checkIfGestureEnded(gesture: sender)
            return
        }

        if(currentSelectedPieces.count < 2) {
            appendToCurrent(piece: piece)
        }
        else if(currentSelectedPieces.count == 2 && currentDirection == nil) {
            switch abs(currentSelectedPieces[1].index - currentSelectedPieces[0].index) {
            case 1:
                if(abs(piece.index - currentSelectedPieces[1].index) == 10) {
                    print("Diagonal")
                    currentDirection = .diagonal
                    currentSelectedPieces[1].colourView.backgroundColor = UIColor(hex: 0xF8F2E1)
                    currentSelectedPieces.remove(at: 1)
                    builtWord.remove(at: 1)
                    diagonalDifference = piece.index - currentSelectedPieces[0].index
                } else {
                    print("Horizontal")
                    currentDirection = .horizontal
                }
            case 10:
                if(abs(piece.index - currentSelectedPieces[1].index) == 1) {
                    print("Diagonal")
                    currentDirection = .diagonal
                    currentSelectedPieces[1].colourView.backgroundColor = UIColor(hex: 0xF8F2E1)
                    currentSelectedPieces.remove(at: 1)
                    builtWord.remove(at: 1)
                    diagonalDifference = piece.index - currentSelectedPieces[0].index
                } else {
                    print("Vertical")
                    currentDirection = .vertical
                }
            default:
                currentDirection = .diagonal
            }
        } else {
            switch currentDirection {
            case .horizontal:
                if(abs(piece.index - currentSelectedPieces[currentSelectedPieces.count-1].index) == 1) {
                    appendToCurrent(piece: piece)
                }
            case .vertical:
                if(abs(piece.index - currentSelectedPieces[currentSelectedPieces.count-1].index) == 10) {
                    appendToCurrent(piece: piece)
                }
            case .diagonal:
                if(piece.index - currentSelectedPieces[currentSelectedPieces.count-1].index == diagonalDifference) {
                    appendToCurrent(piece: piece)
                }
            default:
                fatalError()
            }
        }
        checkIfGestureEnded(gesture: sender)
    }
    /**
        Helper function to see if the pan gesture has ended and adds line/score if valid word

        - Parameters:
            - gesture: The pan gesture that recognized this pan gesture
     
        - Returns: Void
    */
    private func checkIfGestureEnded(gesture: UIPanGestureRecognizer) {
        if gesture.state == .ended {
            let finalString = String(builtWord)
            print(words)
            if (words.contains(finalString) || (builtWord.count >= 3 && isRealWord(word: finalString.lowercased()) == true)) {
                if (displayedLines.filter({$0.startIndex == currentSelectedPieces.first!.index && $0.endIndex == currentSelectedPieces.last!.index}).isEmpty) {
                    print(displayedLines)
                    words.removeAll(where: {$0 == finalString})
                    score += 1
                    scoreLabel.text = "Score: \(score)"
                    createLine()
                }
            }
            currentSelectedPieces.forEach({$0.colourView.backgroundColor = UIColor(hex: 0xF8F2E1)})
            currentDirection = nil
            currentSelectedPieces = []
            builtWord = []
        }
    }
    /**
        Appends a new element to currentSelectPieces along with generatoring haptic feedback

        - Parameters:
            - piece: the piece to be added to currentSelectPieces
     
        - Returns: Void
    */
    private func appendToCurrent(piece: BoardPiece) {
        buttonList[piece.index].colourView.backgroundColor = .gray
        builtWord.append(Character(piece.text.text!))
        currentSelectedPieces.append(piece)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    /**
        Adds a line to the view controllers view at the top layer with a line in a proper direction

        - Parameters: None
     
        - Returns: Void
    */
    private func createLine() {
        guard let first = currentSelectedPieces.first, let last = currentSelectedPieces.last else {
            return
        }
        displayedLines.append(Line(first.index, last.index))
        switch currentDirection {
        case .diagonal:
            let diagonal = DiagonalLineView()
                .setSuperview(stackView!)
                .addTop(anchor: (first.index/10 < last.index/10) ? first.centerYAnchor: last.centerYAnchor)
                .addLeading(anchor: (first.index % 10 < last.index % 10) ? first.centerXAnchor: last.centerXAnchor)
                .addTrailing(anchor: (first.index % 10 < last.index % 10) ? last.centerXAnchor: first.centerXAnchor)
                .addBottom(anchor: (first.index/10 < last.index/10) ? last.centerYAnchor: first.centerYAnchor)
            if (abs(currentSelectedPieces[1].index - currentSelectedPieces[0].index) == 11) {
                diagonal.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        case .horizontal:
            HorizontalLineView()
                .setSuperview(stackView!)
                .addTop(anchor: first.centerYAnchor, constant: -2)
                .addLeading(anchor: (first.index % 10 < last.index % 10) ? first.centerXAnchor: last.centerXAnchor)
                .addTrailing(anchor: (first.index % 10 < last.index % 10) ? last.centerXAnchor: first.centerXAnchor)
                .addBottom(anchor: first.centerYAnchor, constant: 2).done()
        case .vertical:
            VerticalLineView()
                .setSuperview(stackView!)
                .addTop(anchor: (first.index/10 < last.index/10) ? first.centerYAnchor: last.centerYAnchor)
                .addLeading(anchor: first.centerXAnchor, constant: -2)
                .addTrailing(anchor: first.centerXAnchor, constant: 2)
                .addBottom(anchor: (first.index/10 < last.index/10) ? last.centerYAnchor: first.centerYAnchor).done()
        case .none:
            fatalError()
        }
    }
    /**
        Checks if the word is valid against english US dictionary

        - Parameters:
            - word: String to be checked
     
        - Returns:
            - true if word is valid, false if word is invalid
    */
    private func isRealWord(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en_US")
        return misspelledRange.location == NSNotFound
    }
    
}


//MARK: SwiftUI Preview
import SwiftUI



@available(iOS 13.0, *)
struct ControllerPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIViewController
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ControllerPreview.ContainerView>) -> ControllerPreview.ContainerView.UIViewControllerType {
            return GameViewController()
        }
        
        func updateUIViewController(_ uiViewController: ControllerPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ControllerPreview.ContainerView>) {
            
        }
    }
}
