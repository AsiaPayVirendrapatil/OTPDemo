//
//  Emvco3dsFramework.swift
//  emvco3ds-ios-framework


import UIKit

public class Emvco3dsFramework: NSObject {
    
    public static var manager = Emvco3dsFrameworkManager()
    public static var bundle = Bundle(identifier: "ul.emvco3ds-ios-framework")
    
    // True once the run button has been clicked and there are still test cases to fetch
    public static var isFetchingTestcases : Bool = false
    
    // False at the start of running a test case, True once notified through the result output view
    public static var isCurrentTestcaseFinished : Bool = false
    
    public static let root  = ProjectViewController(nibName:"ProjectViewController",bundle:Emvco3dsFramework.bundle)
    
    public static var navigationController: UINavigationController?
    
    public static var ultsFactory: ults_Factory?
    
    internal static var resultsViewController : TestCaseResultViewController? = nil
    
    public static var factory : ults_Factory{
        get{
            return ultsFactory!
        }
    }
    
    public static func setup(appName:String, factory: ults_Factory) {
        navigationController = setupNavigatorController(appName:appName)
        Log.delegate = manager
        ultsFactory = factory
    }
    
    private static func setupNavigatorController( appName: String) -> UINavigationController{
        let navigationController = UINavigationController(rootViewController: root)
        let navBar = navigationController.navigationBar
        navBar.topItem!.title =  appName
        navBar.barTintColor = UIColor(red: 0.0, green: 0.45, blue: 0.52, alpha: 1.0)
        let font = UIFont(name:"Arial", size: 18)!
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName:font, NSForegroundColorAttributeName:UIColor.white]
        navBar.tintColor = .white
        return navigationController
    }
    
    public static func clearLogResults(){
        manager.logResults.removeAll()
    }
}
