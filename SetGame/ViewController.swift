//
//  ViewController.swift
//  SetGame
//
//  Created by leo  luo on 2019-08-22.
//  Copyright © 2019 tk.onebite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var setGame = SetGame()

    @IBOutlet var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in setGame.cardsShowingOnTable.indices {
            cardButtons[i].setAttributedTitle(contentOfCard(setGame.cardsShowingOnTable[i]), for: .normal)
        }
    }
    
    //assemption: shadingOne=solid, shadingTwo=striped, shadingThree=open.
    //In an NSAttributedString to be filled in, specify an NSAttributedStringKey.strokeWidth to a negative number
    func strokeWidthOf(_ card: Card) -> NSNumber {
        switch card.shading {
        case .shadingThree:
            return 5.0
        default:
            return -5.0
        }
    }
    
    //assemption: shadingOne=solid, shadingTwo=striped, shadingThree=open.
    func alphaOf(_ card: Card) -> CGFloat {
        switch card.shading {
        case .shadingTwo:
            return 0.5
        default:
            return 1
        }
    }
    
    //ssemption: shadingOne=▲, shadingTwo=●, shadingThree=■
    func stringOf(_ card: Card) -> String {
        switch card.shape {
        case .shapeOne:
            return "▲"
        case .shapeTow:
            return "▲"
        case .shapeThree:
            return "■"
        }
    }
    
    func contentOfCard(_ card: Card) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth : strokeWidthOf(card),
            //The opacity value of the color object, specified as a value from 0.0 to 1.0.
            .foregroundColor : UIColor.white.withAlphaComponent(alphaOf(card)),
            .strokeColor : UIColor.black
        ]
        return NSAttributedString(string: stringOf(card), attributes: attributes)
    }
    
}
