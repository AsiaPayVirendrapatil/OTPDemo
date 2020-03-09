//
//  Emvco3dsFramework.swift
//  emvco3ds-ios-framework


import UIKit

public class Emvco3dsFramework: NSObject {
    
    @objc public static var isRegressionTest : Bool = false
    
    @objc public static var manager = Emvco3dsFrameworkManager()
    @objc public static var bundle = Bundle(identifier: "ul.emvco3ds-ios-framework")
    
    // True once the run button has been clicked and there are still test cases to fetch
    @objc public static var isFetchingTestcases : Bool = false
    
    // False at the start of running a test case, True once notified through the result output view
    @objc public static var isCurrentTestcaseFinished : Bool = false
    
    @objc public static let root  = ProjectViewController(nibName:"ProjectViewController",bundle:Emvco3dsFramework.bundle)
    
    @objc public static var navigationController: UINavigationController?
    
    public static var ultsFactory: ults_Factory?
    
    @objc internal static var resultsViewController : TestCaseResultViewController? = nil
    
    public static var factory : ults_Factory{
        get{
            return ultsFactory!
        }
    }
    
    @objc public static func setContinuousFetching(value: Bool){
        isRegressionTest = value
        UserDefaults.standard.set(true, forKey: SettingsBundleHelper.SettingsBundleKeys.autoSubmitChallenges)
        root.setContinuousFetching(value: value)
    }
    
    public static func setup(appName:String, factory: ults_Factory) {
        navigationController = setupNavigatorController(appName:appName)
        Log.delegate = manager
        ultsFactory = factory
        
        let userDefaultsDefaults = [
            SettingsBundleHelper.SettingsBundleKeys.autoSubmitChallenges : true
        ]
        UserDefaults.standard.register(defaults:userDefaultsDefaults)
    }
    
    private static func setupNavigatorController( appName: String) -> UINavigationController{
        let navigationController = UINavigationController(rootViewController: root)
        let navBar = navigationController.navigationBar
        navBar.topItem!.title =  appName
        navBar.barTintColor = UIColor(red: 0.0, green: 0.45, blue: 0.52, alpha: 1.0)
        let font = UIFont(name:"Arial", size: 18)!
        UINavigationBar.appearance().titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.font.rawValue:font, NSAttributedString.Key.foregroundColor.rawValue:UIColor.white])
        navBar.tintColor = .white
        return navigationController
    }
    
    @objc public static func clearLogResults(){
        manager.logResults.removeAll()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
