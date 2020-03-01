//
//  ViewController.swift
//  Flashcards
//
//  Created by 90306846 on 2/8/20.
//  Copyright © 2020 CodePath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var answerSide: UILabel!
    @IBOutlet weak var questionSide: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        answerSide.layer.cornerRadius = 25
        answerSide.clipsToBounds = true
        answerSide.layer.borderWidth = 8
        answerSide.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        answerSide.backgroundColor = #colorLiteral(red: 0.9340795013, green: 0.9340795013, blue: 0.9340795013, alpha: 1)
        
        questionSide.layer.cornerRadius = 25
        questionSide.layer.borderWidth = 8
        questionSide.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        questionSide.backgroundColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
    }
    
    @IBAction func didTapFlashcard(_ sender: Any) {
        if (questionSide.isHidden == true){
            questionSide.isHidden = false
        }else{
            questionSide.isHidden = true
        }
    }
    func updateFlashcard(question: String, answer: String) {
        questionSide.text = question
        answerSide.text = answer
    }
}
    


