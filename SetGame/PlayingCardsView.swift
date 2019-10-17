//
//  PlayingCardsView.swift
//  SetGame
//
//  Created by leo  luo on 2019-10-14.
//  Copyright © 2019 tk.onebite. All rights reserved.
//

import UIKit

class PlayingCardsView: UIView {
    
    let numberOfShapesToNumberOfRowColumnDictionary: Dictionary<Int, (row: Int, col: Int)> = [
        1: (3,1),
        2: (5,1),
        3: (3,1)
    ]
    
    lazy var drawShapeFunctions: Dictionary<String, (CGRect, UIColor, Int) -> () > = [
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
    
    private func drawSingleOval(in rect: CGRect, withColor: UIColor, withShaiding: Int) {
        if let context = UIGraphicsGetCurrentContext(){
            context.saveGState()
            let oval = UIBezierPath(roundedRect: rect, cornerRadius: 50)
            //addClip means I don't want to draw outside the roundedrect
            withColor.setStroke()
            oval.stroke()
            oval.addClip()
            drawStripe(in: rect, withColor: withColor)
            context.restoreGState()
        }
    }
    
    private func drawSingleDiamond(in rect: CGRect, withColor: UIColor, withShaiding: Int) {
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
            diamond.addClip()
            drawStripe(in: rect, withColor: withColor)
            context.restoreGState()
        }
    }
    
    private func drawSingleSquiggle(in rect: CGRect, withColor: UIColor, withShaiding: Int) {
        if let context = UIGraphicsGetCurrentContext(){
            context.saveGState()
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
            squiggle.addClip()
            drawStripe(in: rect, withColor: withColor)
            context.restoreGState()
        }
    }
    
    private func drawShapes(in rect: CGRect, _ shape: String, numberOfShapes: Int, color: UIColor, shaiding: Int){
        if let row=numberOfShapesToNumberOfRowColumnDictionary[numberOfShapes]?.row, let col=numberOfShapesToNumberOfRowColumnDictionary[numberOfShapes]?.col {
            let grid = Grid(layout: Grid.Layout.dimensions(rowCount: row, columnCount: col), frame: rect)

            switch numberOfShapes {
            case 1:
                if let rectInGrid = grid[1,0]?.inset() {
                    if let drawSingleShapeFunc = drawShapeFunctions[shape]{
                        drawSingleShapeFunc(rectInGrid, color, 1)
                    }
                }
            case 2:
                if let rectInGrid = grid[1,0]?.insetForTwoRows(),
                    let anotherRectInGrid = grid[3,0]?.insetForTwoRows() {
                    if let drawSingleShapeFunc = drawShapeFunctions[shape]{
                        drawSingleShapeFunc(rectInGrid, color, 1)
                        drawSingleShapeFunc(anotherRectInGrid, color, 0)
                    }
                }
            case 3:
                if let rectUpper = grid[0,0]?.inset(),
                    let rectMiddle = grid[1,0]?.inset(),
                    let rectBottom = grid[2,0]?.inset() {
                    if let drawSingleShapeFunc = drawShapeFunctions[shape]{
                        drawSingleShapeFunc(rectUpper, color, 0)
                        drawSingleShapeFunc(rectMiddle, color, 0)
                        drawSingleShapeFunc(rectBottom, color, 0)
                    }
                }
            default:
                break
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        var grid = Grid(layout: Grid.Layout.aspectRatio(0.75), frame: bounds)
        grid.cellCount = 12
        
        for i in 1...3 {
            if let rect = grid[0,i-1]?.inset() {
                drawCardBackground(in: rect)
                drawShapes(in: rect, "oval", numberOfShapes: i, color: UIColor.red, shaiding: 0)
            }
        }

        for i in 1...3 {
            if let rect = grid[1,i-1]?.inset() {
                drawCardBackground(in: rect)
                drawShapes(in: rect, "diamond", numberOfShapes: i, color: UIColor.blue, shaiding: 0)
            }
        }
        
        for i in 1...3 {
            if let rect = grid[2,i-1]?.inset() {
                drawCardBackground(in: rect)
                drawShapes(in: rect, "squiggle", numberOfShapes: i, color: UIColor.orange, shaiding: 0)
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
