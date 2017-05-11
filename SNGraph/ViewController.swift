//
//  ViewController.swift
//  SNGraph
//
//  Created by ts3l20 on 2017/05/01.
//  Copyright © 2017年 sonauma. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawLineGraph()
    }
    
    func drawLineGraph() {
        
        let lineData = loadData()
        
        let lineGraph = SNGraphs(lines: lineData)
        let graphFrame = SNGraphFrame(lines: lineData)
        
        let lineGraphView = UIView(frame:
            CGRect(x: 10, y: 20, width: view.frame.width - 20, height: 200))
        
        lineGraphView.addSubview(graphFrame)
        lineGraphView.addSubview(lineGraph)
        
        view.addSubview(lineGraphView)
    }
    
    func loadData()->[MockData]{
        
        var xPoints:[CGFloat?] = [0.0, 1.0, 2.1, 3.1, 5.0, 7, 9, 11.5, 14, 16, 18, 20];
        
        var yPoints:[CGFloat?] {
            
            var yPtsArr = [CGFloat]()
            
            let xPointMax = xPoints.last
            
            for element in xPoints {
                if element == nil {
                    yPtsArr.append(0)
                } else {
                    
                    let yPt = CGFloat(drand48() * Double(xPointMax!!) )
                    yPtsArr.append( yPt )
                }
            }
            return yPtsArr
        }
        let lineData1 = MockData(graphXPoints: xPoints, graphYPoints: yPoints)
        return [lineData1]
    }
    
    
}
