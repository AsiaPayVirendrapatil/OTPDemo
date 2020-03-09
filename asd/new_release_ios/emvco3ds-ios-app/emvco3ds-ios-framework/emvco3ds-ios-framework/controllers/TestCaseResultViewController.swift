//  TestCaseResultViewController.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

class TestCaseResultViewController: UIViewController, UITableViewDataSource, TestManagementNotifierProtocol, CardholderNotifierProtocol{

    @IBOutlet weak var testcaseTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let assetLedGray = "led-gray-black"
    private let assetLedGreen = "led-green-black"
    private let resultRowHeight: CGFloat = 60.0
    private let testCaseRunner = TestCaseRunner.instance
    private var tmNotifier : TMNotifier?
    private var testResults : [TestResult] = [TestResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "TestCaseResultTableViewCell", bundle: Emvco3dsFramework.bundle), forCellReuseIdentifier: "TestCaseCell")
        self.tableView.rowHeight = resultRowHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let testCaseId = self.testCaseRunner.tcMessage?.header!.testCaseId
        testcaseTitleLabel.text = "Executing \(testCaseId ?? "")"
    }
    
    public func notify(){        
        if (initTmNotifier())
        {
            showResults()
            TransactionManager.sdkProgressDialog?.close()
            
            if (TransactionManager.instance.isChallengeTransaction!) {
                notifySdkStatus()
            } else {
                notifyTestManagementApi()
            }
        }
        else{
            TransactionManager.sdkProgressDialog?.close()
            finishCurrentTransaction()
        }
    }
    
    private func initTmNotifier() -> Bool{
        Log.i(object: self, message: "init tm notifier")
        self.tmNotifier = TMNotifier()
        
        let notifier = self.tmNotifier!
        
        if (self.testCaseRunner.tcMessage==nil){
            Log.e(object: self, message: "Can not init TmNotifier. tcMessage is nil.")
            return false
        }
        
        notifier.projectId = self.testCaseRunner.tcMessage?.header!.projectId
        notifier.sessionId = self.testCaseRunner.tcMessage?.header!.sessionId
        notifier.testCaseIds = [(self.testCaseRunner.tcMessage?.header!.testCaseId!)!]
        notifier.testCaseRunIdentifier = self.testCaseRunner.tcMessage?.header!.pAreqId
        notifier.testIterationId = self.testCaseRunner.tcMessage?.header!.testIterationId
        notifier.testPlanId = self.testCaseRunner.tcMessage?.header!.testPlanId
        
        return true
    }
    
    
    private func showResults(){
        ui {
            Emvco3dsFramework.manager.logResults.forEach({ (logMessage) in
                let testResult = TestResult(testResultString: logMessage.message, isChallengeTransaction: true)
                testResult.isSuccess = (logMessage.level == Log.screenLevel)
                self.testResults.append(testResult)
            })
            self.tableView.reloadData()
        }
    }
    
    private func addToResults(message: String){
        ui {
            let result = TestResult(testResultString: message, isChallengeTransaction: true)
            result.isSuccess = true
            self.testResults.append(result)
            self.tableView.reloadData()
        }
        Log.s(object: self, message: message)
    }
    
    private func clearResults(){
        ui {
            self.testResults.removeAll()
            self.tableView.reloadData()
        }
    }
    
    private func notifySdkStatus() {
        Log.i(object: self, message: "Notifying SDK Transaction Status.")
        CardholderNotifier(delegate: self).notify(pcrqMessage: TransactionManager.instance.psrqMessage!, projectId: TestCaseRunner.instance.projectId!)
    }
    
    private let delayToNotifyApiSec = 10
    
    private func notifyTestManagementApi() {
        let enabled = testCaseRunner.tcMessage?.header?.timeoutEnabled
        if (enabled != nil && enabled!) {
            Log.i(object: self, message: "delay n secs to notify tm-api ...")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delayToNotifyApiSec)) {
                TestManagementNotifier(delegate: self).notify(tmNotifier: self.tmNotifier!)
            }
        } else {
            TestManagementNotifier(delegate: self).notify(tmNotifier: self.tmNotifier!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: CardholderNotifierProtocol
    
    func onSuccessfullyCardholderServerNotified()
    {
        addToResults(message: "Card holder server successfully notified.")
        notifyTestManagementApi()
    }
    
    func onErrorCardholderServer(message: String)
    {
        addToResults(message: message)
        notifyTestManagementApi()
    }
    
    // MARK: TestManagementNotifierProtocol
    
    func onSuccessfullyNotified() {
        addToResults(message: "Test management notified successfully")
        finishCurrentTransaction()
    }
    
    func onError(message: String) {
        addToResults(message: message)
        finishCurrentTransaction()
    }
    
    private func finishCurrentTransaction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.ui{
                self.clearResults()
                TestCaseRunner.instance.tcMessage = nil
                TestCaseRunner.instance.paIdx = 0
                TestCaseRunner.instance.projectId = nil
                
                Emvco3dsFramework.clearLogResults()
                Emvco3dsFramework.isCurrentTestcaseFinished = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCaseCell", for: indexPath)
            as! TestCaseResultTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.label.text = testResults[indexPath.row].testResultString
        
        if (testResults[indexPath.row].isSuccess){
            cell.testCaseResultImage.image = UIImage(named: assetLedGreen)
        }
        else{
            cell.testCaseResultImage.image = UIImage(named: assetLedGray)
        }
        return cell
    }
}
