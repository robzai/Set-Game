//
//  SetGame.swift
//  SetGame
//
//  Created by leo  luo on 2019-08-23.
//  Copyright © 2019 tk.onebite. All rights reserved.
//

import Foundation

struct SetGame {
    var deck = [Card]()
    var selectedCards = [Card]()
    var playingCards = [Card]()
    
//    func isASet() -> Bool{
//
//    }
//
    
    mutating func pickCards(numberOfCards: Int) {
        for _ in 1...numberOfCards {
            if deck.count > 0{
                playingCards.append(deck.popLast()!)
            }
        }
    }
    
//
//    func chooseCard() {
//
//    }
    
    init() {
        //generate 81 unique cards in deck
        for numberOfShapes in 1...3 {
            for shape in Card.Shape.all {
                for shade in Card.Shading.all {
                    for color in Card.Color.all {
                        let card = Card(numberOfShapes: numberOfShapes, shape: shape, shading: shade, color: color)
                        deck.append(card)
                    }
                }
            }
        }
        //shuffle cards within deck
        deck.shuffle()
        //pick the first 12 cards to show on view
        pickCards(numberOfCards: 12)
    }
}


