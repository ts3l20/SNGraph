//
//  MockData.swift
//  SNGraph
//
//  Created by ts3l20 on 2017/05/09.
//  Copyright © 2017年 sonauma. All rights reserved.
//

import Foundation
import UIKit

protocol GraphData {
    var graphXPoints: [CGFloat?] { get }
    var graphYPoints: [CGFloat?] { get }
}

extension GraphData {
    var yPointsMax: CGFloat {
        return graphYPoints.flatMap{ $0 }.max()!
    }
    
    var xPointsMax: CGFloat {
        return graphXPoints.flatMap{ $0 }.max()!
    }
}

public struct MockData: GraphData {
    
    var graphXPoints:[CGFloat?]
    
    var graphYPoints:[CGFloat?]
}
