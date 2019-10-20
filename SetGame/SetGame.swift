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
    //When the deck of Set cards runs out, successfully matched cards can no longer be replaced with new cards. Those un-replaced matched cards can’t appear in the UI. For this reason, your Model’s API will have to reveal which cards have already been successfully matched.
    var matchedCards = [Card]()
    
    private(set) var score = 0
    private(set) var endOfGame = false
    
    private mutating func calculateScore(isSet: Bool) {
        if isSet {
            score += 6
        } else {
            score -= 3
        }
    }
    
    mutating func pickCards(numberOfCards: Int) {
        //check if 3 selected cards are match, if 3 cards are selected
        if(selectedCards.count == 3) {
            let isSet = isSelectedCardsASet()
            calculateScore(isSet: isSet)
            if isSet {
                endOfGame = checkEndOfGame()
            }
        }
        
        for _ in 1...numberOfCards {
            if deck.count > 0{
                playingCards.append(deck.popLast()!)
            }
        }
    }
    
    mutating func handleMatchedCards(_ cardOne: Card, _ cardTwo: Card, _ cardThree: Card){
        matchedCards.append(cardOne)
        matchedCards.append(cardTwo)
        matchedCards.append(cardThree)
        
        if let index = playingCards.firstIndex(of: cardOne) {
            playingCards.remove(at: index)
        }
        if let index = playingCards.firstIndex(of: cardTwo) {
            playingCards.remove(at: index)
        }
        if let index = playingCards.firstIndex(of: cardThree) {
            playingCards.remove(at: index)
        }
        
        pickCards(numberOfCards: 3)
    }
    
    private mutating func isSelectedCardsASet() -> Bool{
        let cardOne = selectedCards.removeFirst()
        let cardTwo = selectedCards.removeFirst()
        let cardThree = selectedCards.removeFirst()
        
        let checkShape: Bool = !(cardOne.shape == cardTwo.shape || cardTwo.shape == cardThree.shape || cardThree.shape == cardOne.shape)
        
        let checkNumberOfShape: Bool = !(cardOne.numberOfShapes == cardTwo.numberOfShapes || cardTwo.numberOfShapes == cardThree.numberOfShapes || cardThree.numberOfShapes == cardOne.numberOfShapes)
        
        let checkShading: Bool = !(cardOne.shading == cardTwo.shading || cardTwo.shading == cardThree.shading || cardThree.shading == cardOne.shading)
        
        let checkColor: Bool = !(cardOne.color == cardTwo.color || cardTwo.color == cardThree.color || cardThree.color == cardOne.color)
        
        if (checkShape && checkNumberOfShape && checkShading && checkColor) {
            print("found a set")
            handleMatchedCards(cardOne, cardTwo, cardThree)
            return true
        } else {
            return false
        }
    }
    
    mutating func chooseCard(_ card: Card) {
        //if 0, 1, 2 cards are selected when user choose a card
        if(selectedCards.count < 3) {
            //if the card is already selected, deselect it, else select it
            if let index = selectedCards.firstIndex(of: card){
                selectedCards.remove(at: index)
            } else {
                selectedCards.append(card)
            }
        } else {
            //if 3 cards are selected when user choose a new card, check if selectedCards are match and empty the selectedCards(check and empty are done in the function isSelectedCardsASet). Then put the new selected card in it.
            let isSet = isSelectedCardsASet()
            calculateScore(isSet: isSet)
            if isSet {
                endOfGame = checkEndOfGame()
            }
            
            selectedCards.append(card)
        }
        print("# of selected cards: \(selectedCards.count)")
    }
    
    mutating func checkEndOfGame() -> Bool {
        print("matchedCards: \(matchedCards.count)")
        return matchedCards.count == 81 - 3
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
