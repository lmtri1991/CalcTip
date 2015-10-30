
import UIKit

class ViewController: UIViewController {

    // constants
    let ZERO_LABEL = "$0.00"
    let DEFAULT_TIP_PERCENTAGE = 15
    let DEFAULT_PARTY_SIZE = 1
    let DEFAULT_ROUND = false
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var selectedTipLabel: UILabel!
    @IBOutlet weak var partySizeControl: UISegmentedControl!
    @IBOutlet weak var individualTotalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set default label text
        tipLabel.text = ZERO_LABEL
        totalLabel.text = ZERO_LABEL
        individualTotalLabel.text = ZERO_LABEL

        // get defaults
        let defaults = getUserDefaults()
        let defaultTipPercentage = defaults.integerForKey("defaultTipPercentage")
        let defaultPartySize = defaults.integerForKey("defaultPartySize")
        
        // init controls & labels
        billField.becomeFirstResponder()
        tipSlider.value = Float(defaultTipPercentage)
        selectedTipLabel.text = String(format: "%d%%", defaultTipPercentage)
        partySizeControl.selectedSegmentIndex = defaultPartySize - 1;
        
        //------------right  swipe gestures in view--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("rightSwiped"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //-----------left swipe gestures in view--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("leftSwiped"))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        //-----------down swipe gestures in view--------------//
        let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("downSwiped"))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        //-----------up swipe gestures in view--------------//
        let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("upSwiped"))
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
        
     
        
    }
    
    func rightSwiped()
    {
        print("right swiped ")
    }
    
    func leftSwiped()
    {
        print("left swiped ")
    }
    
    func downSwiped()
    {
        print("down swiped ")
    }
    
    func upSwiped()
    {
        print("Up swiped ")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // trigger onEditingChanged() because round up setting might have changed
        onEditingChanged(self)
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        
        // get tip % from slider
        let tipPercentageWhole = Int(tipSlider.value)
        
        // convert to decimal
        let tipPercentage = Double(tipPercentageWhole) / 100.0

        // calculate tip & total
        let billAmount = (billField.text! as NSString).doubleValue 
        let tip = billAmount * tipPercentage
        let total = billAmount + tip

        // calculate party details
        let defaults = getUserDefaults()
        let round = defaults.boolForKey("defaultRoundPartyAmount")
        let partySize = partySizeControl.selectedSegmentIndex + 1;
        var individualTotal = total / Double(partySize)
        if (round) {
            individualTotal = ceil(individualTotal)
        }
        
        // update labels
        selectedTipLabel.text = String(format: "%d%%", tipPercentageWhole)
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        individualTotalLabel.text = String(format: "$%.2f", individualTotal)
        
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func getUserDefaults() -> NSUserDefaults {
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey("defaultTipPercentage") == nil) {
            // set initial defaults
            defaults.setInteger(DEFAULT_TIP_PERCENTAGE, forKey: "defaultTipPercentage")
            defaults.setInteger(DEFAULT_PARTY_SIZE, forKey: "defaultPartySize")
            defaults.setBool(DEFAULT_ROUND, forKey: "defaultRoundPartyAmount")
            defaults.synchronize()
        }
        return defaults
    }
    
}

