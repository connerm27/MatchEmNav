//
//  GameSceneViewController.swift
//  MatchEmTab
//
//  Created by Conner Montgomery on 4/14/22.
//

import UIKit

class GameSceneViewController: UIViewController {

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("gsVC:\(#function)")
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    // Dictionary to hold pairs
    var bDict: [UIButton: UIButton] = [:]

    private var numClick: Int = 0

    var btnSaved: UIButton?
    
    // Min and Max height for rectangles
    private let rectSizeMin:CGFloat = 50.0
    private let rectSizeMax:CGFloat = 150.0
    
    // How long for rectangles to fade away (animation)
    private var fadeDuration: TimeInterval = 0.8

    // Rectangle creation interval
    var newRectInterval: TimeInterval = 0.5
    // Rectangle creation, so the timer can be stopped
    private var newRectTimer: Timer?
    
    // Game Duration Variables
    //private var gameDuration: TimeInterval = 12.0
    private var gameTimer: Timer?
    
    // double mode on
    var doubleMode: Bool = false
    
    
    // Is the game paused
    var gameIsPaused:Bool = true
    
    // Current Background Color
    var backColor:String = "White"
    
    // Counters
    private var pairsCreated: Int = 0 {
        didSet { gameInfoLabel?.text = gameInfo}
        
    }
    
    var matches: Int = 0 {
        didSet { gameInfoLabel?.text = gameInfo}
    }
    
    // A game is in progress
    private var gameInProgress = false
    
    // Init the time remaining
    // to play the game
    var gt:TimeInterval = 12.0
    
    var gameTimeRemaining : TimeInterval = 12.0 {
        didSet { gameInfoLabel?.text = gameInfo }
    }
    
    
    
    @IBOutlet weak var gameInfoLabel: UILabel!
    
    
    private var gameInfo: String {
        
        
        let labelText = String(format: "Time: %2.1f  Pairs: %2d Matches: %2d",
        gameTimeRemaining, pairsCreated, matches)
        return labelText
        
    }
    
    // MARK: - ==== GameSceneViewController Methods ====
    //================================================
    @objc private func handleTouch(sender: UIButton) {
        
        
        if(!gameInProgress) {
            return;
        }
        
        
        
        numClick += 1
        
        
        if numClick%2 == 1 {
            //
            btnSaved = sender
            // Adds text top sender aka rectangle
            sender.setTitle("😊", for: .normal)
            
        } else {
            // see if they are matching
            // search all key/values at once and see if they match
            
            // flag determines emoji
            var flag: Int = 0
            
            for (key, value) in bDict {
                
                // if the first button clicked is a key
                if(btnSaved == key) {
                    let getVal = bDict[key]
                    if(sender == getVal) {
                        // add "matched" emoji
                        sender.setTitle("😊", for: .normal)
                        flag = 1
                        // animates a dissappearing rectangle
                        removeRectangle(rectangle: sender)
                        removeRectangle(rectangle: btnSaved!)
                        // increment matches
                        matches += 1
                        
                        // if playing double mode
                        if(doubleMode == true) {
                            if(matches != 0) {
                                if(matches % 3 == 0) {
                                    matches = matches + 1
                                }
                            }
                        }
                    }
                }
                
                // if the first button clicked in a value
                if(btnSaved == value) {
                    // check which key has that value
                    for key in bDict.keys {
                        let getVal = bDict[key]
                        if(btnSaved == getVal) {
                            if(sender == key) {
                                // add "matched" emoji
                                sender.setTitle("😊", for: .normal)
                                flag = 1
                                // animates a dissappearing rectangle
                                removeRectangle(rectangle: sender)
                                removeRectangle(rectangle: btnSaved!)
                                // increment matches
                                matches += 1
                                
                                // if playing double mode
                                if(doubleMode == true) {
                                    if(matches != 0) {
                                        if(matches % 3 == 0) {
                                            matches = matches + 1
                                        }
                                    }
                                }

                                
                            }
                        }
                        
                    }
                    
                }
                
            }
            
            if (flag == 0) {
                btnSaved!.setTitle("", for: .normal)
            }
            
            
            
            
            
        }
        
        //**also need to add game timer
        
        
        
        
        
        
       // let test: UIButton? = bDict[sender]
        //removeRectangle(rectangle: test!)
        
        
    
        
        print("\(#function) - \(sender)")
    }
    
    
    
    
    // TEST PAUSE/Restart
    var toggle: Int = 1
    
    
    // Need to restart game
    var restartGame: Int = 0
    
