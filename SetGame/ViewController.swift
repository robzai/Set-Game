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
    
    @IBOutlet weak var moreCardsButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playingCardView: PlayingCardsView! {
        didSet {
            let tap = UITapGestureRecognizer(target: <#T##Any?#>, action: <#T##Selector?#>)
            //get the tap location, then use CGRect.contains(CGPoint) to check which rect is selected
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView() {
        playingCardView.playingCards = setGame.playingCards as! [Card]
        //handle moreCardButton
        if setGame.playingCards.count < 24 && setGame.deck.count > 0 && !setGame.endOfGame{
            moreCardsButton.isEnabled = true
            moreCardsButton.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        } else {
            moreCardsButton.isEnabled = false
            moreCardsButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
        
        scoreLabel.text = "Score:\(setGame.score)"
        
//        foundAllSetLable.isHidden = !setGame.endOfGame
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
//        if let cardNumber = cardButtons.firstIndex(of: sender){
//            setGame.chooseCard(at: cardNumber)
//        }
//        updateView()
//        print("\(setGame.selectedCards.count)")
    }
    
    
//    //assemption: shadingOne=solid, shadingTwo=striped, shadingThree=open.
//    //In an NSAttributedString to be filled in, specify an NSAttributedStringKey.strokeWidth to a negative number
//    func strokeWidthOf(_ card: Card) -> NSNumber {
//        switch card.shading {
//        case .shadingThree:
//            return 5.0
//        default:
//            return -5.0
//        }
//    }
//    
//    //assemption: shadingOne=solid, shadingTwo=striped, shadingThree=open.
//    func alphaOf(_ card: Card) -> CGFloat {
//        switch card.shading {
//        case .shadingTwo:
//            return 0.5
//        default:
//            return 1
//        }
//    }
//    
//    //assemption: shadingOne=▲, shadingTwo=●, shadingThree=■
//    func shapeOf(_ card: Card) -> String {
//        switch card.shape {
//        case .shapeOne:
//            return "▲"
//        case .shapeTow:
//            return "●"
//        case .shapeThree:
//            return "■"
//        }
//    }
//    
//    //eg. red, green, or purple
//    func colorOf(_ card: Card) -> UIColor {
//        switch card.color {
//        case .colorOne:
//            return UIColor.red
//        case .colorTwo:
//            return UIColor.green
//        case .colorThree:
//            return UIColor.purple
//        }
//    }
//    
//    func contentOfCard(_ card: Card) -> NSAttributedString {
//        let attributes: [NSAttributedString.Key: Any] = [
//            .strokeWidth : strokeWidthOf(card),
//            //The opacity value of the color object, specified as a value from 0.0 to 1.0.
//            .foregroundColor : colorOf(card).withAlphaComponent(alphaOf(card)),
//            .strokeColor : colorOf(card)
//        ]
//        return NSAttributedString(string: "\(shapeOf(card)) \(card.numberOfShapes)", attributes: attributes)
//    }
    
    @IBAction func touchMoreCards(_ sender: UIButton) {
        setGame.pickCards(numberOfCards: 3)
        updateView()
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        setGame = SetGame()
        updateView()
    }
    
}

extension UIButton {
    func hidden() {
        self.setTitle(nil, for: UIControl.State.normal)
        self.setAttributedTitle(nil, for: UIControl.State.normal)
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        self.isEnabled = false
    }
}
