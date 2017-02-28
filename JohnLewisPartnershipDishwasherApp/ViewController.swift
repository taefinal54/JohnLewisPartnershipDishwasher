//
//  ViewController.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 24/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionViewArray: [ProductGrid] = []
    fileprivate let reuseIdentifier = "ProductGridCell"

    @IBOutlet weak var productGridCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchCategoryCollection()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductGridCollectionViewCell
        cell.productGridTitle.text = collectionViewArray[indexPath.row].title
        cell.productGridPrice.text = collectionViewArray[indexPath.row].price;

        cell.productGridImageView.contentMode = UIViewContentMode.scaleAspectFit;
        cell.productGridImageView.image = UIImage(named: "placeholder.jpg")

        
        // Move to a background thread to do some long running work
        DispatchQueue.global().async {
            Alamofire.request(self.collectionViewArray[indexPath.row].image, method: .get)
                .response { response  in
                    if let error = response.error{
                        print(error)
                        return
                    }else{
                        // Bounce back to the main thread to update the UI
                        //                        DispatchQueue.main.async {
                        //           let image:UIImage = UIImage(data: response.data!, scale:1)!.complexReoveBackground()
                        cell.productGridImageView.image = UIImage(data: response.data!, scale:1)//image//
                        //                        }
                    }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {

        
     //   if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
            
        return CGSize(width: self.productGridCollectionView.frame.size.width / 3, height: self.productGridCollectionView.frame.size.width / 2)

    //    } else if UIDevice.current.orientation == UIDeviceOrientation.portrait || UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
            
     //       return CGSize(width: self.productGridCollectionView.frame.size.width / 4, height: self.productGridCollectionView.frame.size.height / 2)

       // }
        
        //return CGSize(width: self.productGridCollectionView.frame.size.width / 3, height: self.productGridCollectionView.frame.size.height / 2)
        
    }


    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            performSegue(withIdentifier: "PageDetailSegue", sender: self)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {

        if identifier == "PageDetailSegue"{
            
        }
    }
    
    func rotate(){
    //    relodeColletionView()
    }
    
    private func fetchCategoryCollection() {
        // Fetch products from the API.
        WebServices.sharedInstance.getProductGrid(permalink: WebServicesHelper.getProductGrid(productType: "dishwasher")) { collectionViewArray in
            self.collectionViewArray = collectionViewArray
            // Save and reload the table.
            self.relodeColletionView()
            
            // Stop animating the refresh control.
        }
    }
    
    func relodeColletionView() -> Void {
        productGridCollectionView.reloadData()
        
    }
    
    
    
}

