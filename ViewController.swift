//
//  ViewController.swift
//  fggfg
//
//  Created by Henry Spindell on 2/11/16.
//  Copyright © 2016 Henry Spindell. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    @IBOutlet weak var dbLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    // TODO: there's probably a good way to do this programatically
    //       rather than for each button
    @IBAction func recordTree(sender: UIButton) {
        print("tree")
        recordWorldObject("tree")
    }
    
    
    @IBAction func recordFireHydrant(sender: UIButton) {
        print("hydrant")
        recordWorldObject("fire_hydrant")
    }
    
    
    @IBAction func recordStopSign(sender: UIButton) {
        print("stop sign")
        recordWorldObject("stop_sign")
    }
    
    @IBAction func recordTallBuilding(sender: UIButton) {
        print("tall building")
        recordWorldObject("tall_building")
    }
    
    @IBAction func recordOther(sender: UIButton) {
        
        let passwordPrompt = UIAlertController(title: "Enter object type", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        passwordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if let tf = passwordPrompt.textFields?[0],
                ob = tf.text {
                self.recordWorldObject(ob)
            }
        }))
        passwordPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Object type"
            textField.secureTextEntry = false
        })

        presentViewController(passwordPrompt, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        

        // ATTN: see the file Keys_template.txt to implement __DEV_MODE
        dbLabel.text = __DEV_MODE ? "db: DEV" : "db: PROD"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    
    func recordWorldObject(label: String) {
        let worldObject = WorldObject()
        worldObject.trigger = "world_mapper"
        worldObject.label = label
        worldObject.location = PFGeoPoint(location: locationManager.location)
        worldObject.verified = true
        worldObject.saveInBackground()
       
        alertSavedObject(label)
    }
    
    func alertSavedObject(label: String) {
        let title = "Successfully saved " + label + " object!"
        let successAlert = UIAlertController(title:title, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        successAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(successAlert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationLabel.text = "Loc: (" + locations[0].coordinate.latitude.description + "," + locations[0].coordinate.longitude.description + ")"
    }
    
}

