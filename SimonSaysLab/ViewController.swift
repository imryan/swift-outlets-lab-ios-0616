//
//  ViewController.swift
//  SimonSaysLab
//
//  Created by James Campagno on 5/31/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet weak var displayColorView: UIView!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var winLabel: UILabel!
    
    var guesses: Int = 0
    
    var simonSaysGame = SimonSays()
    var buttonsClicked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winLabel.hidden = true
        hideOrDisableColorViews(true, disable: false)
    }
}

// MARK: - SimonSays Game Methods

extension ViewController {
    
    @IBAction func startGameTapped(sender: UIButton) {
        UIView.transitionWithView(startGameButton, duration: 0.8, options: .TransitionFlipFromBottom , animations: {
            self.startGameButton.hidden = true
            self.winLabel.hidden = true
            }, completion: nil)
        
        newGame()
    }
    
    @IBAction func tapColorView(sender: UIButton) {
        guesses += 1
        
        switch (sender.tag) {
            case 0:
                simonSaysGame.guessRed()
            case 1:
                simonSaysGame.guessGreen()
            case 2:
                simonSaysGame.guessYellow()
            case 3:
                simonSaysGame.guessBlue()
            default:
                break
        }
        
        decideWin()
    }
    
    private func newGame() {
        hideOrDisableColorViews(true, disable: false)
        
        simonSaysGame = SimonSays()
        displayTheColors()
        guesses = 0
    }
    
    private func decideWin() {
        if (guesses == 5) {
            winLabel.hidden = false
            winLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 30)
            
            startGameButton.hidden = false
            startGameButton.center = self.view.center
            
            if (simonSaysGame.wonGame()) {
                winLabel.text = "You win!"
            } else {
                winLabel.text = "You lost!"
            }
            
            hideOrDisableColorViews(false, disable: true)
        }
    }
    
    private func hideOrDisableColorViews(hide: Bool, disable: Bool) {
        for view: UIView in colorButtons {
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 3
            view.hidden = hide
            view.userInteractionEnabled = !disable
            
            if (disable) {
                UIView.animateWithDuration(0.3, animations: {
                    view.alpha = 0.5
                })
            } else {
                view.alpha = 1
            }
        }
    }
    
    private func displayTheColors() {
        self.view.userInteractionEnabled = false
        self.displayColorView.layer.masksToBounds = true
        self.displayColorView.layer.cornerRadius = 3
        
        UIView.transitionWithView(displayColorView, duration: 1.5, options: .TransitionCurlUp, animations: {
            self.displayColorView.backgroundColor = self.simonSaysGame.nextColor()?.colorToDisplay
            self.displayColorView.alpha = 0.0
            self.displayColorView.alpha = 1.0
            
            }, completion: { _ in
                if !self.simonSaysGame.sequenceFinished() {
                    self.displayTheColors()
                } else {
                    self.view.userInteractionEnabled = true
                    self.hideOrDisableColorViews(false, disable: false)
                    print("Pattern to match: \(self.simonSaysGame.patternToMatch)")
                }
        })
    }
}
