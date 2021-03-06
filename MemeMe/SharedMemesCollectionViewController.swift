//
//  SharedMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Online Training on 5/30/16.
//  Copyright © 2016 Mitch Salcido. All rights reserved.
//
/*
 About SharedMemesCollectionViewController.swift:
 
 VC provides functionality to present shared Memes in a collectionView. Cells can be selected which prompts
 a detail meme view using MemeViewController.
 */

import UIKit

class SharedMemesCollectionViewController: UICollectionViewController {

    // constant for number of cells/memes to display in each row in collectionView
    let CELLS_PER_ROW: CGFloat = 4.0
    
    // ref to app delegate..Meme store is defined in appDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create new Meme bbi
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(SharedMemesTableViewController.newMemeBbiPressed(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // show tabBar, reload collectionView
        tabBarController?.tabBar.isHidden = false
        collectionView?.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /*
         Upon layout, get flowLayout and set size of item...used to maintain same number of cells/row
         for all device orientations
         */
        
        // get flowLayout
        guard let flowLayout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        // get width of screen, divide by cell/row...subtract spacing/inset distance
        let width = UIScreen.main.bounds.width / CELLS_PER_ROW - 4.0
        flowLayout.itemSize = CGSize(width: width, height: width)
    }
    
    // MARK: - CollectionView DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellID", for: indexPath) as! SharedMemesCollectionViewCell
        
        let meme = appDelegate.memes[indexPath.row]
        cell.imageView.image = meme.memedImage
        return cell
    }

    // MARK: - CollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // cell selected. Navigate to MemeDetailVC
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        vc.memeIndex = indexPath.row

        // hide tab, push VC
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Launch Meme Editor
    func newMemeBbiPressed(_ sender: UIBarButtonItem?) {
        
        // create MemeEditor embedded in navController
        let vc = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        let nc = UINavigationController(rootViewController: vc)
        
        // animate presentation if invocation of this function was a result of newMemeBbi pressed "+"
        if let _ = sender {
            present(nc, animated: true, completion: nil)
        }
        else {
            // invocation as a result of no saved memes in viewDidLoad (e.g. initial app launch)
            present(nc, animated: false, completion: nil)
        }
    }
}
