//
//  ProductPageViewController.swift
//  JohnLewisPartnershipDishwasherApp
//
//  Created by TAE on 27/02/2017.
//  Copyright © 2017 TAE. All rights reserved.
//

import UIKit

class ProductPageViewController: UIViewController, UIPageViewControllerDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var productImageSliderView: UIView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var additionalServicesLabel: UILabel!
    @IBOutlet weak var productSpecTableView: UITableView!
    @IBOutlet weak var productScrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    
    // Initialize it right away here
    private var contentImages: [String] = []
    var productID:String!
    private var featuresName:[String] = []
    private var featuresValue:[String] = []
    var responseDictionary: [String: AnyObject]!
    var prductInformationParser:PrductInformationParser!
    
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight = 1200 as CGFloat
    // set up the session
    let session = URLSession(configuration: URLSessionConfiguration.default)
    override func viewDidLoad() {
        super.viewDidLoad()

        productSpecTableView.dataSource = self
        productSpecTableView.delegate = self
        
        showActivityIndicatory()
        
//        productScrollView.contentSize = CGSize(width: productScrollView.frame.size.width, height: scrollViewContentHeight)
//        productScrollView.delegate = self
//        productSpecTableView.delegate = self
//        productScrollView.bounces = false
//        productSpecTableView.bounces = false
//        productSpecTableView.isScrollEnabled = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCategoryCollection(productID: productID)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.invalidateAndCancel()
    }
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(itemIndex: 0)!
            let startingViewControllers = [firstController]
            pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.productImageSliderView.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
        
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.black
        appearance.currentPageIndicatorTintColor = UIColor.black
        appearance.backgroundColor = UIColor.darkGray
    }

    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        let itemController = viewController as! PageItemViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemIndex: itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemViewController
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemIndex: itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> PageItemViewController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemController") as! PageItemViewController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = "https:" + contentImages[itemIndex]
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    private func fetchCategoryCollection(productID: String) {
        // Fetch products from the API.
        WebServices.sharedInstance.HTTPRequest(session:session, url: WebServicesHelper.getProductPage(productID: productID)) { responseDictionary in
            self.responseDictionary = responseDictionary
            
            self.prductInformationParser = PrductInformationParser(with: responseDictionary)
            
           // DispatchQueue.main.async(){
                self.updateView()
          //  }
            
            // Stop animating the refresh control.
        }
    }
    
    
    

    
    func updateView(){

        self.title = prductInformationParser.getTitle()

        DispatchQueue.main.async(){

        self.productPriceLabel.text = "£" + self.prductInformationParser.getNowPrice()
        }
        
        DispatchQueue.main.async(){

        self.contentImages = self.prductInformationParser.getURLs()
        self.pageViewController?.reloadInputViews()
        self.createPageViewController()
        self.setupPageControl()
        }

        
        DispatchQueue.main.async(){

        self.additionalServicesLabel.text = self.prductInformationParser.getServices()
        }
        
        DispatchQueue.main.async(){

        self.offerLabel.text = self.prductInformationParser.getdisplaySpecialOffer()
        }
        
        getFeatures()
        
        DispatchQueue.main.async(){

        self.productSpecTableView.reloadData()
        }
        
        
        removeActivityIndicatory()
    }
    
   
    func getProductInformation() -> String {
        
        if prductInformationParser == nil{
            return ""
        }
        
        return prductInformationParser.getProductInformation()
    }

    func getProductCode() -> String {
        if prductInformationParser == nil{
            return ""
        }
        
        return prductInformationParser.getProductCode()
    }
    
    
    
    func getFeatures(){
        guard let details = responseDictionary["details"] as? [String:AnyObject] else {
            print("Could not get todo title from JSON")
            return
        }
        
        guard let features = details["features"] as? [[String:AnyObject]] else {
            print("Could not get todo title from JSON")
            return
        }
        
        let featuresDict = features[0] as [String:AnyObject]
        
        
        guard let attributesArr = featuresDict["attributes"] as? [[String:AnyObject]] else {
            print("Could not get todo title from JSON")
            return
        }
        
        
        for attribute in attributesArr{
            featuresName.append((attribute["name"] as? String)!)
            featuresValue.append((attribute["value"] as? String)!)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + featuresName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInformationCell", for: indexPath) as! ProductInformationTableViewCell
            cell.productDecLabel.attributedText = getProductInformation().htmlAttributedString()
            cell.productCodeLabel.text = "Product code:" + getProductCode()
            return cell

        }  else if  (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSpecCell", for: indexPath) as! ProductSpecTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSpecDetailCell", for: indexPath) as! ProductSpecDetailTableViewCell
            cell.detailNameLabel.text = featuresName[indexPath.row - 2]
            cell.detailValueLabel.text = featuresValue[indexPath.row - 2]
            return cell
        }


    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0){
            return getProductInformation().htmlAttributedString()!.heightWithConstrainedWidth(width: 720.0) + 150
        }
        else if  (indexPath.row == 1)
        {
            return 90
        }
            
        else
        {
            return 55
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func showActivityIndicatory() {

        activityIndicator.startAnimating()
    }

    func removeActivityIndicatory() {
        activityIndicator.stopAnimating()

        activityIndicator.hidesWhenStopped = true
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
