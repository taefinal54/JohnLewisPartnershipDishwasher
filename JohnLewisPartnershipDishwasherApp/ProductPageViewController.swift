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
    
    private var productDectLabelText:String = ""
    private var productCodeLabelText:String = ""
    private var featuresName:[String] = []
    private var featuresValue:[String] = []
    var responseDictionary: [String: AnyObject]!
    
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight = 1200 as CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productSpecTableView.dataSource = self
        productSpecTableView.delegate = self
        
        showActivityIndicatory()
        fetchCategoryCollection()
        
        
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
    
    private func fetchCategoryCollection() {
        // Fetch products from the API.
        WebServices.sharedInstance.HTTPRequest(url: WebServicesHelper.getProductPage(productID: "1913267")) { responseDictionary in
            self.responseDictionary = responseDictionary
           // DispatchQueue.main.async(){
                self.updateView()
          //  }
            
            // Stop animating the refresh control.
        }
    }
    
    func updateView(){
        guard let todoTitle = responseDictionary["price"] as? [String:AnyObject] else {
            print("Could not get todo title from JSON")
            return
        }
        
        guard let nowPrice = todoTitle["now"] as? String else {
            print("Could not get todo title from JSON")
            return
        }

        DispatchQueue.main.async(){

        self.productPriceLabel.text = "£" + nowPrice
        }

        guard let skus = responseDictionary["skus"] as? [[String:AnyObject]] else {
            print("Could not get todo title from JSON")
            return
        }
        
        let media = skus[0]["media"] as? [String:AnyObject]
        guard let images = media?["images"] as? [String:AnyObject] else {
            print("Could not get todo title from JSON")
            return
        }
        
        guard let urls = images["urls"] as? [String] else {
            print("Could not get todo title from JSON")
            return
        }
        
        DispatchQueue.main.async(){

        self.contentImages = urls
        self.pageViewController?.reloadInputViews()
        self.createPageViewController()
        self.setupPageControl()
        }
        guard let additionalServices = responseDictionary["additionalServices"] as? [String:AnyObject] else {
            print("Could not get todo title from JSON")
            return
        }
        
        guard let includedServices = additionalServices["includedServices"] as? [String] else {
            print("Could not get todo title from JSON")
            return
        }
        
        let servicesStr = includedServices[0]
        
        DispatchQueue.main.async(){

        self.additionalServicesLabel.text = servicesStr
        }
        guard let displaySpecialOffer = responseDictionary["displaySpecialOffer"] as? String else {
            print("Could not get todo title from JSON")
            return
        }
        
        DispatchQueue.main.async(){

        self.offerLabel.text = displaySpecialOffer
        }
        guard let details = responseDictionary["details"] as? [String:AnyObject] else {
            print("Could not get todo title from JSON")
            return
        }
        
        guard let productInformation = details["productInformation"] as? String else {
            print("Could not get todo title from JSON")
            return
        }
        
        productDectLabelText = productInformation
        
        guard let code = responseDictionary["code"] as? String else {
            print("Could not get todo title from JSON")
            return
        }
        
        productCodeLabelText = code
        
        
        
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
        
        

        
        DispatchQueue.main.async(){

        self.productSpecTableView.reloadData()
        }
        
        
        removeActivityIndicatory()
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + featuresName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInformationCell", for: indexPath) as! ProductInformationTableViewCell
            cell.productDecLabel.attributedText = productDectLabelText.htmlAttributedString()
            cell.productCodeLabel.text = "Product code:" + productCodeLabelText
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
            return productDectLabelText.htmlAttributedString()!.heightWithConstrainedWidth(width: 720.0) + 150
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
