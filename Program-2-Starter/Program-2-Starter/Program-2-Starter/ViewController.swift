//
//  ViewController.swift
//  Program-2-Starter
//
//  Created by Terry Griffin on 3/23/15.
//  Copyright (c) 2015 mwsu. All rights reserved.
//

import UIKit

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

class ViewController: UIViewController , ColorTableViewControllerDelegate{
    
    // MARK: - Declarations
    
    var myColors:Colors = Colors()
    
    @IBOutlet weak var history1: UILabel!
    @IBOutlet weak var history2: UILabel!
    @IBOutlet weak var history3: UILabel!
    
    @IBOutlet weak var chosenColorLabel: UILabel!
    @IBOutlet weak var colorItemsLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var rgbValueFromColor: UITextField!
    @IBOutlet weak var hslValueFromColor: UITextField!
    @IBOutlet weak var hsvValueFromColor: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request(.GET, "http://cs.mwsu.edu/~griffin/swift/colors2.json")
            
            //Fetch the Json color object from the CS server
            //request(.GET, "https://raw.githubusercontent.com/rugbyprof/msu-swift/master/Program-1-Starter/Program_1_Starter/colors.json?token=AA_qiGlSkC9fWHXsmC732qc3XWl-aKqlks5VFkCWwA%3D%3D")
            
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    println("Error: \(error)")
                    println(req)
                    println(res)
                } else {
                    
                    println("Success")
                    
                    //Unwrap the json (not safe, but oh well)
                    var json = JSON(json!)
                    
                    //If we are successful, then call the method `parseJson` to load the "color class: Colors"
                    self.parseJson(json)
                    
                }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        //if the segue matches a specific identifier
        if (segue.identifier == "colorSegue") {
            
            // create a "reference" to that controller (in this case the Navigation Controller)
            let navVC = segue.destinationViewController as UINavigationController
            
            //Since our ColorTableViewController is embedded in the Navigation Controller, we
            //need to create a reference to it
            let tableVC = navVC.viewControllers.first as ColorTableViewController
            
            //Set the "myColors" variable in the table view with our local class value
            tableVC.myColors = myColors
            
            //Tell the "tableVC" (of type ColorTableViewController in this case)
            //that it's delegate will be "self"
            tableVC.delegate = self
        }
        
        //Here is a slightly different way to do the same thing
        //        if segue.identifier == "colorSegue" {
        //            let navVC = segue.destinationViewController as UINavigationController
        //            let tableVC = navVC.topViewController as ColorTableViewController
        //            tableVC.myColors = myColors
        //            tableVC.delegate = self
        //        }
    }
    
    
    // MARK: - Protocol Implementation
    
    func ColorTableViewChooseColorCancel(controller:ColorTableViewController){
        dismissViewControllerAnimated(true, completion: nil)
        println("choose cancel")
    }
    
    func ColorTableViewChooseColor(controller: ColorTableViewController, chosenColor color: String){
        dismissViewControllerAnimated(true, completion: nil)
        let labelColor:UIColor = myColors.hexStringToUIColor(myColors.fetchHexValue(color))
        chosenColorLabel.backgroundColor = labelColor
        colorItemsLabel.text = color
        
        let rgb = myColors.fetchRGB(color)
        
        let r = Float(255*rgb.R)
        let g = Float(255*rgb.G)
        let b = Float(255*rgb.B)
        // NSString(format: "%.5f", g)+NSString(format: "%.5f", b)
        let rVal = NSString(format: "%.2f", r)
        let gVal = NSString(format: "%.2f", g)
        let bVal = NSString(format: "%.2f", b)
        rgbValueFromColor.text = rVal + " , " + gVal + " , " + bVal;
        
       history3.backgroundColor = history2.backgroundColor
        history2.backgroundColor = history1.backgroundColor
        history1.backgroundColor = labelColor
        
        
        let hsl = myColors.fetchHSL(color)
        
        let h = Float(255*hsl.H)
        let s = Float(255*hsl.S)
        let l = Float(255*hsl.L)
        // NSString(format: "%.5f", g)+NSString(format: "%.5f", b)
        let hVal = NSString(format: "%.2f", h)
        let sVal = NSString(format: "%.2f", s)
        let lVal = NSString(format: "%.2f", l)
        hslValueFromColor.text = hVal + " , " + sVal + " , " + lVal;
        
        
        let hsv = myColors.fetchHSV(color)
        
        let hhsv = Float(255*hsv.H)
        let shsv = Float(255*hsv.S)
        let vhsv = Float(255*hsv.V)
        // NSString(format: "%.5f", g)+NSString(format: "%.5f", b)
        let hsvhVal = NSString(format: "%.2f", hhsv)
        let hsvsVal = NSString(format: "%.2f", shsv)
        let hsvlVal = NSString(format: "%.2f", vhsv)
        hsvValueFromColor.text = hsvhVal + " , " + hsvsVal + " , " + hsvlVal;
        
        println("red: \(r)")
       // redSlider.setValue(r, animated: true)
        //greenSlider.setValue(g, animated: true)
        //blueSlider.setValue(b, animated: true)
        println("Hi")
        println(labelColor)
    }
    
    /********************************************************************************************
    * Function: parseJson
    *   Parses json object and loads it into the "Colors" class for us to use.
    * @Params:
    *   json:JSON - Json object to be parsed
    * @Returns:
    *   Void
    ********************************************************************************************/
    func parseJson(json:JSON)->Void{
        
        var colors = Colors()
        var colorName = ""
        var hexValue = ""
        var hsv:HSV
        var hsl:HSL
        var rgb:RGB
        var col = ""
        var hex = ""
        var r = 0.0
        var g = 0.0
        var b = 0.0
        var h1 = 0
        var s1 = 0.0
        var h2 = 0
        var s2 = 0.0
        var l = 0.0
        var v = 0.0
        
        
        for (index,subjson) in json {
            for (key,val) in subjson {
                switch key {
                case "colorName":
                    col = val.stringValue
                case "hexValue":
                    hex = val.stringValue
                case "RGB":
                    r = val["R"].doubleValue
                    g = val["G"].doubleValue
                    b = val["B"].doubleValue
                case "HSL":
                    h1 = val["H"].intValue
                    s1 = val["S"].doubleValue
                    l = val["L"].doubleValue
                case "HSV":
                    h2 = val["H"].intValue
                    s2 = val["S"].doubleValue
                    v = val["V"].doubleValue
                default:
                    println("Error!")
                }
            }
            
            self.myColors.addColor(col,hex:hex,red:r,green:g,blue:b,hue1:h1,sat1:s1,hue2:h2,sat2:s2,value:v,lightness:l)
        }
        self.myColors.printColors()
        println(self.myColors.fetchColorName("#CE2029"))
        println(self.myColors.fetchRGB("#CE2029"))
    }
    
    @IBAction func redSliderValueChanged(sender: UISlider) {
        var redValue = CGFloat(sender.value)/255
        var blueValue = CGFloat(blueSlider.value)/255
        var greenValue = CGFloat(greenSlider.value)/255
        let newColor = UIColor(red:redValue, green:greenValue,blue:blueValue,alpha:1.0)
        
        chosenColorLabel.backgroundColor = newColor

    }
    
    @IBAction func greenSliderValueChanged(sender: UISlider) {
        var redValue = CGFloat(redSlider.value)/255
        var blueValue = CGFloat(blueSlider.value)/255
        var greenValue = CGFloat(sender.value)/255
        let newColor = UIColor(red:redValue, green:greenValue,blue:blueValue,alpha:1.0)
        
        chosenColorLabel.backgroundColor = newColor
        
    }
    
    @IBAction func blueSliderValueChanged(sender: UISlider) {
        var redValue = CGFloat(redSlider.value)/255
        var blueValue = CGFloat(sender.value)/255
        var greenValue = CGFloat(greenSlider.value)/255
        let newColor = UIColor(red:redValue, green:greenValue,blue:blueValue,alpha:1.0)
        
        chosenColorLabel.backgroundColor = newColor
        
    }
    
    
    
}


