//
//  ProjectViewController.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

public class ProjectViewController: UIViewController, TestCaseDownloaderProtocol {

    @IBOutlet weak var environmentLabel: UILabel!
    @IBOutlet weak var apiKeyLabel: UILabel!
    @IBOutlet weak var sdkVersionLabel: UILabel!
    @IBOutlet weak var runAllButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var autoSubmitChallenges: UISwitch!
    
    @IBAction func copyButtonClicked(_ sender: Any) {
        UIPasteboard.general.string = "Api key: \(ConfigurationManager.API_KEY) Environment: \(ConfigurationManager.ENVIRONMENT_NAME)"
        displayMessage(textMessage: "The project information has been copied to the clipboard.")
    }
    
    @IBAction func deleteAllButtonClicked(_ sender: Any) {
        spinnerView = displaySpinner(onView: self.view)
        TCFetcher(delegate: self).deleteAllTestCases(apiKey : ConfigurationManager.API_KEY)
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        if (self.autoSubmitChallenges.isOn) {
            UserDefaults.standard.set(true, forKey: SettingsBundleHelper.SettingsBundleKeys.autoSubmitChallenges)
        } else {
            UserDefaults.standard.set(false, forKey: SettingsBundleHelper.SettingsBundleKeys.autoSubmitChallenges)
        }
    }
    
    @IBAction func runAllButtonClicked(_ sender: Any) {
        if (!Emvco3dsFramework.isFetchingTestcases){
            Emvco3dsFramework.isFetchingTestcases = true
            self.fetchTestcase()
        }
        else{
            Emvco3dsFramework.isFetchingTestcases = false
        }
        
        self.showRunTestCaseButtonLabel()
    }
    
    private let testCaseRunner = TestCaseRunner.instance
    private var spinnerView : UIView? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        displayVersionInfo()
        displayHelpButton()
        updateAutoSubmitChallenges()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
         showRunTestCaseButtonLabel()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        Log.i(object: self, message: "Project view did appear")
       
        if (!Emvco3dsFramework.isCurrentTestcaseFinished){
            return
        }
       
        if (Emvco3dsFramework.isFetchingTestcases){
            self.fetchTestcase()
        }
    }
    
    private func showRunTestCaseButtonLabel(){
        if (Emvco3dsFramework.isFetchingTestcases){
            runAllButton.titleLabel?.text = "Stop running"
        }
        else{
            runAllButton.titleLabel?.text = "Run all test cases"
        }
    }
    
    private func displayVersionInfo(){
        apiKeyLabel.text = ConfigurationManager.API_KEY
        environmentLabel.text = ConfigurationManager.ENVIRONMENT_NAME
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        self.title = "\(UIApplication.shared.appName) v\(version)"
        
        let sdkVersion = TransactionManager.instance.getSdkVersion()
        Log.i(object: self, message: "Reference App v\(version), build: \(build) sdk version: \(sdkVersion)")
        sdkVersionLabel.text = sdkVersion
    }
    
    private func displayHelpButton(){
        let helpButton: UIBarButtonItem = UIBarButtonItem(title: "?", style: .done, target: self, action: #selector(helpButtonClicked))
        helpButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = helpButton
    }
    
    func helpButtonClicked(sender: AnyObject){
        let aboutViewController = AboutViewController(nibName:"AboutViewController",bundle:Emvco3dsFramework.bundle)
        self.navigationController?.pushViewController(aboutViewController, animated: true)
    }
    
    private func fetchTestcase(){
        Log.i(object: self, message: "Fetch next testcase")
        spinnerView = displaySpinner(onView: self.view)
        TCFetcher(delegate: self).fetch(apiKey : ConfigurationManager.API_KEY)
    }
    
    private func runTestcase(tcMessage: TcMessage){
        let message = tcMessage.header?.testCaseId
        if (message != nil){
            Log.i(object: self, message: "Run test case \(message!)")
        }
        
        TestCaseRunner.instance.tcMessage = tcMessage
        MainNavigationController.screenshotMessage =
            ScreenshotMessage.formMessageOutOfTcMessage(tcMessage: TestCaseRunner.instance.tcMessage!)
        TestCaseRunner.instance.paIdx = 0;
        
        Emvco3dsFramework.resultsViewController = TestCaseResultViewController(nibName:"TestCaseResultViewController",bundle:Emvco3dsFramework.bundle)
        Emvco3dsFramework.root.navigationController?.pushViewController(Emvco3dsFramework.resultsViewController!, animated: true)
        Emvco3dsFramework.isCurrentTestcaseFinished = false
        Log.i(object: self, message: "testCaseRunner start transaction")
        testCaseRunner.startTransaction(uiViewController: self)
    }
    
    // MARK: TestCaseDownloaderProtocol
    
    func onConfigurationError(){
        removeSpinner(spinner: spinnerView!)
        displayMessage(textMessage: "Configuration error. Check the log for details.")
    }
    
    func onNetworkError(){
        removeSpinner(spinner: spinnerView!)
        displayMessage(textMessage: "Network error. Check the log for details.")
    }
    
    func onTcDeserializationError(){
        removeSpinner(spinner: spinnerView!)
        Log.e(object: self, message: "onTcDeserializationError")
    }
    
    func onSuccessfullyFetchedTcMessage(tcMessage: TcMessage){
        removeSpinner(spinner: spinnerView!)
        Log.i(object: self, message: "Successfully fetched TcMessage")
        
        if (tcMessage.header!.isFound! && tcMessage.pAReqFields != nil) {
            runTestcase(tcMessage: tcMessage)
        }
        else{
            displayMessage(textMessage: "There are no more test cases.")
            Emvco3dsFramework.isFetchingTestcases = false
            showRunTestCaseButtonLabel()
        }
    }
  
    func onSuccessfullyDeleteAllTestCases(){
        removeSpinner(spinner: spinnerView!)
        displayMessage(textMessage: "All test cases are removed from the queue.")
    }
    
    func onError(message : String){
        removeSpinner(spinner: spinnerView!)
        displayMessage(textMessage: "Error. Check the log for details.")
    }
    
    func updateAutoSubmitChallenges() {
        if (UserDefaults.standard.bool(forKey: SettingsBundleHelper.SettingsBundleKeys.autoSubmitChallenges)) {
            self.autoSubmitChallenges.setOn(true, animated: false)
        } else {
            self.autoSubmitChallenges.setOn(false, animated: false)
        }
    }
}
