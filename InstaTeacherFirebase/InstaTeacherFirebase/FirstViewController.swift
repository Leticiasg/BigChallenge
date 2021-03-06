//
//  FirstViewController.swift
//  InstaTeacherFirebase
//
//  Created by Letícia Gonçalves on 10/15/15.
//  Copyright © 2015 LazyFox. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {
    
    @IBOutlet weak var drawBoard: DrawingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearButton(sender: AnyObject) {
        drawBoard.clear()
    }

}

