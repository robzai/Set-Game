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
    @IBOutlet weak var moreCardsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        for index in 0..<cardButtons.count {
            if index < setGame.playingCards.count {
                cardButtons[index].setAttributedTitle(contentOfCard(setGame.playingCards[index]), for: .normal)
                cardButtons[index].backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                //handle selection
                if let _ = setGame.selectedCards.index(forKey: index) {
                    cardButtons[index].layer.borderWidth = 3.0
                } else {
                    cardButtons[index].layer.borderWidth = 0.0
                }
            } else {
                cardButtons[index].setTitle(nil, for: UIControl.State.normal)
                cardButtons[index].setAttributedTitle(nil, for: UIControl.State.normal)
                cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
            cardButtons[index].layer.cornerRadius = 8.0
            cardButtons[index].layer.borderColor = UIColor.blue.cgColor
        }
        //handle moreCardButton
        if setGame.playingCards.count < 24 && setGame.deck.count > 0{
            moreCardsButton.isEnabled = true
            moreCardsButton.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        } else {
            moreCardsButton.isEnabled = false
            moreCardsButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender){
            setGame.chooseCard(at: cardNumber)
        }
        updateView()
        print("\(setGame.selectedCards.count)")
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
    
    //assemption: shadingOne=▲, shadingTwo=●, shadingThree=■
    func stringOf(_ card: Card) -> String {
        switch card.shape {
        case .shapeOne:
            return "▲"
        case .shapeTow:
            return "●"
        case .shapeThree:
            return "■"
        }
    }
    
    //eg. red, green, or purple
    func colorOf(_ card: Card) -> UIColor {
        switch card.color {
        case .colorOne:
            return UIColor.red
        case .colorTwo:
            return UIColor.green
        case .colorThree:
            return UIColor.purple
        }
    }
    
    func contentOfCard(_ card: Card) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth : strokeWidthOf(card),
            //The opacity value of the color object, specified as a value from 0.0 to 1.0.
            .foregroundColor : colorOf(card).withAlphaComponent(alphaOf(card)),
            .strokeColor : colorOf(card)
        ]
        return NSAttributedString(string: stringOf(card), attributes: attributes)
    }
    
    @IBAction func touchMoreCards(_ sender: UIButton) {
        setGame.pickCards(numberOfCards: 3)
        //check if 3 selected cards are match, if 3 cards are selected
        updateView()
    }
}
