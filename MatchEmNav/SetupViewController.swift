//
//  SetupViewController.swift
//  MatchEmTab
//
//  Created by Conner Montgomery on 4/14/22.
//

import UIKit

// Model Object -- global for use in other
var model = ModelObject()



class SetupViewController: UIViewController {

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("sVC:\(#function)")
    }
    
    // Make GameScene View Controller Known to Setup View Controller
    var gameVC: GameSceneViewController?
    

    // High Scores Label
    @IBOutlet weak var highScores: UILabel!
    
    
    
    @IBOutlet weak var speedLabel: UILabel!
   
    
    // Change speed UISlider
    @IBAction func changeSpeed(_ sender: UISlider) {
        
        let currentValue = Double(sender.value)
        
        var usedValue = 1 - currentValue
        
        if (usedValue == 0) {
            usedValue = 0.1
        }
        
        speedLabel.text = "Speed: every \(round(usedValue*100)/100.0) seconds"
        
        //Make sure GameScene View controller has loaded
        if let gvc = gameVC {
            gvc.newRectInterval = usedValue
            
        }
        
    }
    
    @IBOutlet weak var bgLabel: UILabel!
    
    // Change Background Color UISlider
    @IBAction func changeBackground(_ sender: UISlider) {
        
        // sender get value from 0 to 1
        
        // Gets 0 to 1 value
        let cVal = Double(sender.value)
        
        
        let useVal: CGFloat
        
        // Allows for four different black to white background color transitions
        if(cVal >= 0.0 && cVal <= 0.25) {
            useVal = 0.0
            bgLabel.text = "Background Color: Black"
            
            if let gvc = gameVC {
                gvc.backColor = "Black"
            }
            
        } else if (cVal > 0.25 && cVal <= 0.5) {
            useVal = 0.33
            bgLabel.text = "Background Color: Dark Grey"
            
            if let gvc = gameVC {
                gvc.backColor = "Dark Grey"
            }
            
        } else if (cVal > 0.5 && cVal <= 0.75) {
            useVal = 0.66
            bgLabel.text = "Background Color: Light Grey"
            
            if let gvc = gameVC {
                gvc.backColor = "Light Grey"
            }
            
        } else {
            useVal = 1.0
            bgLabel.text = "Background Color: White"
            
            if let gvc = gameVC {
                gvc.backColor = "White"
            }
            
        }
    
        
        // update on game scene controller
        if let gvc = gameVC {
            gvc.view.backgroundColor = UIColor(red: useVal, green: useVal, blue: useVal, alpha: 1.0)
        }
        
        
    }
    
    @IBOutlet weak var gtLabel: UILabel!
    
    // Change Length of Game
    @IBAction func changeGameTime(_ sender: UISlider) {
        
        // sender get value from 0 to 1
        
        // Gets 0 to 1 value
        let cVal = Double(sender.value)
        
        
        let useVal: Double
        
        // Allows for four different black to white background color transitions
        if(cVal >= 0.0 && cVal <= 0.25) {
            // 8 Seconds
            useVal = 8.0
            gtLabel.text = "Game Duration: 8 seconds"
        } else if (cVal > 0.25 && cVal <= 0.5) {
            // 10 Seconds
            useVal = 10.0
            gtLabel.text = "Game Duration: 10 seconds"
        } else if (cVal > 0.5 && cVal <= 0.75) {
            // 12 Seconds  -- inital time
            useVal = 12.0
            gtLabel.text = "Game Duration: 12 seconds"
        } else {
            // 14 Seconds
            useVal = 14.0
            gtLabel.text = "Game Duration: 14 seconds"
        }
        
        
        
        if let gvc = gameVC {
            gvc.gameTimeRemaining = useVal
            gvc.gt = useVal
            
        }
        
        
    }
    
    

        // Toggles 2x score on every 3rd match
 @IBAction func toggle2X(_ sender: UISwitch) {
        
        if(sender.isOn == true) {
            if let gvc = gameVC {
                gvc.doubleMode = true
            }
        }
         
        
    }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("sVC:\(#function)")
        

        
        if let gvc = navigationController?.viewControllers[0] {
            gameVC = (gvc as! GameSceneViewController)
        }
        
        
        //gameVC = self.navigationController?.viewControllers[0] as? GameSceneViewController
        if let gvc = gameVC {
            speedLabel.text = "Speed: every \(round(gvc.newRectInterval*100)/100.0) seconds"
        }
        
        if let gvc = gameVC {
            bgLabel.text = "Background Color: \(gvc.backColor)"
        }
        
        if let gvc = gameVC {
            gtLabel.text = "Game Duration: \(gvc.gameTimeRemaining) seconds"
            
        }
  

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        highScores.text = " 1.) \(model.items[0].score )\n 2.) \(model.items[1].score)\n 3.) \(model.items[2].score)"
        
        if let gvc = gameVC {
            speedLabel.text = "Speed: every \(gvc.newRectInterval) seconds"
        }
        
        if let gvc = gameVC {
            bgLabel.text = "Background Color: \(gvc.backColor)"
        }
        
        if let gvc = gameVC {
            gtLabel.text = "Game Duration: \(gvc.gt) seconds"
            
        }
     
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


