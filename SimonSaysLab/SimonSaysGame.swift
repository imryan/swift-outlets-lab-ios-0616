//
//  SimonSaysGame.swift
//  SimonSaysLab
//
//  Created by James Campagno on 5/31/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import ChameleonFramework
import UIKit

enum Color: Int {
    case Red, Green, Yellow, Blue
}

// MARK: - UIColor Display

extension Color {
    var colorToDisplay: UIColor {
        switch self {
        case .Red:
            return UIColor.flatRedColor()
        case .Green:
            return UIColor.flatGreenColor()
        case .Yellow:
            return UIColor.flatYellowColor()
        case .Blue:
            return UIColor.flatSkyBlueColor()
        }
    }
}

// MARK: - CustomStringConvertible Protocol

extension Color: CustomStringConvertible {
    var description: String {
        switch self {
        case .Red:
            return "Red"
        case .Green:
            return "Green"
        case .Yellow:
            return "Yellow"
        case .Blue:
            return "Blue"
        }
    }
}

struct SimonSays {
    
    var chosenColors = [Color]()
    var patternToMatch = [Color]()
    var colorToDisplay = 0
    let numberOfColorsToMatch: Int
    
    init(numberOfColorsToMatch: Int = 5) {
        self.numberOfColorsToMatch = numberOfColorsToMatch
        
        for _ in (0..<numberOfColorsToMatch) {
            let randomNumber = Int(arc4random_uniform(4))
            let randomColor = Color(rawValue: randomNumber)!
            patternToMatch.append(randomColor)
        }
    }
}


// MARK: - Gameplay methods

extension SimonSays {

    mutating func nextColor() -> Color? {
        var color: Color? = nil
        if colorToDisplay < patternToMatch.count {
            color = patternToMatch[colorToDisplay]
        }
        colorToDisplay += 1
        return color
    }

    func sequenceFinished() -> Bool {
        return colorToDisplay > patternToMatch.count
    }

    func wonGame() -> Bool {
        return chosenColors == patternToMatch
    }
    
    private mutating func makeGuessWith(color: Color) -> Bool {
        guard chosenColors.count < patternToMatch.count else { return false }
        chosenColors.append(color)
        return patternToMatch[chosenColors.count - 1] == color
    }

    mutating func guessRed() {
        makeGuessWith(.Red)
    }
    
    mutating func guessGreen() {
        makeGuessWith(.Green)
    }
    
    mutating func guessYellow() {
        makeGuessWith(.Yellow)
    }
    
    mutating func guessBlue() {
        makeGuessWith(.Blue)
    }
    
    mutating func tryAgainWithTheSamePattern() {
        chosenColors.removeLast()
        // display the colors in order again to the user (up to the turn)
    }
}
