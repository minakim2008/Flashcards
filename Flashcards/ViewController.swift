//
//  ViewController.swift
//  Flashcards
//
//  Created by 90306846 on 2/8/20.
//  Copyright © 2020 CodePath. All rights reserved.
//

import UIKit

//Struct (similar to a class)
struct Flashcard {
    var question: String
    var answer: String
}
    
class ViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var answerSide: UILabel!
    @IBOutlet weak var questionSide: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //Array to hold flashcards
    var flashcards = [Flashcard]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readSavedFlashcards()
        
        card.layer.cornerRadius = 25
        card.layer.borderWidth = 8
        card.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) //Color literal
        card.backgroundColor = UIColor.white
        
        //Adds shadows
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        
        
        answerSide.clipsToBounds = true
        questionSide.clipsToBounds = true
        answerSide.backgroundColor = #colorLiteral(red: 0.9340795013, green: 0.9340795013, blue: 0.9340795013, alpha: 1)
        questionSide.backgroundColor = UIColor.white
        
        if (flashcards.count == 0){
            updateFlashcard(question: "Question", answer: "Answer")
        }else{
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        card.alpha = 0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1
            self.card.transform = CGAffineTransform.identity
        })
    }
    
    //Helps move between screens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex -= 1
        //Shows current flashcards
        updateNextPrevButtons()
        prevMoveCardOut()
        
        //Always starts with question side when moving between flashcards
        questionSide.isHidden = false
        answerSide.isHidden = true
        card.backgroundColor = UIColor.white
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex += 1
        //Shows current flashcards
        updateNextPrevButtons()
        nextMoveCardOut()
        
        //Always starts with question side when moving between flashcards
        questionSide.isHidden = false
        answerSide.isHighlighted = true
        card.backgroundColor = UIColor.white
    }
    
    @IBAction func didTapFlashcard(_ sender: Any) {
        flipFlashcards()
    }
    
    func flipFlashcards(){
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if (self.questionSide.isHidden == true){
                self.questionSide.isHidden = false
                self.answerSide.isHidden = true
                self.card.backgroundColor = UIColor.white
            }else{
                self.questionSide.isHidden = true
                self.answerSide.isHidden = false
                self.card.backgroundColor = #colorLiteral(red: 0.9340795013, green: 0.9340795013, blue: 0.9340795013, alpha: 1)
            }
        })
    }
    
    func nextMoveCardOut(){
        UIView.animate(withDuration: 0.2, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300, y: 0)
        }, completion: { finished in
            //Labels only get updated once card has moved out of screen
            self.updateLabels()
            self.nextMoveCardIn()
            })
    }
    //Called by nextMoveCardOut()
    func nextMoveCardIn(){
        //Places card on right side of screen
        card.transform = CGAffineTransform.identity.translatedBy(x: 300, y: 0)
        
        //Moves card to original location
        UIView.animate(withDuration: 0.2) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func prevMoveCardOut(){
        UIView.animate(withDuration: 0.2, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300, y: 0)
        }, completion: { finished in
            //Labels only get updated once card has moved out of screen
            self.updateLabels()
            self.prevMoveCardIn()
            })
    }
    //Called by nextMoveCardOut()
    func prevMoveCardIn(){
        //Places card on right side of screen
        card.transform = CGAffineTransform.identity.translatedBy(x: -300, y: 0)
        
        //Moves card to original location
        UIView.animate(withDuration: 0.2) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete this card?", message: "Are you sure you want to delete this flashcard?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func deleteCurrentFlashcard(){
        let alert = UIAlertController(title: "Error", message: "You only have one flashcard", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        //Doesn't allow user to delete first card
        if flashcards.count == 1{
            present(alert, animated: true)
        }else{
            flashcards.remove(at: currentIndex)
            if currentIndex > flashcards.count - 1{
                currentIndex = flashcards.count - 1
            }
            updateNextPrevButtons()
            updateLabels()
            saveFlashcardsToDisk()
        }
    }
    
    func updateNextPrevButtons() {
        if (currentIndex == flashcards.count - 1) {
            nextButton.isEnabled = false
        }else{
            nextButton.isEnabled = true
        }
        if (currentIndex == 0) {
            prevButton.isEnabled = false
        }else{
            prevButton.isEnabled = true
        }
    }
    
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)
        //Adds flashcard to array
        flashcards.append(flashcard)
        
        //Shows code
        print("Added new flashcard")
        print("Flashcards: ", (flashcards.count))
        
        currentIndex = flashcards.count - 1
        print("Current index: ", currentIndex)
        
        updateNextPrevButtons()
        updateLabels()
    }
    
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        
        questionSide.text = currentFlashcard.question
        answerSide.text = currentFlashcard.answer
    }
    
    func saveFlashcardsToDisk(){
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        //Only knows how to store dictionaries
        //Converts array -> dictionary
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        print("Flashcard saved to disk (UserDefaults)")
    }
    
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            //Converts saved dictionary -> array
            let savedCards = dictionaryArray.map { (dictionary) -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }
    
}
    


