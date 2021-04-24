//
//  ViewController.swift
//  TestingApp
//
//  Created by Daniel Duan on 3/28/21.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    let realm = try! Realm()
    
    // avatar model
    var avatar = Avatar()

    // IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarTestingCount: UILabel!
    @IBOutlet weak var avatarDescription: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var scheduleTestButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set up views
        setUpViews()
        
        let testCount = TestCount()
        try! realm.write {
            realm.add(testCount)
        }
        
        // update avatar description
        updateAvatar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("excuse me?")
        
        // check if button should be enabled
        if avatar.testingCount > 0 {
            checkInButton.isEnabled = false
            checkInButton.setTitleColor(.systemGray, for: .disabled)
            guard let waitingDate = UserDefaults.standard.object(forKey: "waitingDate") as? Date else { return }
            let currentDate = Date()
            if(currentDate.compare(waitingDate) == ComparisonResult.orderedDescending) {
                checkInButton.isEnabled = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setUpViews() {
        
        checkInButton.layer.cornerRadius = 15
        scheduleTestButton.layer.cornerRadius = 15
        
        welcomeLabel.text = "Hey there, Daniel."
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.minimumScaleFactor = 0.65
        
    }
    
    /**
     Updates the avatar on the main screen based on amount of tests made by the user.
     */
    func updateAvatar() {
        
        let testCount = realm.objects(TestCount.self).first
        avatar.testingCount = testCount?.testCount ?? 0
            
        if (avatar.testingCount < 2) {
            let saplingImg = UIImage(named: "Sapling")
            avatar.imageView.image = saplingImg
            avatar.desc = "Your plant is a Sapling."
        } else if (avatar.testingCount < 4) {
            let leafletImg = UIImage(named: "Leaflet")
            avatar.imageView.image = leafletImg
            avatar.desc = "Your plant is a Leaflet."
        } else if (avatar.testingCount < 6) {
            let babyTreeImg = UIImage(named: "BabyTree")
            avatar.imageView.image = babyTreeImg
            avatar.desc = "Your plant is a Baby Tree."
        } else {
            let treeImg = UIImage(named: "Tree")
            avatar.imageView.image = treeImg
            avatar.desc = "Your plant is a Tree!"
        }
        
        if (avatar.testingCount == 1) {
            avatar.testingCountDescription = "Wow! You've been tested \(avatar.testingCount) time!"
        } else {
            avatar.testingCountDescription = "Wow! You've been tested \(avatar.testingCount) times!"
        }

        avatarImageView.image = avatar.imageView.image
        avatarDescription.text = avatar.desc
        avatarTestingCount.text = avatar.testingCountDescription
    }
    
    func disableCheckInButton() {
        
        checkInButton.isEnabled = false
        checkInButton.setTitleColor(.systemGray, for: .disabled)
        
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        UserDefaults.standard.setValue(newDate, forKey: "waitingDate")
        
//        var secondsDisabled = 0.0
//
//        let now = Calendar.current.dateComponents(in: .current, from: Date())
//        if let currentHour = now.hour {
//            let hour: Double = Double(currentHour)
//            let hoursTillMidnight = 24.0 - hour
//            secondsDisabled = 60.0 * 60 * hoursTillMidnight
//        }
//
//        Timer.scheduledTimer(timeInterval: secondsDisabled, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
    }
    
    @objc func enableButton() {
        checkInButton.isEnabled = true
        print("button enabled again!")
    }
    
    @IBAction func checkInButtonPressed(_ sender: UIButton) {
        
    }
    
    // MARK: (Chloe) To-Do: Web Routing
    @IBAction func scheduleTestButtonPressed(_ sender: UIButton) {
        
    }
        
    @IBAction func unwindSegue( _ seg: UIStoryboardSegue) {
        
    }
    


}

