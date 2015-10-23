//
//  FDPath.swift
//  instaTeacherFirebase
//
//  Created by Jose Luis Hinostroza on 10/21/15.
//  Copyright © 2015 LazyFox. All rights reserved.
//

// Implementation of FDPath in swift


import Foundation
import UIKit


// a point object that can be stored in arrays

class FDPoint {
    var x: CGFloat
    var y: CGFloat
    
    init(myPoint: CGPoint){
        x = myPoint.x
        y = myPoint.y
    }
    
    static func Parse(obj:AnyObject)->FDPoint{
        // parse a point from a JSON representation
        var result = FDPoint(myPoint: CGPoint(x: 0, y: 0))
        if !(obj is NSDictionary){
            print("Error, is not a dictionary")
        }
        else{
            let dictionary = obj as! NSDictionary
            if !(dictionary["x"] is NSNumber){
                print("Error, not a valid x value")
            }
            if !(dictionary["y"] is NSNumber){
                print("Error, not a valid y value")
            }
            
            let point = CGPointMake(CGFloat((dictionary["x"]?.floatValue)!), CGFloat((dictionary["y"]?.floatValue)!))
            
            result = FDPoint(myPoint: point)
        }
        return result
    }
    
}




// a path consisting of a color and multiple way points
class FDPath{
    var color: UIColor
    var points: NSMutableArray
    
    init(withColor _color:UIColor){
        color = _color
        points = []
    }
    
    init(withPoints _points:NSMutableArray, andColor _color:UIColor){
        color = _color
        points = _points
    }
    
    static func parse(dictionary: NSDictionary) -> FDPath {
        
        var result = FDPath(withColor: UIColor.whiteColor())
        
        if !(dictionary["color"] is NSNumber) {
            print("it doesnt have color")
        }
        else if !(dictionary["points"] is NSArray) {
            print("it doesnt have an array of points")
        }
        else {
            let theColor = FDPath.parseColor(dictionary["color"] as! NSNumber)
            
            let rawPoints = dictionary["points"] as! NSArray
            var  thePoints: NSMutableArray = []
            
            for rawP in rawPoints {
                let point = FDPoint.Parse(rawP)
                // falta uma validacao
                thePoints.addObject(point)
            }
            
            result = FDPath(withPoints: thePoints, andColor: theColor)
        }
        
        return result
    }

//    func serialize() -> NSDictionary {
//        var dictionary: NSMutableDictionary
//        
//        dictionary["color"] = FDPath.serializeColor(self.color)
//        
//        var points: NSMutableArray
//        for point in self.points {
//            var thePoint = point as! FDPoint
//            points.addObject(["x":"0"])
//        }
//       dictionary["points"] = points
//        
//        return dictionary
//    }
    
    static func parseColor(number: NSNumber) -> UIColor {
        let integer = number.integerValue
        let alpha = CGFloat(((integer >> 24) & 0xff)/255)
        let red = CGFloat(((integer >> 16) & 0xff)/255)
        let green = CGFloat(((integer >> 8) & 0xff)/255)
        let blue = CGFloat((integer & 0xff)/255)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func serializeColor(color: UIColor) -> NSNumber {
        var integer = 0
        
        //var (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) = (0,0,0,0)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        integer += (Int(alpha * 255) & 0xff) << 24;
        integer += (Int(red * 255) & 0xff) << 16;
        integer += (Int(green * 255) & 0xff) << 8;
        integer += (Int(blue * 255) & 0xff);
        
        return NSNumber(integer: integer)
    }
}