//
//  LeaderboardViewController.swift
//  The Chase App
//
//  Created by Hunt, Rachel on 08/11/2024.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var previousVC: String?
    var latestScore: Int?
    var scoreArray: [Int] = []
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var toStartBtn: UIButton!
    @IBOutlet weak var toEndBtn: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath)
        
        var content = UIListContentConfiguration.cell()
        
        content.text = String(indexPath.row + 1) + ": £" + String(scoreArray[indexPath.row]) //displays place in leaderboard as well as score for that place
        
        aCell.contentConfiguration = content
        
        return aCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scoreArray = userDefaults.array(forKey: "scoreArray") as? [Int] ?? [] //gets the score array from user defaults
        
        if previousVC == "startVC" {
            toEndBtn.isHidden = true //prevents user from unwinding to end from start
        }
        
        else if previousVC == "endVC"{
            toStartBtn.isHidden = true //prevents user from unwinding to start from end
            
            if latestScore != 0 { //only adds score to leaderboard if higher than 0
                scoreArray.append(latestScore!)
            }
        }

        scoreArray.sort(by: >)
        userDefaults.set(scoreArray, forKey: "scoreArray") //sets the score array for user defaults
    }
}