    // Double tapped function
    @objc func doubleTapped() {
        if (restartGame == 1) {
            restartGameRunning()
            restartGame = 0
        } else {
        
        if (toggle == 0) {
            pauseGame()
            toggle = 1
        } else {
            startGameRunning()
            toggle = 0
        }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("gsVC:\(#function)")
        
        self.view.isMultipleTouchEnabled = true
        
        // Tap Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 2
            view.addGestureRecognizer(tap)
        
        
        // Adding 0's to high score to start
        let finalScore = Item(score: 0)
        model.addItem(test: finalScore)
        model.addItem(test: finalScore)
        model.addItem(test: finalScore)
    
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


extension GameSceneViewController {
    
    
    
    // CREATE RECTANGLE FUNCTION
    private func createRectangle() {
        
        // Decrement the game time remaining
        gameTimeRemaining -= newRectInterval
        
        // Get random values for size and location
        let randSize = Utility.getRandomSize(fromMin: rectSizeMin, throughMax: rectSizeMax)
        let randLocation = Utility.getRandomLocation(size: randSize, screenSize: view.bounds.size)
        let randomFrame = CGRect(origin: randLocation, size: randSize)
        let rectColor = Utility.getRandomColor(randomAlpha: false)
           

        
        // Create a rectangle frame
        let rectangleFrame = randomFrame
        
        // Create a rectangle from randomFrame
        let rectangle = UIButton(frame:rectangleFrame)
        
        //Button/Rectangle set up
        rectangle.backgroundColor = rectColor
        rectangle.setTitle("", for: .normal)

        rectangle.setTitleColor(.black, for: .normal)
        rectangle.titleLabel?.font = .systemFont(ofSize: 50)
      //  rectangle.showsTouchWhenHighlighted = true
        
        // Adds target method to rectangle for touch
        rectangle.addTarget(self,
                            action: #selector(self.handleTouch(sender:)),
                            for: .touchUpInside)
        
        
        // Make the rectangle visible
        self.view.addSubview(rectangle)
        
        
        
        // Making rectangles 2 --------------
        let randLocation2 = Utility.getRandomLocation(size: randSize, screenSize: view.bounds.size)
        let randomFrame2 = CGRect(origin: randLocation2, size: randSize)
        
        let rectangleFrame2 = randomFrame2
        
        // Create second rectangle same size, different location
        let rectangle2 = UIButton(frame:rectangleFrame2)
        
        //Button/Rectangle set up
        rectangle2.backgroundColor = rectColor
        rectangle2.setTitle("", for: .normal)

        rectangle2.setTitleColor(.black, for: .normal)
        rectangle2.titleLabel?.font = .systemFont(ofSize: 50)
        //rectangle2.showsTouchWhenHighlighted = true
        
        // add target method to rectangle2
        rectangle2.addTarget(self,
                            action: #selector(self.handleTouch(sender:)),
                            for: .touchUpInside)
        
        
        
        // Make the rectangle2 visible
        self.view.addSubview(rectangle2)
        
        // Add rectangle key and rectangles value to dictionary
        bDict[rectangle] = rectangle2
        
        pairsCreated += 1
        
        // Move label to the front
        view.bringSubviewToFront(gameInfoLabel!)
        
        

      
    }
    
    //RESTART GAME RUNNING
    private func restartGameRunning() {
        // reset game data and restart game
        matches = 0
        pairsCreated = 0
        gameTimeRemaining = gt
        removeSavedRectangles()
        startGameRunning()
        
        
    }
    
    //START GAME RUNNING FUNCTIOM
    private func startGameRunning() {
        
        //remove rectangles from previous run
        //removeSavedRectangles()
        
        gameInProgress = true
        
        // Game Duration Timer
        gameTimer = Timer.scheduledTimer(withTimeInterval: gameTimeRemaining, repeats:false)
        {_ in self.stopGameRunning()}
        
        // Static timer to produce rectangles at an interval
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval, repeats:true)
        { _ in self.createRectangle() }
        
        
        
        
    }
    
    //PAUSE GAME
    private func pauseGame() {
    
        gameInProgress = false
        if let timer = newRectTimer {timer.invalidate()}
     
    }
    
    
    //STOP GAME RUNNING FUNCTION
    private func stopGameRunning() {
        
        //Time is zero at end
        gameTimeRemaining = 0.0
        gameInfoLabel?.text = gameInfo
        
        // Stop Timer
        if let timer = newRectTimer { timer.invalidate() }
        
        // Remove reference to timer object
        self.newRectTimer = nil
        
        gameInProgress = false
        
        // make item of score
        let finalScore = Item(score: matches)
       // let fScore = matches
        
        
        print("adding \(finalScore)")
        // add item to data model
        model.addItem(test: finalScore)
    
        // Sort items
        model.items.sort{ $0.score > $1.score}
        
        // print for debuggin
        print("Debugging")
        print("\(model.items[0])")
        
        
        
        //flag
        restartGame = 1
        
        
    }
    
    
    // REMOVE RECTANGLE FUNCTION
    func removeRectangle(rectangle: UIButton) {
        // Rectangle fade animation
        let pa = UIViewPropertyAnimator(duration: fadeDuration, curve:.linear, animations:nil)
        pa.addAnimations {
            rectangle.alpha = 0.0
        }
        
        //start animation
        pa.startAnimation()
        
        // Actually removes the rectangle from the view
        //rectangle.removeFromSuperview()
        
    }
    
    //================================================
    func removeSavedRectangles() {
    // Remove all rectangles from superview
        for (key, value) in bDict {
            
             key.removeFromSuperview()
            
             value.removeFromSuperview()
            
        }
    }
    
}



