//
//  DrawingView.swift
//  InstaTeacherFirebase
//
//  Created by Letícia Gonçalves on 10/15/15.
//  Copyright © 2015 LazyFox. All rights reserved.
//
//
//  DrawingView.swift
//  InstaTeacher
//
//  Created by Letícia Gonçalves on 10/15/15.
//  Copyright © 2015 LazyFox. All rights reserved.
//

import UIKit
import Firebase

var lines: [Line] = []


class DrawingView: UIView {
    
    // Create a reference to a Firebase location
    
    var lastPoint: CGPoint!
    
    
    
    required init?(coder aDecoder: (NSCoder!)){
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(self)
            lastPoint = position
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let newPoint = touch.locationInView(self)
            lines.append(Line(start: lastPoint, end: newPoint))
            lastPoint = newPoint
        }
        self.uptade()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, 3)
        CGContextSetLineCap(context, .Round)
        for line in lines{
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, line.start.x, line.start.y)
            CGContextAddLineToPoint(context, line.end.x, line.end.y)
            CGContextSetRGBStrokeColor(context, 1, 1, 1, 1)
            CGContextStrokePath(context)
        }
    }
    
    func uptade(){
        self.setNeedsDisplay()
    }
    
    func clear(){
        lines.removeAll()
        self.uptade()
    }
    
}
