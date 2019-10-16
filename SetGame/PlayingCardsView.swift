//
//  PlayingCardsView.swift
//  SetGame
//
//  Created by leo  luo on 2019-10-14.
//  Copyright © 2019 tk.onebite. All rights reserved.
//

import UIKit

class PlayingCardsView: UIView {
    
    let numberOfShapesToNumberOfRowColumnDictionary: [Int: (row: Int, col: Int)] = [
        1: (3,1),
        2: (5,1),
        3: (3,1)
    ]
    let insetXForThreeRow: CGFloat = 5.0
    let insetYForThreeRow: CGFloat = 5.0
    let insetXForTwoRow: CGFloat = 5.0
    let insetYForTwoRow: CGFloat = -5.0
    
    private func drawCardBackground(in rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 16.0)
        UIColor.white.setFill()
        roundedRect.fill()
    }
    
    private func drawStripe(in rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = 1.0
        UIColor.red.setStroke()
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
            oval.addClip()
            withColor.setStroke()
            oval.stroke()
            drawStripe(in: rect)
            context.restoreGState()
        }
    }
    
    private func drawOval(in rect: CGRect, numberOfOvals: Int){
        if let row=numberOfShapesToNumberOfRowColumnDictionary[numberOfOvals]?.row, let col=numberOfShapesToNumberOfRowColumnDictionary[numberOfOvals]?.col {
            let grid = Grid(layout: Grid.Layout.dimensions(rowCount: row, columnCount: col), frame: rect)
            
            switch numberOfOvals {
            case 1:
                if let rectInGrid = grid[1,0]?.insetBy(dx: insetXForThreeRow, dy: insetYForThreeRow) {
                    drawSingleOval(in: rectInGrid, withColor: UIColor.red, withShaiding: 0)
                }
            case 2:
                if let rectInGrid = grid[1,0]?.insetBy(dx: insetXForTwoRow, dy: insetYForTwoRow),
                    let anotherRectInGrid = grid[3,0]?.insetBy(dx: insetXForTwoRow, dy: insetYForTwoRow) {
                    drawSingleOval(in: rectInGrid, withColor: UIColor.red, withShaiding: 0)
                    drawSingleOval(in: anotherRectInGrid, withColor: UIColor.red, withShaiding: 0)
                }
            case 3:
                if let rectUpper = grid[0,0]?.insetBy(dx: insetXForThreeRow, dy: insetYForThreeRow),
                    let rectMiddle = grid[1,0]?.insetBy(dx: insetXForThreeRow, dy: insetYForThreeRow),
                    let rectBottom = grid[2,0]?.insetBy(dx: insetXForThreeRow, dy: insetYForThreeRow) {
                    drawSingleOval(in: rectUpper, withColor: UIColor.red, withShaiding: 0)
                    drawSingleOval(in: rectMiddle, withColor: UIColor.red, withShaiding: 0)
                    drawSingleOval(in: rectBottom, withColor: UIColor.red, withShaiding: 0)
                }
            default:
            break
        }
        
        
    }
}

    private func drawSingleDiamond(in rect: CGRect, withColor: UIColor) {
        let diamond = UIBezierPath()
        diamond.move(to: CGPoint(x: rect.midX, y:rect.minY))
        diamond.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        diamond.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        diamond.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        diamond.close()
        withColor.setStroke()
        diamond.stroke()
    }
    
    private func drawDiamond(in rect: CGRect){

    }
    
    override func draw(_ rect: CGRect) {

            var grid = Grid(layout: Grid.Layout.aspectRatio(0.75), frame: bounds)
            grid.cellCount = 12
            
            for i in 1...3 {
                if let rect = grid[0,i-1] {
                    drawCardBackground(in: rect)
                    drawOval(in: rect, numberOfOvals: i)
                }
            }
    }
}
