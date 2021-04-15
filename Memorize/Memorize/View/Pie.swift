//
//  Pie.swift
//  Memorize
//
//  Created by Tarlan Askaruly on 15.04.2021.
//

import Foundation
import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second )
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center: CGPoint = CGPoint(x: rect.midX, y: rect.midY)
        let radius: CGFloat = min(rect.width, rect.height) / 2
        let start: CGPoint = CGPoint(
            x: center.x +  radius * cos(CGFloat(startAngle.radians)),
            y: center.y +  radius * sin(CGFloat(startAngle.radians))
        )
        
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        p.addLine(to: center)
        return p
    }
    
    
    
}
