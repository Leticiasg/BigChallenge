//
//  FDViewController.swift
//  instaTeacherFirebase
//
//  Created by Jose Luis Hinostroza on 10/29/15.
//  Copyright © 2015 LazyFox. All rights reserved.
//

import UIKit
import Firebase

class FDViewController: UIViewController, FDDrawViewDelegate{

    let kFireBaseURL = "https://instateacher.firebaseio.com"
//
    var firebase: Firebase!
    var paths: NSMutableArray = []
    @IBOutlet var drawView: FDDrawView!
    var outstandingPaths: Set<String> = []
    var childAddedHandle: FirebaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drawView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



    required init?(coder aDecoder: NSCoder) {
        self.firebase = Firebase(url: kFireBaseURL)
        self.paths = []
        self.outstandingPaths = []
        
        super.init(coder: aDecoder)
     //   fatalError("init(coder:) has not been implemented")
        self.childAddedHandle = self.firebase.observeEventType(FEventType.ChildAdded
            , withBlock: { (snapShot:FDataSnapshot!) -> Void in
                if self.outstandingPaths.contains(snapShot.key){
                    // this was drawn by this device and already taken care of by our draw view, ignore
                }
                else {
                    let path = FDPath.parse(snapShot.value as! NSDictionary)
                    self.drawView.addPath(path)
                    
                    self.paths.addObject(path)
                }
        })
        
    }
    


    func drawView(view: FDDrawView, didFinishDrawingPath path: FDPath) {
        // the user finished drawing a Path
        let pathRef = self.firebase.childByAutoId()
        let name = pathRef.key
        
        // remember that this path was drawn by this user, so it's not drawn twice
        self.outstandingPaths.insert(name)
        
        pathRef.setValue(path.serialize()) { (error, fb) -> Void in
            self.outstandingPaths.remove(name)
        }
        }
    
    }


