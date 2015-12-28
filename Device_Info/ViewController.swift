//
//  ViewController.swift
//  DeviceInfo
//
//  Created by abdul karim on 26/12/15.
//  Copyright © 2015 dhlabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var deviceFamily: UILabel!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var iOSVersion: UILabel!
    @IBOutlet weak var batteryStatus: UILabel!
    @IBOutlet weak var deviceType: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Getting Device Name
        let device = Device ()
        deviceType.text = "\(device)"
        
        deviceName.text = UIDevice.currentDevice().name
        iOSVersion.text = UIDevice.currentDevice().systemVersion
        
        
        //Checking battery status
        //        if(device.batteryState == .Charging(95)){
        //            batteryStatus.text = "Charging"
        //            batteryStatus.textColor = UIColor.greenColor()
        //        }
        //        else if(device.batteryState == .Unplugged(95)){
        //            batteryStatus.text = "Not Charging"
        //
        //        }
        
        
        
        
        
        
        
    }
    
}


