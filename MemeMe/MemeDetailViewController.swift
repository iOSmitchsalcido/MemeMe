//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Online Training on 5/30/16.
//  Copyright © 2016 Mitch Salcido. All rights reserved.
//
/*
 About MemeDetailViewController.swift:
 
 VC provides functionality to view a Meme in detail. Also includes edit button to delete or edit the meme
 */

import UIKit

class MemeDetailViewController: UIViewController {

    // ref to app delegate..Meme store is defined in appDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // ref to index of Meme being view
    var memeIndex: Int?
    
    // ref to view objects
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view title
        title = "Meme"
        
        // test for valid index, grab meme and place image in view
        if let index = memeIndex {
            let meme = appDelegate.memes[index]
            imageView.image = meme.memedImage
        }
        
        // add trash bbi on right navbar to delete Meme
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                            target: self,
                                                            action: #selector(MemeDetailViewController.deleteMeme(_:)))
    }
    
    // MARK: Button Actions
    func deleteMeme(_ sender: UIBarButtonItem) {
        
        /*
         Delete Meme button pressed
         Create a Alert with buttons to Cancel or proceed with Meme deletion
         */
        
        let ac = UIAlertController(title: "Delete Meme ?",
                                   message: "Continuing will remove Meme from saved Memes",
                                   preferredStyle: .actionSheet)
        
        // create Cancel and Delete actions for Alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete",
                                         style: .destructive){(action) -> Void in
                                            
                                            // completeion
                                            // remove from memes, pop vc
                                            if let index = self.memeIndex {
                                                self.appDelegate.memes.remove(at: index)
                                                let _ = self.navigationController?.popViewController(animated: true)
                                            }
        }
        
        // add actions and show
        ac.addAction(cancelAction)
        ac.addAction(deleteAction)
        present(ac, animated: true, completion: nil)
    }
}
