//
//  PlayingCardsView.swift
//  SetGame
//
//  Created by leo  luo on 2019-10-14.
//  Copyright © 2019 tk.onebite. All rights reserved.
//

import UIKit

class PlayingCardsView: UIView {
    
    var playingCards: [Card] = [] {
        didSet{ setNeedsDisplay(); setNeedsLayout() }
    }
    
    var grid: Grid = Grid(layout: Grid.Layout.aspectRatio(0.75))
    
    private let shpeToStringDictionary: Dictionary<Card.Shape, String> = [
        .shapeOne: "diamond",
        .shapeTwo: "squiggle",
        .shapeThree: "oval"
    ]
    
    private let numberOfShapesToNumberOfRowColumnDictionary: Dictionary<Int, (row: Int, col: Int)> = [
        1: (3,1),
        2: (5,1),
        3: (3,1)
    ]
    
    private let colorToUIColorDictionary: Dictionary<Card.Color, UIColor> = [
        .colorOne: UIColor.red,
        .colorTwo: UIColor.green,
        .colorThree: UIColor.purple
    ]
    
    private lazy var drawShapeFunctions: Dictionary<String, (CGRect, UIColor, Card.Shading) -> () > = [
        "oval": drawSingleOval,
        "diamond": drawSingleDiamond,
        "squiggle": drawSingleSquiggle
    ]
    
