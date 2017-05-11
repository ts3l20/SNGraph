//
//  SNGraphs.swift
//  SNGraph
//
//  Created by ts3l20 on 2017/05/09.
//  Copyright © 2017年 sonauma. All rights reserved.
//

import Foundation
import UIKit



open class SNGraphs: UIView, GraphObject {
    
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
        
        for line in lines {
            let singleLine = [line]
            let lineGraph = SNLineGraphSingle(lines: singleLine) as UIView
            view.addSubview(lineGraph)
        }
    }
}

