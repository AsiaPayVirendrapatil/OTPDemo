//
//  Emvco3dsFramework.swift
//  emvco3ds-ios-framework


import UIKit
import threedsnew

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
    
//<<<<<<< HEAD
    @objc public static func setContinuousFetching(value: Bool){
//=======
//    public static func setContinuousFetching(value: Bool){
//>>>>>>> master
        
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

public class SampleFactory: ults_Factory {
    
    public func newToolbarCustomization() -> ults_ToolbarCustomization {
        return ToolbarCustomization("Helvetica Neue", "Red", 10, "blue", "Title")
        
    }
    
    
    public func newAuthenticationRequestParameters(_ sdkTransactionID: String, _ deviceData: String, _ sdkEphemeralPublicKey: String, _ sdkAppID: String, _ sdkReferenceNumber: String, _ messageVersion: String) throws -> ults_AuthenticationRequestParameters {
        
        let ret = AuthenticationRequestParameters()
        ret.sdkTransactionID = sdkTransactionID
        ret.deviceData = deviceData
        ret.sdkEphemeralPublicKey = sdkEphemeralPublicKey
        ret.sdkAppID = sdkAppID
        ret.messageVersion = messageVersion
        
        return ret
    }
    
    public func newRuntimeErrorEvent(_ errorCode: String?, _ errorMessage: String) -> ults_RuntimeErrorEvent {
        return newRuntimeErrorEvent(errorCode,errorMessage)
    }
    
    public func newProtolErrorEvent(_ sdkTransactionID: String, _ errorMessage: ults_ErrorMessage) -> ults_ProtocolErrorEvent {
        return ults_ProtocolErrorEvent(sdkTransactionID, errorMessage as! ErrorMessage)
    }
    
    public func newCompletionEvent(_ sdkTransactionID: String, _ transactionStatus: String) -> ults_CompletionEvent {
        return CompletionEvent(sdkTransactionID,transactionStatus)
    }
    
   public func newErrorMessage(_ transactionID: String, _ errorCode: String, _ errorDescription: String, _ errorDetail: String) -> ults_ErrorMessage {
        return ErrorMessage(transactionID,errorCode,errorDescription,errorDetail)
    }
    
   public func newWarning(_ id: String, _ message: String, _ severity: ults_Severity) -> ults_Warning {
        return Warning(id, message, severity)
    }
    
   public func newChallengeParameters() -> ults_ChallengeParameters {
    return newChallengeParameters("","","","")
    }
    
   public func newThreeDS2Service() -> ults_ThreeDS2Service {
    return newThreeDS2Service()
    }
    
   public func newConfigParameters() -> ults_ConfigParameters {
    return newConfigParameters()
    }
    
   public func newUiCustomization() -> ults_UiCustomization {
    return newUiCustomization()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
