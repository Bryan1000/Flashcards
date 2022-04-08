//
//  ViewController.swift
//  Flashcards
//
//  Created by El Padrino on 2/26/22.
//

import UIKit


struct Flashcard{
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    //Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    //Current flashcard index
    var currentIndex = 0
    
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //REad saved flashcards
        readSavedFlashcards()
        
        //Adding our initial flashcard if needed
        if flashcards.count == 0 {
        updateFlashcard(question: "What is the capital of Russia?", answer: "Moscow")
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
        
        frontLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        backLabel.layer.cornerRadius = 20.0
        backLabel.clipsToBounds = true
        
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        
        btnOptionThree.layer.cornerRadius = 20.0
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        // Do any additional setup after loading the view
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
       flipFlashcard()
    }
    
    func flipFlashcard(){
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight) {
            if self.frontLabel.isHidden == true
            {
                self.frontLabel.isHidden = false
            }
            else
            {
                self.frontLabel.isHidden = true
            }
        }
    }
    
    func updateFlashcard(question:String, answer:String){
        let flashcard = Flashcard(question: question, answer: answer)
        //frontLabel.text = flashcard.question
        //backLabel.text = flashcard.answer
        
        //Adding flashcard in the flashcards array
        flashcards.append(flashcard)
        
        //Logging to the console
        print("😎 Added new flashcard")
        print("😎 We now have \(flashcards.count) flashcards")
        
        //Update current index
        currentIndex = flashcards.count - 1
        print("😎 Our current index is \(currentIndex)")
        
        //Update buttons
        updateNextPrevButtons()
        
        //Update labels
        updateLabels()
        
        saveAllFlashcardsToDisk()
    }
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        btnOptionOne.isHidden = true
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        btnOptionThree.isHidden = true
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //Increase current index
        currentIndex = currentIndex + 1
        
        //Update buttons
        updateNextPrevButtons()
        
        animateCardOut()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        updateNextPrevButtons()
       
        UIView .animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        }, completion: { finished in
            //Update labels
            self.updateLabels()
            
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
            UIView.animate(withDuration: 0.3) {
                self.card.transform = CGAffineTransform.identity
            }
        })
    }
    
    
    func updateNextPrevButtons(){
        
        //Disable next button if at the end
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        //Disable prev button if at the beginning
        if currentIndex == 0{
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels() {
        //Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func saveAllFlashcardsToDisk(){
        
        //Log it
        print("🎉 Flashcards saved to User Defaults")
        //From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
    }
    
    
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
        }
            flashcards.append(contentsOf: savedCards)
    }
    }
    
    func animateCardOut(){
        UIView .animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            //Update labels
            self.updateLabels()
            
            //Run other animation
            self.animateCardIn()
        })
    }
    
    func animateCardIn(){
        //Start on the right side (don't animat this)
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        //Animate card going back to its original position
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    //Override func prepare(for segue: UI )
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as? CreationViewController
        
        creationController?.flashcardsController = self
    }
}

