//
//  TestViewController.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 27/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var superView: UIView!
    var pView: UIView!
    var landScapeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pView = PView(frame: CGRect(x: superView.frame.origin.x, y: superView.frame.origin.y, width: superView.frame.size.height, height:superView.frame.size.width))//(frame: superView.frame)
        landScapeView = LandScapeView(frame: superView.frame)

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    //    rotate()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
    }
    func rotate(){
        //    relodeColletionView()
//        
//        for view in self.view.subviews {
//            view.removeFromSuperview()
//        }
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
            

            landScapeView?.removeFromSuperview()
            
            superView.addSubview(pView)
        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait || UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
        
            pView?.removeFromSuperview()
            
            superView.addSubview(landScapeView)

         }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
