//
//  DetailViewController.swift
//  Project1
//
//  Created by Daniel Loureda Arteaga on 2/6/16.
//  Copyright © 2016 Daniel Loureda Arteaga. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {

    
    @IBOutlet weak var detailImageView: UIImageView!
    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        self.detailImageView?.image = UIImage(named: self.detailItem!)
        self.title? = self.detailItem!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(shareTapped))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.hidesBarsOnTap = false
    }
    
    func shareTapped() {
        let alert = UIAlertController(title: "How do you want to share?", message: "Select one", preferredStyle: .Alert)
        let twitterAction = UIAlertAction(title: "Twitter", style: .Default) { (UIAlertAction) in
            self.presentViewControllerToShareOn(SLServiceTypeTwitter)
        }
        let facebookAction = UIAlertAction(title: "Facebook", style: .Default) { (UIAlertAction) in
            self.presentViewControllerToShareOn(SLServiceTypeFacebook)
        }
        let otherAction = UIAlertAction(title: "Other", style: .Default) { (UIAlertAction) in
            self.presentShareViewController()
        }
        alert.addAction(twitterAction)
        alert.addAction(facebookAction)
        alert.addAction(otherAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentShareViewController() {
        let vc = UIActivityViewController(activityItems: [detailImageView.image!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func presentViewControllerToShareOn(whereToShare : String) {
        let vc = SLComposeViewController(forServiceType: whereToShare)
        vc.setInitialText("Look at this great picture!")
        vc.addImage(detailImageView.image!)
        vc.addURL(NSURL(string: "http://www.photolib.noaa.gov/nssl"))
        presentViewController(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

