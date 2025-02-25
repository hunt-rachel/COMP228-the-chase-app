//
//  StartViewController.swift
//  The Chase App
//
//  Created by Hunt, Rachel on 08/11/2024.
//

import UIKit

class StartViewController: UIViewController {

    @IBAction func startBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "toGame", sender: nil)
    }
    @IBAction func viewLeaderboardBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "startToLeaderboard", sender: nil)
    }
    
    @IBAction func unwindToStart(_ unwindSegue: UIStoryboardSegue) { //for unwiding from leaderboard
        let _ = unwindSegue.source
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startToLeaderboard" {
            let leaderboardVC = segue.destination as! LeaderboardViewController
            
            leaderboardVC.previousVC = "startVC" //lets leaderboard know which view controller we came from to make correct unwind button active
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