    private func drawCardBackground(in rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 16.0)
        UIColor.white.setFill()
        roundedRect.fill()
    }
    
    private func drawStripe(in rect: CGRect, withColor: UIColor) {
        let path = UIBezierPath()
        path.lineWidth = 1.0
        withColor.setStroke()
        for i in stride(from: Int(rect.minX), to: Int(rect.maxX), by: 3){
            path.move(to: CGPoint(x: i, y: 0))
            path.addLine(to: CGPoint(x: CGFloat(i), y: rect.maxY))
        }
        path.stroke()
    }
    
    private func drawSingleOval(in rect: CGRect, withColor: UIColor, withShading: Card.Shading) {
        if let context = UIGraphicsGetCurrentContext(){
            let oval = UIBezierPath(roundedRect: rect, cornerRadius: 50)
            //addClip means I don't want to draw outside the roundedrect
            withColor.setStroke()
            oval.stroke()
            if withShading == Card.Shading.shadingOne {
                withColor.setFill()
                oval.fill()
            } else if withShading == Card.Shading.shadingTwo {
                context.saveGState()
                oval.addClip()
                drawStripe(in: rect, withColor: withColor)
                context.restoreGState()
            }
        }
    }
    
    private func drawSingleDiamond(in rect: CGRect, withColor: UIColor, withShading: Card.Shading) {
        if let context = UIGraphicsGetCurrentContext(){
            context.saveGState()
            let diamond = UIBezierPath()
            diamond.move(to: CGPoint(x: rect.midX, y:rect.minY))
            diamond.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            diamond.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            diamond.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            diamond.close()
            withColor.setStroke()
            diamond.stroke()
            if withShading == Card.Shading.shadingOne {
                withColor.setFill()
                diamond.fill()
            } else if withShading == Card.Shading.shadingTwo {
                context.saveGState()
                diamond.addClip()
                drawStripe(in: rect, withColor: withColor)
                context.restoreGState()
            }
        }
    }
    
    private func drawSingleSquiggle(in rect: CGRect, withColor: UIColor, withShading: Card.Shading) {
        if let context = UIGraphicsGetCurrentContext(){
            let squiggle = UIBezierPath()
            squiggle.move(to: CGPoint(x: rect.minX+(rect.width/6), y: rect.maxY))
            squiggle.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
            
            squiggle.addQuadCurve(to: CGPoint(x: rect.minX+(rect.width/6), y: rect.minY), controlPoint: CGPoint(x: rect.minX, y: rect.minY))
            
            squiggle.addCurve(to: CGPoint(x: rect.minX+(rect.width/6)*5, y: rect.minY), controlPoint1: CGPoint(x: rect.minX+(rect.width/6)*2, y: rect.minY), controlPoint2: CGPoint(x: rect.minX+(rect.width/6)*4, y: rect.midY))
            
            squiggle.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY), controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
            
            squiggle.addQuadCurve(to: CGPoint(x: rect.minX+(rect.width/6)*5, y: rect.maxY), controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
            
            squiggle.addCurve(to: CGPoint(x: rect.minX+(rect.width/6), y: rect.maxY), controlPoint1: CGPoint(x: rect.minX+(rect.width/6)*4, y: rect.maxY), controlPoint2: CGPoint(x: rect.minX+(rect.width/6)*2, y: rect.midY))
            
            withColor.setStroke()
            squiggle.stroke()
            if withShading == Card.Shading.shadingOne {
                withColor.setFill()
                squiggle.fill()
            } else if withShading == Card.Shading.shadingTwo {
                context.saveGState()
                squiggle.addClip()
                drawStripe(in: rect, withColor: withColor)
                context.restoreGState()
            }
        }
    }
    
    private func drawShapes(in rect: CGRect, _ shape: String, numberOfShapes: Int, color: UIColor, shading: Card.Shading){
        if let row=numberOfShapesToNumberOfRowColumnDictionary[numberOfShapes]?.row, let col=numberOfShapesToNumberOfRowColumnDictionary[numberOfShapes]?.col {
            let grid = Grid(layout: Grid.Layout.dimensions(rowCount: row, columnCount: col), frame: rect)

            switch numberOfShapes {
            case 1:
                if let rectInGrid = grid[1,0]?.inset() {
                    if let drawSingleShapeFunc = drawShapeFunctions[shape]{
                        drawSingleShapeFunc(rectInGrid, color, shading)
                    }
                }
            case 2:
                if let rectInGrid = grid[1,0]?.insetForTwoRows(),
                    let anotherRectInGrid = grid[3,0]?.insetForTwoRows() {
                    if let drawSingleShapeFunc = drawShapeFunctions[shape]{
                        drawSingleShapeFunc(rectInGrid, color, shading)
                        drawSingleShapeFunc(anotherRectInGrid, color, shading)
                    }
                }
            case 3:
                if let rectUpper = grid[0,0]?.inset(),
                    let rectMiddle = grid[1,0]?.inset(),
                    let rectBottom = grid[2,0]?.inset() {
                    if let drawSingleShapeFunc = drawShapeFunctions[shape]{
                        drawSingleShapeFunc(rectUpper, color, shading)
                        drawSingleShapeFunc(rectMiddle, color, shading)
                        drawSingleShapeFunc(rectBottom, color, shading)
                    }
                }
            default:
                break
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        grid = Grid(layout: Grid.Layout.aspectRatio(0.75), frame: bounds)
        grid.cellCount = playingCards.count
        
        for i in 0..<playingCards.count {
            if let rect = grid[i]?.inset() {
                drawCardBackground(in: rect)
                drawShapes(in: rect, shpeToStringDictionary[playingCards[i].shape] ?? "", numberOfShapes: playingCards[i].numberOfShapes, color: colorToUIColorDictionary[playingCards[i].color] ?? UIColor.white, shading: playingCards[i].shading)
            }
        }
    }
}

extension CGRect {
    private struct Inset {
        static let insetXForThreeRow: CGFloat = 5.0
        static let insetYForThreeRow: CGFloat = 5.0
        static let insetXForTwoRow: CGFloat = 5.0
        static let insetYForTwoRow: CGFloat = -5.0
    }
    
    func inset() -> CGRect{
        return self.insetBy(dx: Inset.insetXForThreeRow, dy: Inset.insetYForThreeRow)
    }
    
    func insetForTwoRows() -> CGRect {
        return self.insetBy(dx: Inset.insetXForTwoRow, dy: Inset.insetYForTwoRow)
    }
}
