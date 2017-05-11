//
//  SNGraphFrame.swift
//  SNGraph
//
//  Created by ts3l20 on 2017/05/09.
//  Copyright © 2017年 sonauma. All rights reserved.
//

import Foundation
import UIKit

protocol GraphObject {
    var view: UIView { get }
    var lines: [GraphData] { get }
}

extension GraphObject {
    var view: UIView {
        return self as! UIView
    }
    
    var widthMargin: CGFloat {
        return 10
    }
    
    var widthLabelMargin: CGFloat {
        return 20
    }
    
    var heightUpperMargin: CGFloat {
        return 10
    }
    
    var heightBottomMargin: CGFloat {
        return 20
    }
    
    var yValueMax: CGFloat {
        return lines.map{ $0.graphYPoints }.flatMap{ $0 }.flatMap{ $0 }.max()!
    }
    
    var xValueMax: CGFloat {
        return lines.map{ $0.graphXPoints }.flatMap{ $0 }.flatMap{ $0 }.max()!
    }
    
    var xValueMin: CGFloat {
        return lines.map{ $0.graphXPoints }.flatMap{ $0 }.flatMap{ $0 }.min()!
    }
    
    var graphWidth: CGFloat {
        return view.frame.width - widthMargin * 2 - widthLabelMargin
    }
    
    var graphHeight: CGFloat {
        return view.frame.height - heightUpperMargin - heightBottomMargin
    }
    
    var graphMaxValue: CGFloat {    // for better grid
        return findGraphMax(yValueMax)
    }
    
    var xPointSpace: CGFloat {
        return graphWidth / CGFloat(xValueMax - xValueMin)
    }
    
    var numberOfVerticalLine: Int {
        return 4
    }
    
    var numberOfHorizontalLine: Int {
        return 4
    }
    
    
    var verticalLineSpace: CGFloat {
        return (graphHeight) / CGFloat(numberOfVerticalLine)
    }
    
    var horizontalLineSpace: CGFloat {
        return (graphWidth) / CGFloat(numberOfHorizontalLine)
    }
    
    
    func getXPoint(_ xValue: CGFloat) -> CGFloat {
        return  xValue * graphWidth / (xValueMax - xValueMin)  + widthMargin + widthLabelMargin
    }
    
    func getYPoint(_ yValue: CGFloat) -> CGFloat {
        let y: CGFloat = yValue * graphHeight / yValueMax
        return graphHeight + heightUpperMargin - y
    }
    
    func findGraphMax(_ maxYValue: CGFloat) -> CGFloat {
        let maxValue = Double(maxYValue)
        var returnValue = 100;
        if maxValue < 5 {
            returnValue = Int(maxValue.rounded(.up))
        } else if maxValue < 10 {
            returnValue = 10
        } else if maxValue < 100 {
            returnValue = Int( (maxValue/10).rounded(.up)*10 )
        } else if maxValue < 1000 {
            returnValue = Int( (maxValue/100).rounded(.up)*100 )
        } else if maxValue < 10000 {
            returnValue = Int( (maxValue/1000).rounded(.up)*1000 )
        } else {
            let divider: Double = pow(Double(10), findNumberOfDigit(maxValue))
            returnValue = Int( (maxValue/divider).rounded(.up)*divider )
        }
        
        return CGFloat(returnValue)
    }
    
    func findNumberOfDigit(_ number:Double) -> Double {
        var returnValue = 0.0
        var value = number
        while value > 1 {
            returnValue += 1
            value = value / 10
        }
        return returnValue
    }
    
}

//MARK: -
open class SNGraphFrame: UIView, GraphObject {
    
    var lines = [GraphData]()
    
    convenience init(lines: [GraphData]) {
        self.init()
        self.lines = lines
    }
    
    override open func didMoveToSuperview() {
        if self.superview == nil { return }
        self.frame.size = self.superview!.frame.size
        self.view.backgroundColor = UIColor.clear
        
    }
    
    override open func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(rect: rect)
        path.addClip()
        
