//  MainView.swift
//  Created by Virendra patil on 23/09/19.

import UIKit
//import Contacts
//import ContactsUI
//import CoreLocation

class MainView: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    @IBOutlet weak var menubutton: UIBarButtonItem!
    @IBOutlet weak var mybalanceview: UIView!
    @IBOutlet weak var sendrequestmoneyview: UIView!
    @IBOutlet weak var MoneytokenView: UIView!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var cardstabbtn: UITabBarItem!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var addbanner: UIView!
    var arrImages : [UIImage] = []
    var imagename : NSMutableArray = []
    var namedata : NSMutableArray = []
    //var locationManager     = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
         arrImages = [UIImage(named: "a"), UIImage(named: "b"), UIImage(named: "c"),UIImage(named: "d"),UIImage(named: "e"),UIImage(named: "f")] as! [UIImage]

        //`contacts` Contains all details of Phone Contacts
        //let contacts = self.getContactFromCNContact()
//        for contact in contacts {
//
//            print(contact.middleName)
//            print(contact.familyName)
//            print(contact.givenName)
//        }
        imagename = ["a","b","c","d","e","f"]

        modelclass().customActivityIndicatory(self.view, startAnimate: false)
        //self.adbanner.reloadData()
        //self.carouselCurrentItemIndexDidChange(self.adbanner)
        
        mybalanceview.addUIViewborder(color: .lightGray, cornerradius: 8, borderwidth: 1)
        sendrequestmoneyview.addUIViewborder(color: .lightGray, cornerradius: 8, borderwidth: 1)
        MoneytokenView.addUIViewborder(color: .lightGray, cornerradius: 8, borderwidth: 1)

        namedata = ["issac","Rajesh","Virendra Patil","Victor","Shriniwas","Jo Chan","Dhawal","Priyanka","Sanjay"]
        
        if revealViewController() != nil {
            menubutton.target = revealViewController()
            menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 190
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //getUserCurrentLocation()
    }
    
    override func viewDidLayoutSubviews() {
        self.loadScrollView()
    }
    
    func loadScrollView() {
        let pageCount = arrImages.count
        scrollview.frame = view.bounds
        scrollview.delegate = self
        scrollview.backgroundColor = UIColor.clear
        scrollview.isPagingEnabled = true
        scrollview.showsHorizontalScrollIndicator = true
        scrollview.showsVerticalScrollIndicator = false
        
        pagecontrol.numberOfPages = pageCount
        pagecontrol.currentPage = 0
        
        for i in (0..<pageCount) {
            
            let imageView = UIImageView()
            imageView.frame = CGRect(x: i * Int(addbanner.frame.size.width) , y: 0 , width:
                Int(addbanner.frame.size.width) , height: 160)
            
            imageView.image = arrImages[i]
            self.scrollview.addSubview(imageView)
        }
        
        let width1 = (Float(arrImages.count) * Float(addbanner.frame.size.width))
        scrollview.contentSize = CGSize(width: CGFloat(width1), height: addbanner.frame.size.height)
        
        //self.view.addSubview(scrollview)
        self.pagecontrol.addTarget(self, action: #selector(self.pageChanged(sender:)), for: UIControl.Event.valueChanged)
        
        scrollview.addSubview(pagecontrol)
        //self.view.addSubview(pagecontrol)
        addbanner.addSubview(scrollview)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pagecontrol.currentPage = Int(pageNumber)
        //print(pageNumber)
    }

    @objc func pageChanged(sender:AnyObject)
    {
        let xVal = CGFloat(pagecontrol.currentPage) * scrollview.frame.size.width
        scrollview.setContentOffset(CGPoint(x: xVal, y: 0), animated: true)
    }
    /*
    func getContactFromCNContact() -> [CNContact] {
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactGivenNameKey,
            CNContactMiddleNameKey,
            CNContactFamilyNameKey,
            CNContactEmailAddressesKey,
            ] as [Any]
        
        //Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        var results: [CNContact] = []
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
                
            } catch {
                print("Error fetching results for container")
            }
        }
        return results
    }
     */
    
    @IBAction func notifition_btnClick(_ sender: Any) {
        let notificationview = storyboard?.instantiateViewController(withIdentifier: "NotificationView")  as! NotificationView
        self.navigationController?.pushViewController(notificationview, animated: true)
    }

    @IBAction func withdrawcashbtnClick(_ sender: Any) {
        let withdrawmoney = storyboard?.instantiateViewController(withIdentifier: "WithdrawMoneyView")  as! WithdrawMoneyView
        self.navigationController?.pushViewController(withdrawmoney, animated: true)
    }

    @IBAction func AddmoneybtnClick(_ sender: Any) {
        let addmoney = storyboard?.instantiateViewController(withIdentifier: "AddMoneyView")  as! AddMoneyView
        self.navigationController?.pushViewController(addmoney, animated: true)
    }
    
    @IBAction func AddRequestbtnclick(_ sender: Any) {

    }
    
    @IBAction func GeneratenewbtnClick(_ sender: Any) {
     
        let newtoken = storyboard?.instantiateViewController(withIdentifier: "GeneratenewTokenView")  as! GeneratenewTokenView
        self.navigationController?.pushViewController(newtoken, animated: true)
    }
    
    @IBAction func viewpendingbtnClick(_ sender: Any) {
        
        let newqrtoken = storyboard?.instantiateViewController(withIdentifier: "GenerateQRtokenView")  as! GenerateQRtokenView
        self.navigationController?.pushViewController(newqrtoken, animated: true)
    }

    //MARK:- -----------------------> CollectionView DataSource and Delegate Methods <-------------------------
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return namedata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier: String = "MenuCollectionCell"
        let cell: MenuCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as!
        MenuCollectionCell
        cell.backview.addUIViewborder(color: .lightGray, cornerradius: 8, borderwidth: 1)
        cell.bankimageview.layer.cornerRadius = 20
        cell.bankimageview.layer.borderWidth = 1
        cell.bankimageview.layer.borderColor = UIColor.lightGray.cgColor
        
        if indexPath.row == 0 {
            cell.banknametext.text = ""
            cell.bankimageview.image = UIImage.init(named: "icon_add")
        }else {
            cell.banknametext.text = (namedata.object(at: indexPath.row) as! String)
            cell.bankimageview.image = UIImage.init(named: "icons8-profile-48")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let addmoney = storyboard?.instantiateViewController(withIdentifier: "ShowContactview")  as! ShowContactview
            self.navigationController?.pushViewController(addmoney, animated: true)
        }
    }
    /*
    // MARK:- Get User Current Location
    func getUserCurrentLocation() {
        
        let status  = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        if status == .denied || status == .restricted {
            self.showAlertView(message: "Please Enable Location Services in Settings")
            return
        }
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        //MARK -  Get current user location
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
        }
    }
    
    // MARK:- Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError \(error)")
    }
    */
    // MARK:- Show AlertView
    func showAlertView(message : String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
