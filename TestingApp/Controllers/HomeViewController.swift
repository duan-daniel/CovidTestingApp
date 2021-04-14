//
//  ViewController.swift
//  TestingApp
//
//  Created by Daniel Duan on 3/28/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    var avatar = Avatar()

    // IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarTestingCount: UILabel!
    @IBOutlet weak var avatarDescription: UILabel!
    
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var scheduleTestButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up views
        setUpViews()
        
        // update avatar description
        updateAvatar()
    }
    
    func setUpViews() {
        checkInButton.layer.cornerRadius = 15
        scheduleTestButton.layer.cornerRadius = 15
    }
    
    func updateAvatar() {
        
        if (avatar.testingCount < 2) {
            let saplingImg = UIImage(named: "Sapling")
            avatar.imageView.image = saplingImg
            avatar.description = "Your plant is a Sapling."
        } else if (avatar.testingCount < 4) {
            let leafletImg = UIImage(named: "Leaflet")
            avatar.imageView.image = leafletImg
            avatar.description = "Your plant is a Leaflet."
        } else if (avatar.testingCount < 6) {
            let babyTreeImg = UIImage(named: "BabyTree")
            avatar.imageView.image = babyTreeImg
            avatar.description = "Your plant is a Baby Tree."
        } else {
            let treeImg = UIImage(named: "Tree")
            avatar.imageView.image = treeImg
            avatar.description = "Your plant is a Tree!"
        }
        
        if (avatar.testingCount == 1) {
            avatar.testingCountDescription = "Wow! You've been tested \(avatar.testingCount) time!"
        } else {
            avatar.testingCountDescription = "Wow! You've been tested \(avatar.testingCount) times!"
        }

        avatarImageView.image = avatar.imageView.image
        avatarDescription.text = avatar.description
        avatarTestingCount.text = avatar.testingCountDescription
    }
    
    
    @IBAction func checkInButtonPressed(_ sender: UIButton) {
        
        avatar.testingCount = avatar.testingCount + 1
        updateAvatar()
    }
    
    @IBAction func scheduleTestButtonPressed(_ sender: UIButton) {
        
    }
    


}

