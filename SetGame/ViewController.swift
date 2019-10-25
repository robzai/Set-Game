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
    @IBOutlet weak var playingCardsView: PlayingCardsView! {
        didSet {
            //tap is going to affect the model so it has to be handle by the controller(self)
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard))
            playingCardsView.addGestureRecognizer(tap)
            
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
            swipeDown.direction = UISwipeGestureRecognizer.Direction(arrayLiteral: [.down])
            playingCardsView.addGestureRecognizer(swipeDown)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotationHandler))
            playingCardsView.addGestureRecognizer(rotate)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    @objc func tapCard(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let tapedLocation: CGPoint = sender.location(in: playingCardsView)
            for i in 0..<playingCardsView.grid.cellCount {
                if let cell = playingCardsView.grid[i], cell.contains(tapedLocation) {
                    setGame.chooseCard(setGame.playingCards[i])
                }
            }
        }
        updateView()
    }
    
    @objc func swipeHandler(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            touchMoreCards(sender)
        }
    }
    
    @objc func rotationHandler(sender: UIRotationGestureRecognizer) {
        if sender.state == .ended {
            setGame.reshuffle()
            updateView()
        }
    }
    
    func updateView() {
        playingCardsView.playingCards = setGame.playingCards
        playingCardsView.selectedCards = setGame.selectedCards
        
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
    
    @IBAction func touchMoreCards(_ sender: Any) {
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
