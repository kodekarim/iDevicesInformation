# iDevicesInformation

A Light Weight and Updated Code for Device Detection and many other functionality  written in swift 2.0
<img src="https://cloud.githubusercontent.com/assets/13949425/12014597/7836da1e-ad55-11e5-97ea-0dee94a825c7.png" width="30%"></img> 

#How To Use
Just import the class file to your project and you are ready to go..

#Implementation
#To Know the device type
        let device = Device ()

        deviceType.text = "\(device)" </p1>
        
#To Know Device name
         deviceName.text = UIDevice.currentDevice().name

#To Know iOS Version 
         iOSVersion.text = UIDevice.currentDevice().systemVersion

#To Check Battery Status
         device.batteryState == .Charging(65)</p1>
Here "95" is the battery percentage to track</p2><br>
For example if the device battery percentage is more then 90
Then graphic quality = HIGH

for reference see the code....
