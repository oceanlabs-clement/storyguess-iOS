//
//  ViewController.swift
//  storyguess
//
//  Created by Clement Gan on 26/12/2024.
//

import UIKit

class ViewController: UIViewController {

    // UI elements
    var storyLabel: UILabel!
    var guessButton: UIButton!
    var letterTextField: UITextField!
    var messageLabel: UILabel!
    var incorrectGuessesLabel: UILabel!
    var scoreLabel: UILabel!
    var timerLabel: UILabel!
    var quitButton: UIButton! // Quit button

    // Game variables
    let stories = [
        "The quick brown fox jumps over the lazy dog.",
        "A journey of a thousand miles begins with a single step.",
        "To be or not to be, that is the question.",
        "All that glitters is not gold.",
        "Better late than never.",
        "A picture is worth a thousand words.",
        "Actions speak louder than words.",
        "Rome wasn't built in a day.",
        "When in Rome, do as the Romans do.",
        "The pen is mightier than the sword.",
        "Jack of all trades, master of none.",
        "Curiosity killed the cat.",
        "Time flies when you're having fun.",
        "The early bird catches the worm.",
        "Don't judge a book by its cover.",
        "Laughter is the best medicine.",
        "Two heads are better than one.",
        "What goes around comes around.",
        "The grass is always greener on the other side.",
        "You can't have your cake and eat it too.",
        "The only thing we have to fear is fear itself.",
        "The truth will set you free, but first it will make you miserable.",
        "In the end, we will remember not the words of our enemies, but the silence of our friends.",
        "Do unto others as you would have them do unto you.",
        "I think, therefore I am.",
        "The greatest glory in living lies not in never falling, but in rising every time we fall.",
        "Life is what happens when you're busy making other plans.",
        "Get busy living or get busy dying.",
        "It does not matter how slowly you go as long as you do not stop.",
        "You only live once, but if you do it right, once is enough."
    ]
    
    var story: String = ""
    var displayedStory: [Character] = []
    var incorrectGuessesCount = 0
    var guessedLetters: Set<Character> = []
    var score = 0
    var timerValue = 50  // Increase time to 50 seconds
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true  // Hide back button on game screen
        
