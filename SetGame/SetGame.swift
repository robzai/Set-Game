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
    var selectedCards = Dictionary<Int,Card>()
    var playingCards = [Card]()
    //When the deck of Set cards runs out, successfully matched cards can no longer be replaced with new cards. Those un-replaced matched cards can’t appear in the UI. For this reason, your Model’s API will have to reveal which cards have already been successfully matched.
    var matchedCards = [Card]()
    
    mutating func pickCards(numberOfCards: Int) {
        for _ in 1...numberOfCards {
            if deck.count > 0{
                playingCards.append(deck.popLast()!)
            }
        }
    }
    
    mutating func isSelectedCardsASet() -> Bool{
        if let cardOne = selectedCards.popFirst()?.value, let cardTwo = selectedCards.popFirst()?.value, let thirdCard = selectedCards.popFirst()?.value {
            return cardOne.
        }
        return false
    }

    mutating func chooseCard(at index: Int) {
        //if 0, 1, 2 cards are selected when user choose a card
        if(selectedCards.count < 3) {
            //if the card is already selected, deselect it, else select it
            if let card = selectedCards.removeValue(forKey: index){
                playingCards.insert(card, at: index)
            } else {
                let selectedCard = playingCards[index]
                selectedCards[index] = selectedCard
            }
        }
        //if 3 cards are selected when user choose a card, check if selectedCards are match. Then empty the selectedCards and put the new selected card in it.
        
        
    }
    
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


