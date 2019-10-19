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
    //selcetedCards is a dictionary of <index/position, the card placed in this position>
    var selectedCards = Dictionary<Int,Card>()
    var playingCards = [Card?]()
    //When the deck of Set cards runs out, successfully matched cards can no longer be replaced with new cards. Those un-replaced matched cards can’t appear in the UI. For this reason, your Model’s API will have to reveal which cards have already been successfully matched.
    var matchedCards = [Card]()
    
    private(set) var score = 0
    private(set) var endOfGame = false
    
    mutating func calculateScore(isSet: Bool) {
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
    
    mutating func handleMatchedCards(_ cardOne: (key: Int, value: Card), _ cardTwo: (key: Int, value: Card), _ cardThree: (key: Int, value: Card)){
        matchedCards.append(cardOne.value)
        matchedCards.append(cardTwo.value)
        matchedCards.append(cardThree.value)
        
        if let newCard = deck.popLast() {
            playingCards[cardOne.key] = newCard
        } else {
            playingCards[cardOne.key] = nil
        }
        if let newCard = deck.popLast() {
            playingCards[cardTwo.key] = newCard
        } else {
            playingCards[cardTwo.key] = nil
        }
        if let newCard = deck.popLast() {
            playingCards[cardThree.key] = newCard
        } else {
            playingCards[cardThree.key] = nil
        }
    }
    
    mutating func isSelectedCardsASet() -> Bool{
        if let cardOne = selectedCards.popFirst(), let cardTwo = selectedCards.popFirst(), let cardThree = selectedCards.popFirst() {
            let checkShape: Bool = !(cardOne.value.shape == cardTwo.value.shape || cardTwo.value.shape == cardThree.value.shape || cardThree.value.shape == cardOne.value.shape)

            let checkNumberOfShape: Bool = !(cardOne.value.numberOfShapes == cardTwo.value.numberOfShapes || cardTwo.value.numberOfShapes == cardThree.value.numberOfShapes || cardThree.value.numberOfShapes == cardOne.value.numberOfShapes)

            let checkShading: Bool = !(cardOne.value.shading == cardTwo.value.shading || cardTwo.value.shading == cardThree.value.shading || cardThree.value.shading == cardOne.value.shading)

            let checkColor: Bool = !(cardOne.value.color == cardTwo.value.color || cardTwo.value.color == cardThree.value.color || cardThree.value.color == cardOne.value.color)

            if (checkShape && checkNumberOfShape && checkShading && checkColor) {
                print("found a set!!!")
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
                print("number of selected cards: \(selectedCards.count)")
            } else {
                let selectedCard = playingCards[index]
                selectedCards[index] = selectedCard
                print("number of selected cards: \(selectedCards.count)")
            }
        } else {
            //if 3 cards are selected when user choose a new card, check if selectedCards are match and empty the selectedCards. Then put the new selected card in it.
            let isSet = isSelectedCardsASet()
            calculateScore(isSet: isSet)
            if isSet {
                endOfGame = checkEndOfGame()
            }
            
            let selectedCard = playingCards[index]
            selectedCards[index] = selectedCard
            print("number of selected cards: \(selectedCards.count)")
        }
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


