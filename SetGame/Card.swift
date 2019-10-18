//
//  Card.swift
//  SetGame
//
//  Created by leo  luo on 2019-08-23.
//  Copyright © 2019 tk.onebite. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var numberOfShapes: Int
    
    //eg. diamond, squiggle, stadium
    private(set) var shape: Shape
    
    //eg. solid, striped, or open
    private(set) var shading: Shading
    
    //eg. red, green, or purple
    private(set) var color: Color
    
    init(numberOfShapes: Int, shape: Shape, shading: Shading, color: Color) {
        self.numberOfShapes = numberOfShapes
        self.shape = shape
        self.shading = shading
        self.color = color
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(numberOfShapes)
        hasher.combine(shape)
        hasher.combine(shading)
        hasher.combine(color)
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.numberOfShapes == rhs.numberOfShapes && lhs.shape == rhs.shape && lhs.shading == rhs.shading && lhs.color == rhs.color
    }
    
}

extension Card{
    enum Shape {
        //eg. diamond, squiggle, oval
        case shapeOne
        case shapeTwo
        case shapeThree
        
        static var all = [Shape.shapeOne, .shapeTwo, .shapeThree]
    }
    
    enum Shading {
        //eg. solid, striped, or open
        case shadingOne
        case shadingTwo
        case shadingThree
        
        static var all = [Shading.shadingOne, .shadingTwo, .shadingThree]
    }
    
    enum Color {
        //eg. red, green, or purple
        case colorOne
        case colorTwo
        case colorThree
        
        static var all = [Color.colorOne, .colorTwo, .colorThree]
    }
}