        drawGraduation()
        drawHorizontalLines()
        drawVerticalLines()
        drawRectangle(rect: rect)
        drawXscaleLabels(view)
        drawYscaleLabels(view)
        
        
    }
    
    // MARK: - draw graduation
    func drawGraduation(){
        
        let rect = CGRect(x: widthMargin + widthLabelMargin, y: heightUpperMargin, width: graphWidth, height: graphHeight)
        let path = UIBezierPath(rect: rect)
        path.addClip()
        
        let startColor = SNWhite
        let endColor = UIColor.clear
        
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()
        
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0, 1.0]
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors, locations: colorLocations)
        
        let startPoint = CGPoint.zero
        let endPoint   = CGPoint(x: 0, y: graphHeight)
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
        context!.restoreGState()
        
        
    }
    
    // MARK: - horizontal lines
    func drawHorizontalLines(){
        
        let hLinePath = UIBezierPath()
        
        //top line
        hLinePath.move(to: CGPoint(x:widthMargin + widthLabelMargin, y: heightUpperMargin))
        hLinePath.addLine(to: CGPoint(x: graphWidth + widthMargin + widthLabelMargin, y: heightUpperMargin))
        
        //bottom line
        hLinePath.move(to: CGPoint(x:widthMargin + widthLabelMargin, y:heightUpperMargin + graphHeight))
        hLinePath.addLine(to: CGPoint(x:graphWidth + widthMargin + widthLabelMargin, y:heightUpperMargin + graphHeight))
        
        let hLinecolor = UIColor.lightGray
        
        hLinecolor.setStroke()
        
        hLinePath.lineWidth = 1.0
        
        hLinePath.stroke()
        
        // lines between
        for i in 1..<numberOfHorizontalLine {
            hLinePath.move(to: CGPoint(x:widthMargin + widthLabelMargin, y: heightUpperMargin + verticalLineSpace * CGFloat(i)))
            hLinePath.addLine(to: CGPoint(x: graphWidth + widthMargin + widthLabelMargin,
                                          y: heightUpperMargin + verticalLineSpace * CGFloat(i)))
        }
        
        hLinePath.lineWidth = 0.3
        
        hLinePath.stroke()
        
        
        
    }
    
    func drawVerticalLines(){
        
        let vLinePath = UIBezierPath()
        
        //left line
        vLinePath.move(to: CGPoint(x: widthMargin + widthLabelMargin, y: heightUpperMargin))
        vLinePath.addLine(to: CGPoint(x: widthMargin + widthLabelMargin, y: heightUpperMargin + graphHeight))
        
        //right line
        vLinePath.move(to: CGPoint(x: widthMargin + widthLabelMargin + graphWidth, y: heightUpperMargin))
        vLinePath.addLine(to: CGPoint(x: widthMargin + widthLabelMargin + graphWidth, y: heightUpperMargin + graphHeight))
        
        let vLinecolor = UIColor.lightGray
        
        vLinecolor.setStroke()
        
        vLinePath.lineWidth = 1.0
        
        vLinePath.stroke()
        
        // lines between
        for i in 1..<numberOfVerticalLine {
            vLinePath.move(to: CGPoint(x:widthMargin + widthLabelMargin + horizontalLineSpace * CGFloat(i), y: heightUpperMargin + graphHeight))
            vLinePath.addLine(to: CGPoint(x:widthMargin + widthLabelMargin + horizontalLineSpace * CGFloat(i), y: heightUpperMargin + graphHeight - 5))
        }
        
        vLinePath.lineWidth = 0.3
        
        vLinePath.stroke()
        
        
    }
    
    
    // MARK: - draw rectangle
    func drawRectangle(rect: CGRect){
        
        let rectangle = UIBezierPath(rect: rect)
        
        let rectColor = UIColor.lightGray
        
        rectColor.setStroke()
        
        rectangle.lineWidth = 0.3
        
        rectangle.stroke()
    }
    
    // MARK: - draw labels
    func drawYscaleLabels(_ view: UIView){
        
        let incrementValue = graphMaxValue / CGFloat(numberOfHorizontalLine)
        for i in 0...numberOfHorizontalLine {
            let yAxisLabel = UILabel()
            let labelValue = incrementValue * CGFloat(i)
            let string = String(format: "%.f", labelValue  )
            yAxisLabel.text = string
            yAxisLabel.font = UIFont.systemFont(ofSize: 9)
            yAxisLabel.textColor = UIColor.darkGray
            
            let xPosition = widthLabelMargin - 10
            let yPosition = heightUpperMargin + graphHeight - verticalLineSpace * CGFloat(i) - 5
            let newFrame = CGRect(x: xPosition, y: yPosition, width: 15, height: 10)
            yAxisLabel.frame = newFrame
            yAxisLabel.textAlignment = .right
            yAxisLabel.sizeToFit()
            view.addSubview(yAxisLabel)
            
        }
    }
    
    func drawXscaleLabels(_ view: UIView){
        let incrementValue = ( xValueMax - xValueMin ) / CGFloat(numberOfVerticalLine)
        for i in 1..<numberOfVerticalLine {
            let xAxisLabel = UILabel()
            let labelValue = incrementValue * CGFloat(i);
            let string = String(format: "%.f", labelValue  )
            xAxisLabel.text = string
            xAxisLabel.font = UIFont.systemFont(ofSize: 9)
            xAxisLabel.textColor = UIColor.darkGray
            
            let xPosition = widthMargin + widthLabelMargin + horizontalLineSpace * CGFloat(i) - 8
            let yPosition = graphHeight + 10
            let newFrame = CGRect(x: xPosition, y: yPosition, width: 16, height: 10)
            xAxisLabel.frame = newFrame
            xAxisLabel.textAlignment = .center
            xAxisLabel.sizeToFit()
            view.addSubview(xAxisLabel)
            
            
        }
        
        
    }
    
    
    
}
