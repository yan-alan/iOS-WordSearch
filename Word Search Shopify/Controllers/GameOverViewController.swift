//
//  GameOverViewController.swift
//  Word Search Shopify
//
//  Created by Alan Yan on 2020-01-14.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import UIKit


/// View controller to show the Game Finished screen
class GameOverViewController: UIViewController {
    //Passed in by the GameViewController
    /// score given by the previous view controller
    var givenScore: Int!
    /// name given by the previous view controller
    var givenName: String!
    
    /// table view for the high scores
    private var tableView: UITableView!
    /// local array that loads all scores from user defaults
    private var scores: [Score] = []
    /// text field to handle name input
    private var newWordField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newView = GameOverView()
        newView.restartButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        
        tableView = newView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GameOverTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        self.view = newView
        

        // display an alert
        let newWordPrompt = UIAlertController(title: "Enter Your Name", message: "Score: \(givenScore!)", preferredStyle: .alert)
        newWordPrompt.addTextField(configurationHandler: addTextField)
        newWordPrompt.addAction(UIAlertAction(title: "OK", style: .default, handler: wordEntered))
        present(newWordPrompt, animated: true, completion: nil)
    }
    /**
       Adds word to the user defaults array

       - Parameters:
           - alert: UIAlertAction to handle pressing okay
    
       - Returns: Void
    */
    func wordEntered(alert: UIAlertAction!){
        if let retrievedDict = UserDefaults.standard.dictionary(forKey: "savedScores") {
            retrievedDict.forEach { (arg: (key: String, value: Any)) in
                let (key, value) = arg
                guard let score = value as? Int else {
                    return
                }
                scores.append(Score(key, score))
            }
        }
        scores.append(Score(newWordField.text!, givenScore))
        
        scores.sort(by: {$0.score > $1.score})
        var dic:[String: Int] = [:]
        scores.forEach({dic[$0.name] = $0.score})
        UserDefaults.standard.set(dic, forKey: "savedScores")
        tableView.reloadData()
    }
    /**
       Adds word to the user defaults array

       - Parameters:
           - alert: UIAlertAction to handle pressing okay
    
       - Returns: Void
    */
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Definition"
        textField.autocapitalizationType = .words
        self.newWordField = textField
    }
    /**
       Pops to the root navigation view controller

       - Parameters: None
    
       - Returns: Void
    */
    @objc private func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension GameOverViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        scores.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GameOverTableViewCell
        
        cell.nameLabel.text = scores[indexPath.row].name
        cell.scoreLabel.text = "\(scores[indexPath.row].score)"
        
        return cell
    }
    
    
}
