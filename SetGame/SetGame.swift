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
    
    mutating func handleMatchedCards(_ cardOne: (key: Int, value: Card), _ cardTwo: (key: Int, value: Card), _ cardThree: (key: Int, value: Card)){
        matchedCards.append(cardOne.value)
        matchedCards.append(cardTwo.value)
        matchedCards.append(cardThree.value)
        playingCards.remove(at: cardOne.key)
        if let newCard = deck.popLast() {
            playingCards.insert(newCard, at: cardOne.key)
        }
        playingCards.remove(at: cardTwo.key)
        if let newCard = deck.popLast() {
            playingCards.insert(newCard, at: cardTwo.key)
        }
        playingCards.remove(at: cardThree.key)
        if let newCard = deck.popLast() {
            playingCards.insert(newCard, at: cardThree.key)
        }
        
    }
    
    mutating func isSelectedCardsASet() -> Bool{
        if let cardOne = selectedCards.popFirst(), let cardTwo = selectedCards.popFirst(), let cardThree = selectedCards.popFirst() {
            let checkShape: Bool = !(cardOne.value.shape == cardTwo.value.shape || cardTwo.value.shape == cardThree.value.shape || cardThree.value.shape == cardOne.value.shape)
            
            let checkNumberOfShape: Bool = !(cardOne.value.numberOfShapes == cardTwo.value.numberOfShapes || cardTwo.value.numberOfShapes == cardThree.value.numberOfShapes || cardThree.value.numberOfShapes == cardOne.value.numberOfShapes)
            
            let checkShading: Bool = !(cardOne.value.shading == cardTwo.value.shading || cardTwo.value.shading == cardThree.value.shading || cardThree.value.shading == cardOne.value.shading)
            
            let checkColor: Bool = !(cardOne.value.color == cardTwo.value.color || cardTwo.value.color == cardThree.value.color || cardThree.value.color == cardOne.value.color)
            
            if (checkShape && checkNumberOfShape && checkShading && checkColor) {
                print("\(checkShape && checkNumberOfShape && checkShading && checkColor)")
                handleMatchedCards(cardOne, cardTwo, cardThree)
                return true
            } else {
                return false
            }
        }
        //should never goes here
        return false
    }

    mutating func chooseCard(at index: Int) {
        //if 0, 1, 2 cards are selected when user choose a card
        if(selectedCards.count < 3) {
            //if the card is already selected, deselect it, else select it
            if let _ = selectedCards.removeValue(forKey: index){

            } else {
                let selectedCard = playingCards[index]
                selectedCards[index] = selectedCard
            }
        } else {
            //if 3 cards are selected when user choose a card, check if selectedCards are match and empty the selectedCards. Then put the new selected card in it.
            isSelectedCardsASet()
            let selectedCard = playingCards[index]
            selectedCards[index] = selectedCard
            print("\(selectedCards.count)")
        }
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


