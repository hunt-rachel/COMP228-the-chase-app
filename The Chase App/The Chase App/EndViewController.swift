//
//  EndViewController.swift
//  The Chase App
//
//  Created by Hunt, Rachel on 08/11/2024.
//

import UIKit

class EndViewController: UIViewController {
    @IBOutlet weak var endMessageLabel: UILabel!
    @IBOutlet weak var winLoseLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var endMessageText = ""
    var winLoseText = ""
    var score: Int?
    var playerWon: Bool?
    
    @IBAction func viewLeaderboardBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "endToLeaderboard", sender: nil)
    }

    @IBAction func replayBtn(_ sender: Any) {
        performSegue(withIdentifier: "endToGame", sender: nil)
    }
    
    @IBAction func unwindToEnd(_ unwindSegue: UIStoryboardSegue) { //for unwinding from leaderboard
        let _ = unwindSegue.source
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endToLeaderboard" {
            let leaderboardVC = segue.destination as! LeaderboardViewController
            
            leaderboardVC.previousVC = "endVC" //lets leaderboard know which view controller we came from to make correct unwind button active
            
            leaderboardVC.latestScore = score //passes user's most recent score to leaderboard
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        endMessageLabel.text = endMessageText
        winLoseLabel.text = winLoseText
    
        if playerWon == true {
            scoreLabel.text = "Your score was: £" + String(score!)
        }
        
        else {
            scoreLabel.isHidden = true
            score = 0
        }
        
    }
}
