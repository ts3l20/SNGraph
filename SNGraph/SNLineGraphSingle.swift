//
//  SNLineGraphSingle.swift
//  SNGraph
//
//  Created by ts3l20 on 2017/05/11.
//  Copyright © 2017年 sonauma. All rights reserved.
//

import Foundation
import UIKit

open class SNLineGraphSingle: UIView, GraphObject {
    var lines: [GraphData] = []
    
    var color = UIColor.white
    
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
        
        guard let lineData = lines.first else {return}
        
        let xPoints = lineData.graphXPoints
        let yPoints = lineData.graphYPoints
        
        let linePath = drawLine(xPts: xPoints, yPts: yPoints)
        drawGraduation(xPts: xPoints, yPts: yPoints, path: linePath)
        drawSymbols(xPts: xPoints, yPts: yPoints)
        
    }
    
    func drawLine(xPts: [CGFloat?], yPts: [CGFloat?]) -> UIBezierPath{
        
        let graphPath = UIBezierPath()
        
        let xPoint0 = getXPoint(xPts[0]!)
        let yPoint0 = getYPoint(yPts[0]!)
        graphPath.move(to: CGPoint(x:xPoint0, y:yPoint0))
        
        for i in 1..<yPts.count {
            let xPointi = getXPoint(xPts[i]!)
            let yPointi = getYPoint(yPts[i]!)
            let nextPoint = CGPoint(x:xPointi, y:yPointi)
            graphPath.addLine(to: nextPoint)
        }
        
        let lineColor = UIColor.blue
        lineColor.setFill()
        lineColor.setStroke()
        graphPath.lineWidth = 0.8
        graphPath.stroke()
        
        return graphPath
        
    }
    
    func drawGraduation(xPts: [CGFloat?], yPts: [CGFloat?], path: UIBezierPath) {
        
        let context = UIGraphicsGetCurrentContext()
        
        context!.saveGState()
        
        let clippingPath = path.copy() as! UIBezierPath
        
        let xPtsLast = getXPoint(xPts.last!!)
        let yPtsLast = getYPoint(yPts.last!!)
        let xPtsFirst = getXPoint(xPts.first!!)
        let yPtsFirst = getYPoint(yPts.first!!)
        clippingPath.move(to: CGPoint(x: xPtsLast,  y: yPtsLast))
        clippingPath.addLine(to: CGPoint(x: xPtsLast,  y: heightUpperMargin+graphHeight))
        clippingPath.addLine(to: CGPoint(x: xPtsFirst, y: heightUpperMargin+graphHeight))
        clippingPath.addLine(to: CGPoint(x: xPtsFirst, y: yPtsFirst))
        
        clippingPath.close()
        
        clippingPath.addClip()
        
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors, locations: colorLocations)
        
        let yMaxCGPoint = getYPoint(yValueMax)
        let startPoint = CGPoint(x:widthMargin + widthLabelMargin, y: yMaxCGPoint)
        let endPoint   = CGPoint(x:widthMargin + widthLabelMargin, y:heightUpperMargin+graphHeight-1)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
        context!.restoreGState()
        
    }
    
    // MARK: - draw symbols
    func drawSymbols(xPts: [CGFloat?], yPts: [CGFloat?]){
        
        for i in 0..<yPts.count {
            let xPointi = getXPoint(xPts[i]!)
            let yPointi = getYPoint(yPts[i]!)
            var point = CGPoint(x:xPointi, y: yPointi)
            
            let width:CGFloat = 4.0
            let height:CGFloat = 4.0
            point.x -= width/2
            point.y -= height/2
            
            let circlePath = UIBezierPath(ovalIn:
                CGRect(origin: point, size: CGSize(width: width, height: height)))
            
            let circleColor = SNOcean
            circleColor.setFill()
            circlePath.fill()
            
            circleColor.setStroke()
            circlePath.lineWidth = 1
            circlePath.stroke()
        }
        
    }
}
