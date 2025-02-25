//
//  ViewController.swift
//  The Chase App
//
//  Created by Hunt, Rachel on 24/10/2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: Variables
    var offerBeenSelected = false
    var ladderBeenSetUp = false
    var playerPickedAnswer: Bool?
    var playerWon: Bool?
    
    var highOffer: Float = 0.0
    var roundedHighOffer: Float = 0.0
    
    var midOffer: Float = 0.0
    var roundedMidOffer: Float = 0.0
    
    var lowOffer: Float = 0.0
    var roundedLowOffer: Float = 0.0

    var selectedCell: Int?
    var selectedOffer: String?
    
    var cellTextArray: [String?] = [] //array of text for each section in chase ladder table
    
    var countdownTimer: Timer?
    var countdownSeconds: Int?
    
    var chosenAnswer: Int?
    var correctAnswer: Int?
    
    var playerPointer: Int?
    var chaserPointer: Int? = 0 //chaser will always begin at index 0 / top of the chase ladder

    @IBOutlet weak var chaseLadder: UITableView!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var questionText: UILabel!
    
    //prevents users from interacting with table once offer is selected
    @IBOutlet weak var ladderShield: UIView!
    
    @IBAction func answerOneBtn(_ sender: Any) {
        chaserPicksAnswer()
        
        countdownSeconds = 3 //sets timer for time until answers highlighted, same for all 3 buttons
        disableAnswerInteraction()
        answerChoiceTokens[0].isHidden = false //displays player token, same for all 3 buttons
        
        chosenAnswer = 1
        playerPickedAnswer = true
    }
    
    @IBAction func answerTwoBtn(_ sender: Any) {
        chaserPicksAnswer()
        
        countdownSeconds = 3
        disableAnswerInteraction()
        answerChoiceTokens[1].isHidden = false
        
        chosenAnswer = 2
        playerPickedAnswer = true
    }
    
    @IBAction func answerThreeBtn(_ sender: Any) {
        chaserPicksAnswer()
        
        countdownSeconds = 3
        disableAnswerInteraction()
        answerChoiceTokens[2].isHidden = false
        
        chosenAnswer = 3
        playerPickedAnswer = true
    }
    
    @IBOutlet var answerBtns: [UIButton]! //array of answer buttons above
    
    @IBOutlet var answerChoiceTokens: [UIButton]! //array of icons to represent which answer the player and the chaser chose
    
    //MARK: Table Initialisation
    func numberOfSections(in tableView: UITableView) -> Int { //fixed number of sections in original ladder from TV show
        return 7
    }
    
    //allows cell corners to be rounded by defining individual sections of table instead of just rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        var content = UIListContentConfiguration.cell()
        
    //MARK: Offer Generation
        if offerBeenSelected == false {
            content.textProperties.color = UIColor.black
            
            switch indexPath.section {
            case 1: //high offer generation
                unselectedOfferCellColour(to: aCell)

                //high offer ranges from £10,000 to £50,000
                highOffer = Float.random(in: 10_000...50_000)
                print("high offer: " + String(highOffer))
                
                //the randomly generated number rounds to the nearest thousand.
                roundedHighOffer = (highOffer / 1000).rounded() * 1000
                print("rounded high offer: " + String(roundedHighOffer) + "\n")
                
                cellTextArray.append(String(Int(roundedHighOffer)))
                
                content.text = "£" + String(cellTextArray[1]!)
                
            case 2: //middle offer generation
                unselectedOfferCellColour(to: aCell)
                
                //middle offer ranges from £2000 to £8000
                midOffer = Float.random(in: 2000...8000)
                print("middle offer: " + String(midOffer))
                
                //the randomly generated number rounds to the nearest five hundred.
                roundedMidOffer = (midOffer / 500).rounded() * 500
                print("rounded middle offer: " + String(roundedMidOffer) + "\n")
                
                cellTextArray.append(String(Int(roundedMidOffer)))
                
                content.text = "£" + String(cellTextArray[2]!)
                
            case 3: //low offer generation
                unselectedOfferCellColour(to: aCell)
                
                //low offer ranges from £100 to £1000
                lowOffer = Float.random(in: 100...1000)
                print("low offer: " + String(lowOffer))
                
                //the randomly generated number rounds to the nearest hundred.
                roundedLowOffer = (lowOffer / 100).rounded() * 100
                print("rounded low offer: " + String(roundedLowOffer) + "\n")
                
                cellTextArray.append(String(Int(roundedLowOffer)))
                
                content.text = "£" + String(cellTextArray[3]!)
                
            default: //for non-offer cells in ladder
                defaultCellColour(to: aCell)
                
                content.text = nil
                cellTextArray.append(content.text)
            }
        }
        
    //MARK: Ladder Initialisation
        else {
            content.textProperties.color = UIColor.white
            
            if ladderBeenSetUp == false {
                switch indexPath.section {
                case 0:
                    chaserCellColour(to: aCell)
                    content.text = "The Chaser"

                case 1:
                    if indexPath.section == selectedCell { //high offer selected
                        playerCellColour(to: aCell)
                        content.text = "£" + (selectedOffer ?? "Offer")
                    }
                    
                    else {
                        defaultCellColour(to: aCell)
                        content.text = nil
                    }
                    
                case 2:
                    if indexPath.section < selectedCell! { //low offer selected
                        defaultCellColour(to: aCell)
                    }
                    
                    else {
                        playerCellColour(to: aCell) //either middle or high offer selected, both result in same colour
                    }
                    
                    if indexPath.section == selectedCell { //only adds offer text to selected cell
                        content.text = "£" + (selectedOffer ?? "Offer")
                    }
                    
                    else {
                        content.text = nil
                    }
                    
                case 3:
                    playerCellColour(to: aCell) //this cell will always be player colour regardless of offer choice
                    
                    if indexPath.section == selectedCell {
                        content.text = "£" + (selectedOffer ?? "Offer")
                    }
                    
                    else {
                        content.text = nil
                    }
                default:
                    playerCellColour(to: aCell) //each cell below chosen offer becomes player colour
                    content.text = nil

                }
                
                cellTextArray.append(content.text)
            }
            
            else {
                switch indexPath.section {
                case 0 ... chaserPointer!: //makes all cells above chaser position the chaser colour too
                    chaserCellColour(to: aCell)
                    
                    if indexPath.section == chaserPointer { //only adds chaser text to current chaser position
                        content.text = "The Chaser"
                        
                        if chaserPointer == playerPointer { //chaser has occupied same space on ladder as player
                            print("\ngame over!")
                            playerWon = false
                            endGame()
                        }
                    }
                    
                case playerPointer! ... 6: //makes all cells from player position to bottom player colour
                    playerCellColour(to: aCell)
                    
                    if indexPath.section == playerPointer {
                        content.text = "£" + (selectedOffer ?? "Offer") //only adds player text to player position
                    }
                
                default:
                    defaultCellColour(to: aCell) //any cells between player position and chaser position become default colour
                }
            }
        }
        
        aCell.contentConfiguration = content
        return aCell
    }
    
    //MARK: Cell Colour Functions
    //changes cell background colour to default colour from the TV chase ladder
    func defaultCellColour(to cell: UITableViewCell) {
        cell.backgroundColor = UIColor.init(red: 7/255.0, green: 120/255.0, blue: 160/255.0, alpha: 1)
    }
    
    //changes to unselected offer colour from the TV chase ladder
    func unselectedOfferCellColour(to cell: UITableViewCell) {
        cell.backgroundColor = UIColor.init(red: 1/255.0, green: 176/255.0, blue: 193/255.0, alpha: 1)
    }
    
    //changes to player colour from the TV chase ladder
    func playerCellColour(to cell: UITableViewCell) {
        cell.backgroundColor = UIColor.init(red: 6/255.0, green: 15/255.0, blue: 92/255.0, alpha: 1)
    }
    
    //changes to chaser colour from the TV chase ladder
    func chaserCellColour(to cell: UITableViewCell) {
        cell.backgroundColor = UIColor.init(red: 156/255.0, green: 31/255.0, blue: 29/255.0, alpha: 1)
    }
    
    //MARK: Offer Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        offerBeenSelected = true
        
        selectedCell = indexPath.section
        print("selected cell: " + String(selectedCell!))
        
        playerPointer = selectedCell //sets player's starting position
        
        selectedOffer = cellTextArray[indexPath.section] //selected offer becomes player's score from here on out
        print("selected offer: " + selectedOffer! + "\n")
        
        //allows ladder to be refreshed, showing only the chosen offer instead of all offers
        cellTextArray.removeAll()
        chaseLadder.reloadData()
        
        ladderShield.isHidden = false //prevents users from reselecting cells on the ladder
        
        generateQuestion()
    }
    
    //MARK: Defining and Reading-in the Quiz Question Data
    struct QuizQuestionData: Codable {
        let category : String
        var questions: [QuestionItems]
    }

    struct QuestionItems: Codable {
        let question_text : String
        let answers : [String]
        let correct : Int
    }

    func getJSONQuestionData() -> QuizQuestionData? {
        let bundleFolderURL = Bundle.main.url(forResource: "chase_questions_v2", withExtension: "json")!
        do {
            let retrievedData = try Data(contentsOf: bundleFolderURL)
            do {
                let theQuizData = try JSONDecoder().decode(QuizQuestionData.self, from: retrievedData)
                return theQuizData
            } catch {
                print("couldn't decode file contents"); return nil
            }
        } catch {
            print("couldn't retrieve file contents"); return nil
        }
    }
    
    //MARK: Generate Q&A
    func generateQuestion() {
        resetAnswerColours()
        playerPickedAnswer = false
        
        for token in 0 ..< answerChoiceTokens.count { //hides answer tokens from previous question if still shown
            if answerChoiceTokens[token].isHidden == false {
                answerChoiceTokens[token].isHidden = true
            }
        }
        
        let questionData = getJSONQuestionData()
        
        if questionData != nil {
            let currentQuestionData = questionData?.questions.randomElement()
            
            questionText.numberOfLines = 0 //prevents text trailing off screen
            questionText.text = currentQuestionData?.question_text

            for btn in 0 ..< answerBtns.count { //sets up answers for current question
                answerBtns[btn].isHidden = false
                answerBtns[btn].setTitle(currentQuestionData!.answers[btn], for: UIControl.State.normal)
                answerBtns[btn].setTitleColor(.black, for: .normal)
            }
            
            correctAnswer = currentQuestionData?.correct
            print("the correct answer is: " + String(correctAnswer!)) //for marking assistance
        }
        
        enableAnswerInteraction()
        startCountdown()
    }
    
    //MARK: Countdown Functions
    func startCountdown() {
        timerText.isHidden = false
        countdownSeconds = 15
        if countdownTimer == nil {
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdownStarted), userInfo: nil, repeats: true)
        }
    }
    
    @objc func countdownStarted() {
        if countdownSeconds! > 0 { //only shows timer to player when above 0
            timerText.text = String(countdownSeconds!)
        }
        countdownSeconds! -= 1 //decrease timer by 1 each second
        
        if countdownSeconds == 0 {
            if playerPickedAnswer == false {
                chaserPicksAnswer()
            }
            
            else {
                print("\nchecking answers")
                checkAnswers(to: chosenAnswer!)
            }
            
            highlightAnswers()
        }
        
        else if countdownSeconds == -1 { //gives players chance to register table change before displaying new question
            moveOnLadder()
        }
        
        else if countdownSeconds == -2 && playerPointer! < 7 && chaserPointer! < playerPointer! { //continues game only while the player is ahead of the chaser
            stopCountdown()
            print("\ncountdown stopped: generating new question")
            countdownSeconds = 15
            timerText.text = "15" //fixes bug where timer didn't show 15 to begin with

            generateQuestion()
        }
    }
    
    func stopCountdown() {
        if countdownTimer != nil {
            countdownTimer?.invalidate()
            countdownTimer = nil
        }
    }
    
    //MARK: Check Answers
    func checkAnswers(to answerNumber: Int) { //checks if user's answer was correct
        if answerNumber != correctAnswer {
            print("player is incorrect")
        }
        
        else {
            print("player is correct")
            playerPointer! += 1
            print("player pointer is now at index " + String(playerPointer!)) //to checkplayer movement works as should
        }
    }
    
    func chaserPicksAnswer() {
        timerText.isHidden = true
        let chaserCorrectChance = Int.random(in: 1...4)
        
        if chaserCorrectChance == 4 { // 1 in 4 chance chaser is incorrect
            print("chaser is incorrect")
            var answerSelection = [1,2,3]
            
            answerSelection.remove(at: correctAnswer! - 1) //index of correct answer will be one less than correct answer's value
            
            let chaserIncorrectAnswer = answerSelection.randomElement()
            
            //selects chaser token to be displayed based on answer
            //e.g. chaser tokens are [3 - 5] in the token array
            //so, if the answer chosen is 1, the 1st chaser token is at index[3]
            answerChoiceTokens[(chaserIncorrectAnswer! + 2)].isHidden = false
        }
        
        else {
            print("chaser is correct")
            answerChoiceTokens[(correctAnswer! + 2)].isHidden = false //same logic as incorrect chaser token
            chaserPointer! += 1
        }
    }
    
    //locks in user's answer, preventing them from choosing again
    func disableAnswerInteraction() {
        for answerBtn in 0 ..< answerBtns.count {
            answerBtns[answerBtn].isUserInteractionEnabled = false
        }
    }
    
    //allows users to select answer buttons again once a question is generated
    func enableAnswerInteraction() {
        for answerBtn in 0 ..< answerBtns.count {
            answerBtns[answerBtn].isUserInteractionEnabled = true
        }
    }
    
    //MARK: Highlight Answers
    func highlightAnswers() {
        for btn in 0 ..< answerBtns.count {
            if btn == correctAnswer! - 1{
                answerBtns[btn].backgroundColor = UIColor.systemGreen //correct answers show green
            }
            
            else {
                answerBtns[btn].backgroundColor = UIColor.systemRed //incorrect answers show red
            }
        }
    }
    
    //clears answer colours for new question
    func resetAnswerColours() {
        for btn in 0 ..< answerBtns.count {
            answerBtns[btn].backgroundColor = UIColor.clear
        }
    }
    
    //MARK: Ladder Movement
    func moveOnLadder() {
        ladderBeenSetUp = true //prevents ladder reinitialising like at beginning
        
        if playerPointer! < 7 {
            chaseLadder.reloadData()
        }
        
        else { //player has won / reached bottom of ladder if index == 7
            print("you win! your score is: " + String(selectedOffer!)) //testing score carries across properly for end screen
            playerWon = true
            endGame()
        }
    }
    
    //MARK: End Game Functions
    func endGame() { //transitions user to end screen
        performSegue(withIdentifier: "toEnd", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEnd" {
            let endVC = segue.destination as! EndViewController
            
            endVC.playerWon = playerWon
            
            if playerWon == true { //presents winning end screen
                endVC.endMessageText = "Congratulations!"
                endVC.winLoseText = "You won the chase."
                endVC.score = Int(selectedOffer!)
                
            }
            
            else if playerWon == false { //presents losing end screeen
                endVC.endMessageText = "Better luck next time!"
                endVC.winLoseText = "You lost the chase."
            }
        }
    }
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //hides question UI
        ladderShield.isHidden = true
        timerText.isHidden = true
        questionText.text = "Choose your offer: "
        
        for answerBtn in 0 ..< answerBtns.count {
            answerBtns[answerBtn].isHidden = true
        }
        
        for token in 0 ..< answerChoiceTokens.count {
            answerChoiceTokens[token].isHidden = true
        }
    }


}