        // Setup the UI
        setupUI()
        startGame()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Add background image to ViewController
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "image_bg") // Replace with your background image name
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.2
        view.addSubview(backgroundImage)
        
        // Score label
        scoreLabel = UILabel()
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        scoreLabel.textAlignment = .left
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreLabel)
        
        // Timer label
        timerLabel = UILabel()
        timerLabel.font = UIFont.systemFont(ofSize: 20)
        timerLabel.textAlignment = .right
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerLabel)
        
        // Story label
        storyLabel = UILabel()
        storyLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        storyLabel.textAlignment = .center
        storyLabel.numberOfLines = 0
        storyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(storyLabel)
        
        // Incorrect guesses label
        incorrectGuessesLabel = UILabel()
        incorrectGuessesLabel.font = UIFont.systemFont(ofSize: 20)
        incorrectGuessesLabel.textAlignment = .center
        incorrectGuessesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(incorrectGuessesLabel)
        
        // Letter text field (for user input)
        letterTextField = UITextField()
        letterTextField.placeholder = "Enter a letter"
        letterTextField.font = UIFont.systemFont(ofSize: 20)
        letterTextField.borderStyle = .roundedRect
        letterTextField.translatesAutoresizingMaskIntoConstraints = false
        letterTextField.delegate = self
        view.addSubview(letterTextField)
        
        // Guess button
        guessButton = UIButton(type: .system)
        guessButton.setTitle("Guess", for: .normal)
        guessButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        guessButton.backgroundColor = UIColor.systemBlue
        guessButton.setTitleColor(.white, for: .normal)
        guessButton.layer.cornerRadius = 10
        guessButton.addTarget(self, action: #selector(guessLetter), for: .touchUpInside)
        guessButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(guessButton)
        
        // Quit button
        quitButton = UIButton(type: .system)
        quitButton.setTitle("Quit", for: .normal)
        quitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        quitButton.backgroundColor = UIColor.red
        quitButton.setTitleColor(.white, for: .normal)
        quitButton.layer.cornerRadius = 10
        quitButton.addTarget(self, action: #selector(quitGame), for: .touchUpInside)
        quitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(quitButton)
        
        // Message label
        messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        // Layout Constraints using Auto Layout
        NSLayoutConstraint.activate([
            // Score Label Constraints (top left corner)
            scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            scoreLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            // Timer Label Constraints (top right corner)
            timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            timerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            // Story Label Constraints
            storyLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            storyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            storyLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            // Incorrect Guesses Label Constraints
            incorrectGuessesLabel.topAnchor.constraint(equalTo: storyLabel.bottomAnchor, constant: 20),
            incorrectGuessesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            incorrectGuessesLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            // Letter TextField Constraints (center vertically)
            letterTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            letterTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            letterTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -120),
            
            // Guess Button Constraints (center vertically)
            guessButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            guessButton.leftAnchor.constraint(equalTo: letterTextField.rightAnchor, constant: 10),
            guessButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            // Quit Button Constraints (bottom center)
            quitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            quitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quitButton.widthAnchor.constraint(equalToConstant: 120),
            
            // Message Label Constraints
            messageLabel.topAnchor.constraint(equalTo: letterTextField.bottomAnchor, constant: 20),
            messageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            messageLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    func startGame() {
        // Select a random story
        story = stories.randomElement()!
        
        // Initialize the displayed story with underscores, keeping spaces and punctuation
        displayedStory = story.map { $0.isLetter ? "_" : $0 }
        storyLabel.text = String(displayedStory)
        incorrectGuessesCount = 0
        guessedLetters = []
        score = 0
        timerValue = 50  // Increase time to 50 seconds
        
        scoreLabel.text = "Score: \(score)"
        incorrectGuessesLabel.text = "Incorrect Guesses: \(incorrectGuessesCount)/3"
        messageLabel.text = ""
        timerLabel.text = "Time: \(timerValue)"
        
        // Start the timer
        if timer == nil {
            startTimer()
        }
        
        // Enable UI elements for the new game
        letterTextField.isEnabled = true
        guessButton.isEnabled = true
        quitButton.isEnabled = true
    }
    
    @objc func guessLetter() {
        // Get the input from the text field
        guard let input = letterTextField.text, input.count == 1, let guessedLetter = input.uppercased().first else {
            messageLabel.text = "Please enter a single letter."
            return
        }
        
        // Clear the text field
        letterTextField.text = ""
        
        // Case-insensitive checking for guessed letter
        let lowercasedStory = story.lowercased()
        let lowercasedGuessedLetter = guessedLetter.lowercased()
        
        if lowercasedStory.contains(lowercasedGuessedLetter) {
            updateDisplayedStory(with: guessedLetter)
            score += 10
            scoreLabel.text = "Score: \(score)"
        } else {
            incorrectGuessesCount += 1
            incorrectGuessesLabel.text = "Incorrect Guesses: \(incorrectGuessesCount)/3"
        }
        
        // Check for win condition (all letters guessed)
        if String(displayedStory).lowercased() == story.lowercased() {
//            messageLabel.text = "Congratulations! You've completed the story."
            showRestartOrExitPopUp()
        } else if incorrectGuessesCount >= 3 {
            messageLabel.text = "Too many incorrect guesses! Resetting..."
            startGame()
        }
    }
    
    func updateDisplayedStory(with guessedLetter: Character) {
        // Loop through the original story and update displayedStory where correct letter is found
        for (index, character) in story.enumerated() {
            if character.lowercased() == String(guessedLetter).lowercased() && displayedStory[index] == "_" {
                displayedStory[index] = guessedLetter
            }
        }
        
        // Update the story label
        storyLabel.text = String(displayedStory)
    }
    
    func showRestartOrExitPopUp() {
        // Show pop-up for restart or exit
        let alertController = UIAlertController(title: "Congratulations!", message: "Do you want to start a new game or exit?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "New Game", style: .default, handler: { _ in
            self.startGame()
        }))
        
        alertController.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { _ in
            self.quitGame()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func quitGame() {
        // Save the current score and time to UserDefaults
//        let scoreData = ["score": score, "time": timerValue] as [String : Any]
//        UserDefaults.standard.set(scoreData, forKey: "scoreHistory")
        
        saveGameData()
        
        // Stop the timer
        stopTimer()
        
        // Back to Menu
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func startTimer() {
        // Timer countdown
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timerValue -= 1
        timerLabel.text = "Time: \(timerValue)"
        
        if timerValue <= 0 {
            stopTimer()
            messageLabel.text = "Time's up! Game over."
            letterTextField.isEnabled = false
            guessButton.isEnabled = false
            
            // Show pop-up to ask for restart or exit
            quitGame()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // Save the game data
    func saveGameData() {
        // Save the score and time to UserDefaults
        let finalScore = score
        let finalTime = 40 - timerValue
        let history = UserDefaults.standard.array(forKey: "scoreHistory") as? [[String: Any]] ?? []
        let newHistory = ["score": finalScore, "time": finalTime] as [String: Any]
        let updatedHistory = history + [newHistory]
        UserDefaults.standard.set(updatedHistory, forKey: "scoreHistory")
    }
}

extension ViewController: UITextFieldDelegate {
    // Hide the keyboard when the return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}









