//
//  FDDrawView.swift
//  instaTeacherFirebase
//
//  Created by Jose Luis Hinostroza on 10/28/15.
//  Copyright © 2015 LazyFox. All rights reserved.
//

import Foundation
import UIKit
//import FDPath

class FDDrawView:UIView{

    var drawColor:UIColor?
    var delegate:FDDrawViewDelegate?
    
    
    var paths: NSMutableArray?
    var currentPath: FDPath?
    var currentTouch: UITouch?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.paths = []
        self.backgroundColor = UIColor.whiteColor()
        self.drawColor = UIColor.redColor()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPath(path: FDPath){
        self.paths?.addObject(path)
        self.setNeedsDisplay()
    }
    
    func drawPath(path: FDPath, context: CGContextRef){
        if(path.points.count > 1){
            CGContextBeginPath(context)

            CGContextSetStrokeColorWithColor(context, path.color.CGColor)
            
            let point = path.points[0] as! FDPoint;
             CGContextMoveToPoint(context, point.x, point.y)
            
            //draw all lines in the path
            
            for aPoint in path.points {
                let point = aPoint as! FDPoint
                CGContextAddLineToPoint(context, point.x, point.y)
            }
            
            //actually draw the path
            CGContextDrawPath(context, CGPathDrawingMode.Stroke)
            
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context,0.5)
        
        for aPath in self.paths! {
            let thePath = aPath as! FDPath
            self.drawPath(thePath, context: context!)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            self.currentTouch = touch
            self.currentPath = FDPath(withColor: self.drawColor!)
            
            //add the current point on the path
            let touchPoint = self.currentTouch?.locationInView(self)
            self.currentPath?.addPoint(touchPoint!)
            self.setNeedsDisplay()
        }
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let _ = touches.first {
            for aTouch in touches {
                if (self.currentTouch == aTouch){
                    let touchPoint = self.currentTouch?.locationInView(self)
                    self.currentPath?.addPoint(touchPoint!)
                    self.setNeedsDisplay()
                }
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let _ = touches?.first {
            for aTouch in touches! {
                if (self.currentTouch == aTouch){
                    self.currentPath = nil
                    self.currentTouch = nil
                    self.setNeedsDisplay()
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _  = touches.first {
            for aTouch in touches {
                if (self.currentTouch == aTouch){
                    self.paths?.addObject(self.currentTouch!)
                    self.delegate!.drawView(self, didFinishDrawingPath: self.currentPath!)
                    self.currentPath = nil
                    self.currentTouch = nil
                }
            }
        
        }

    }
}
protocol FDDrawViewDelegate {
    //protocol definition

    // called when a user finished drawing a line/path
     func drawView(view: FDDrawView, didFinishDrawingPath path: FDPath)
}