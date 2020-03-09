//
//  GlueDemo.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

class glue_ChallengeParameters: ults_ChallengeParameters {
    let cp = ChallengeParameters()
    
    func set3DSServerTransactionID(_ transactionID: String) {
        cp.threeDSServerTransactionID = transactionID
    }
    
    func setAcsTransactionID(_ transactionID: String) {
        cp.acsTransactionID = transactionID
    }
    
    func setAcsRefNumber(_ refNumber: String) {
        cp.acsRefNumber = refNumber
    }
    
    func setAcsSignedContent(_ signedContent: String) {
        cp.acsSignedContent = signedContent
    }
    
    func get3DSServerTransactionID() -> String {
        return cp.threeDSServerTransactionID
    }
    
    func getAcsTransactionID() -> String {
        return cp.acsTransactionID
    }
    
    func getAcsRefNumber() -> String {
        return cp.acsRefNumber
    }
    
    func getAcsSignedContent() -> String {
        return cp.acsSignedContent
    }
}

class glue_ChallegeStatusReceiver : ChallengeStatusReceiver {
    var csr: ults_ChallengeStatusReceiver
    var factory: ults_Factory
    
    init(_ factory : ults_Factory, _ orgCSR : ults_ChallengeStatusReceiver) {
        self.factory = factory
        self.csr = orgCSR
    }
    
    func completed(_ e: CompletionEvent) {
        let ee : glue_CompletionEvent = factory.newCompletionEvent(e.sdkTransactionID,e.transactionStatus) as! glue_CompletionEvent
        self.csr.completed(ee)
    }
    
    func cancelled() {
        self.csr.cancelled()
    }
    
    func timedout() {
        self.csr.timedout()
    }
    
    func protocolError(_ e: ProtocolErrorEvent) {
        
        let er : glue_ErrorMessage = factory.newErrorMessage(e.errorMessage.transactionID, e.errorMessage.errorCode, e.errorMessage.errorDescription, e.errorMessage.errorDetail) as! glue_ErrorMessage
        let ee = factory.newProtolErrorEvent(e.sdkTransactionID, er)
        let eee = ee as! glue_ProtocolErrorEvent
        self.csr.protocolError(eee)
    }
    
    func runtimeError(_ e: RuntimeErrorEvent) {
        
        let ee : glue_RuntimeErrorEvent = factory.newRuntimeErrorEvent(e.errorCode, e.errorMessage) as! glue_RuntimeErrorEvent
        self.csr.runtimeError(ee)
    }
}

class glue_Transaction: ults_Transaction
{
    var tr: Transaction
    var factory: ults_Factory

    init(_ factory: ults_Factory, _ srv: ThreeDS2Service, _ id: String, _ msg: String) throws  {
        tr = try srv.createTransaction(id, msg)
        self.factory = factory
    }
    
    func getAuthenticationRequestParameters() -> ults_AuthenticationRequestParameters {
        return glue_AuthenticationRequestParameters(tr.getAuthenticationRequestParameters())
    }
    
    func doChallenge(_ applicationContext: ults_Context?, _ challengeParameters: ults_ChallengeParameters, _ challengeStatusReceiver:
        ults_ChallengeStatusReceiver, _ timeOut: Int) throws {
        
        let cp: glue_ChallengeParameters = challengeParameters as! glue_ChallengeParameters
        let cp2 = ChallengeParameters()
        cp2.acsRefNumber = cp.getAcsRefNumber()
        cp2.acsSignedContent = cp.getAcsSignedContent()
        cp2.acsTransactionID = cp.getAcsTransactionID()
        cp2.threeDSServerTransactionID = cp.get3DSServerTransactionID()

        let csr = glue_ChallegeStatusReceiver(factory, challengeStatusReceiver)
        try tr.doChallenge(cp2, csr, timeOut)
    }
    
    func getProgressView(_ applicationContext: ults_Context?) throws -> ults_ProgressView {
        return try glue_ProgressView(tr.getProgressView())
    }
    
    func close() throws {
        try tr.close()
    }
}

class glue_ProgressView: ProgressDialog, ults_ProgressView {
    
    var pd: ProgressDialog
    
    init (_ pd: ProgressDialog) {
        self.pd = pd
    }
    
    func show() {
        pd.start()
    }
    
    func close() {
        pd.stop()
    }
}

class glue_ThreeDS2Service: ults_ThreeDS2Service {
    
    let sv = ThreeDS2Service()
    var factory: ults_Factory
    
    init (_ factory: ults_Factory) {
        self.factory = factory;
    }
    
    func initialize(_ applicationContext: ults_Context?, _ configParameters: ults_ConfigParameters, _ locale: String?, _ uiCustomization: ults_UiCustomization?) throws {
       
        let cp:glue_ConfigParameters = configParameters as! glue_ConfigParameters
        let uc:glue_UiCustomization = uiCustomization as! glue_UiCustomization
        try sv.initialize(cp.cp, locale, uc.uc)
    }
    
    func createTransaction(_ directoryServerID: String, _ messageVersion: String?) throws -> ults_Transaction {
        return try! glue_Transaction(factory, sv, directoryServerID, messageVersion!)
    }
    
    func cleanup(_ applicationContext: ults_Context?) throws {
        try sv.cleanup()
    }
    
    func getSDKVersion() throws -> String {
        return try sv.getSDKVersion()
    }
    
    func getWarnings() -> Array<ults_Warning> {
        return sv.getWarnings() as! Array<ults_Warning>
    }
}

class glue_Warning: ults_Warning {
    
    let wr = Warning()

    func getID() -> String {
        return wr.getID()
    }
    
    func getMessage() -> String {
        return wr.getMessage()
    }
    
    func getSeverity() -> ults_Severity {
       
        switch wr.severity {
            case .LOW:
                return ults_Severity.LOW
            case .MEDIUM:
                return ults_Severity.MEDIUM
            case .HIGH:
                return ults_Severity.HIGH
            }
    }
    
    func setID(_ id: String) {
        wr.setID(id)
    }
    
    func setMessage(_ message: String) {
        wr.setMessage(message)
    }
    
    func setSeverity(_ severity: ults_Severity) {
        switch severity {
        case ults_Severity.LOW:
            wr.severity = Severity.LOW
        case ults_Severity.MEDIUM:
            wr.severity = Severity.MEDIUM
        case ults_Severity.HIGH:
            wr.severity = Severity.HIGH
        }
    }
}

class glue_AuthenticationRequestParameters: ults_AuthenticationRequestParameters {
    
    var arp: AuthenticationRequestParameters

    init(_ arp: AuthenticationRequestParameters) {
        self.arp = arp
    }

    func getDeviceData() -> String {
        return arp.deviceData
    }
    
    func getSDKTransactionID() -> String {
        return arp.sdkTransactionID
    }
    
    func getSDKAppID() -> String {
        return arp.sdkAppID
    }
    
    func getSDKReferenceNumber() -> String {
        return arp.sdkReferenceNumber
    }
    
    func getSDKEphemeralPublicKey() -> String {
        return arp.sdkEphemeralPublicKey
    }
    
    func getMessageVersion() -> String {
        return arp.messageVersion
    }
}

class glue_ConfigParameters: ults_ConfigParameters {
    
    let cp = ConfigParameters()

    func addParam(_ group: String?, _ paramName: String, _ paramValue: String?) throws {
        try cp.addParam(group, paramName, paramValue)
    }
    
    func getParamValue(_ group: String?, _ paramName: String) throws -> String {
        return try cp.getParamValue(group, paramName)
    }
    
    func removeParam(_ group: String?, _ paramName: String) throws -> String {
        return try cp.removeParam(group, paramName)
    }
}

class glue_ButtonCustomization: ults_ButtonCustomization {
    var bc = ButtonCustomization()
    
    init(_ ibc: ButtonCustomization) {
        bc=ibc
    }
    func setTextFontName(_ fontName: String) throws {
        try bc.setTextFontName(fontName)
    }
    
    func setTextColor(_ hexColorCode: String) throws {
        try bc.setTextColor(hexColorCode)
    }
    
    func setTextFontSize(_ fontSize: Int) throws {
        try bc.setTextFontSize(fontSize)
    }
    
    func getTextFontName() -> String {
        return bc.getTextFontName()
    }
    
    func getTextColor() -> String {
        return bc.getTextColor()
    }
    
    func getTextFontSize() -> Int {
        return bc.getTextFontSize()
    }
    
    func setBackgroundColor(_ hexColorCode: String) throws {
        try bc.setBackgroundColor(hexColorCode)
    }
    
    func setCornerRadius(_ cornerRadius: Int) throws {
        try bc.setCornerRadius(cornerRadius)
    }
    
    func getBackgroundColor() -> String {
        return bc.getBackgroundColor()
    }
    
    func getCornerRadius() -> Int {
        return bc.getCornerRadius()
    }
    
}

class glue_ToolbarCustomization: ults_ToolbarCustomization {
    var tc = ToolbarCustomization()
    
    init (_ itc: ToolbarCustomization) {
        tc=itc
    }
    
    func setTextFontName(_ fontName: String) throws {
        try tc.setTextFontName(fontName)
    }
    
    func setTextColor(_ hexColorCode: String) throws {
        try tc.setTextColor(hexColorCode)
    }
    
    func setTextFontSize(_ fontSize: Int) throws {
        try tc.setTextFontSize(fontSize)
    }
    
    func getTextFontName() -> String {
        return tc.getTextFontName()
    }
    
    func getTextColor() -> String {
        return tc.getTextColor()
    }
    
    func getTextFontSize() -> Int {
        return tc.getTextFontSize()
    }
    
    func setBackgroundColor(_ hexColorCode: String) throws {
        try tc.setBackgroundColor(hexColorCode)
    }
    
    func setHeaderText(_ headerText: String) throws {
        try tc.setHeaderText(headerText)
    }
    
    func getBackgroundColor() -> String {
        return tc.getBackgroundColor()
    }
    
    func getHeaderText() -> String {
        return tc.getHeaderText()
    }
}

class glue_LabelCustomization: ults_LabelCustomization {
    var lc = LabelCustomization()
    
    init (_ ilc: LabelCustomization) {
        lc=ilc
    }
    
    func setTextFontName(_ fontName: String) throws {
        try lc.setTextFontName(fontName)
    }
    
    func setTextColor(_ hexColorCode: String) throws {
        try lc.setTextColor(hexColorCode)
    }
    
    func setTextFontSize(_ fontSize: Int) throws {
        try lc.setTextFontSize(fontSize)
    }
    
    func getTextFontName() -> String {
        return lc.getTextFontName()
    }
    
    func getTextColor() -> String {
        return lc.getTextColor()
    }
    
    func getTextFontSize() -> Int {
        return lc.getTextFontSize()
    }
    
    func setHeadingTextColor(_ hexColorCode: String) throws {
        try lc.setHeadingTextColor(hexColorCode)
    }
    
    func setHeadingTextFontName(_ fontName: String) throws {
        try lc.setHeadingTextFontName(fontName)
    }
    
    func setHeadingTextFontSize(_ fontSize: Int) throws {
        try lc.setHeadingTextFontSize(fontSize)
    }
    
    func getHeadingTextColor() -> String {
        return lc.getHeadingTextColor()
    }
    
    func getHeadingTextFontName() -> String {
        return lc.getHeadingTextFontName()
    }
    
    func getHeadingTextFontSize() -> Int {
        return lc.getHeadingTextFontSize()
    }
    
}

class glue_TextBoxCustomization: ults_TextBoxCustomization {
    var tc = TextBoxCustomization ()
    
    init (_ itc: TextBoxCustomization) {
        tc=itc
    }
    
    func setTextFontName(_ fontName: String) throws {
        try tc.setTextFontName(fontName)
    }
    
    func setTextColor(_ hexColorCode: String) throws {
        try tc.setTextColor(hexColorCode)
    }
    
    func setTextFontSize(_ fontSize: Int) throws {
        try tc.setTextFontSize(fontSize)
    }
    
    func getTextFontName() -> String {
        return tc.getTextFontName()
    }
    
    func getTextColor() -> String {
        return tc.getTextColor()
    }
    
    func getTextFontSize() -> Int {
        return tc.getTextFontSize()
    }

    func setBorderWidth(_ borderWidth: Int) throws {
        try tc.setBorderWidth(borderWidth)
    }
    
    func setBorderColor(_ hexColorCode: String) throws {
        try tc.setBorderColor(hexColorCode)
    }
    
    func setCornerRadius(_ cornerRadius: Int) throws {
        try tc.setCornerRadius(cornerRadius)
    }
    
    func getBorderWidth() -> Int {
        return tc.getBorderWidth()
    }
    
    func getBorderColor() -> String {
        return tc.getBorderColor()
    }
    
    func getCornerRadius() -> Int {
        return tc.getCornerRadius()
    }
}

class glue_UiCustomization: ults_UiCustomization {
    
    let uc = UiCustomization()

    func setButtonCustomization(_ buttonCustomization: ults_ButtonCustomization, _ buttonType: ults_ButtonType) throws {
     
        let bc:glue_ButtonCustomization = buttonCustomization as! glue_ButtonCustomization
       
        switch buttonType {
            case .SUBMIT:
                try uc.setButtonCustomization(bc.bc, ButtonType.SUBMIT)
            case .CONTINUE:
                try uc.setButtonCustomization(bc.bc, ButtonType.CONTINUE)
            case .NEXT:
                try uc.setButtonCustomization(bc.bc, ButtonType.NEXT)
            case .CANCEL:
                try uc.setButtonCustomization(bc.bc, ButtonType.CANCEL)
            case .RESEND:
                try uc.setButtonCustomization(bc.bc, ButtonType.RESEND)
        }
    }
    
    func setButtonCustomization(_ buttonCustomization: ults_ButtonCustomization, _ buttonType: String) throws {
        // let bc:glue_ButtonCustomization = buttonCustomization as! glue_ButtonCustomization
        // not supported by this SDK
    }
    
    func setToolbarCustomization(_ toolbarCustomization: ults_ToolbarCustomization) throws {
        let tc:glue_ToolbarCustomization = toolbarCustomization as! glue_ToolbarCustomization
        try uc.setToolbarCustomization(tc.tc)
    }
    
    func setLabelCustomization(_ labelCustomization: ults_LabelCustomization) throws {
        let lc: glue_LabelCustomization = labelCustomization as! glue_LabelCustomization
        try uc.setLabelCustomization(lc.lc)
    }
    
    func setTextBoxCustomization(_ textBoxCustomization: ults_TextBoxCustomization) throws {
        let tc: glue_TextBoxCustomization = textBoxCustomization as! glue_TextBoxCustomization
        try? uc.setTextBoxCustomization(tc.tc)
    }
    
    func getButtonCustomization(_ buttonType: ults_ButtonType) throws -> ults_ButtonCustomization {
        
        switch buttonType {
            case .SUBMIT:
                return try glue_ButtonCustomization(uc.getButtonCustomization(ButtonType.SUBMIT))
            case .CONTINUE:
                return try glue_ButtonCustomization(uc.getButtonCustomization(ButtonType.CONTINUE))
            case .NEXT:
                return try glue_ButtonCustomization(uc.getButtonCustomization(ButtonType.NEXT))
            case .CANCEL:
                return try glue_ButtonCustomization(uc.getButtonCustomization(ButtonType.CANCEL))
            case .RESEND:
                return try glue_ButtonCustomization(uc.getButtonCustomization(ButtonType.RESEND))
        }
    }
    
    func getButtonCustomization(_ buttonType: String) throws -> ults_ButtonCustomization {
        return try glue_ButtonCustomization(uc.getButtonCustomization(ButtonType.SUBMIT))
    }
    
    func getToolbarCustomization() throws -> ults_ToolbarCustomization {
        let tc = try? uc.getToolbarCustomization()
        return glue_ToolbarCustomization(tc!)
    }
    
    func getLabelCustomization() throws -> ults_LabelCustomization {
        let lc = try? uc.getLabelCustomization()
        return glue_LabelCustomization(lc!)
    }
    
    func getTextBoxCustomization() throws -> ults_TextBoxCustomization {
        let tc = try? uc.getTextBoxCustomization()
        return glue_TextBoxCustomization(tc!)
    }
}

class glue_RuntimeErrorEvent: ults_RuntimeErrorEvent {
    var ev: RuntimeErrorEvent
    
    init (_ errorCode: String?, _ errorMessage: String) {
        ev = RuntimeErrorEvent(errorCode, errorMessage)
    }
    
    func getErrorCode() -> String? {
        return ev.errorCode
    }
    
    func getErrorMessage() -> String {
        return ev.errorMessage
    }
    
}

class glue_ErrorMessage: ults_ErrorMessage {
    var em: ErrorMessage
    
    init(_ iem: ErrorMessage) {
        em=iem
    }
    init(_ transactionID: String, _ errorCode: String, _ errorDescription: String, _ errorDetail: String) {
        em = ErrorMessage(transactionID,errorCode,errorDescription,errorDetail)
    }
    
    func getTransactionID() -> String {
        return em.transactionID
    }
    
    func getErrorCode() -> String {
        return em.errorCode
    }
    
    func getErrorDescription() -> String {
        return em.errorDescription
    }
    
    func getErrorDetails() -> String {
        return em.errorDetail
    }
}

class glue_ProtocolErrorEvent: ults_ProtocolErrorEvent {
    var ev: ProtocolErrorEvent
    
    init(_ iev: ProtocolErrorEvent) {
        ev=iev
    }
    init(_ id: String, _ em: ults_ErrorMessage) {
        let em2 = ErrorMessage(em.getTransactionID(),em.getErrorCode(),em.getErrorDescription(),em.getErrorDetails())
        
        ev = ProtocolErrorEvent(id,em2)
    }
    func getErrorMessage() -> ults_ErrorMessage {
        return glue_ErrorMessage(ev.errorMessage)
    }
    
    func getSDKTransactionID() -> String {
        return ev.sdkTransactionID
    }
    
    
}

public class glue_CompletionEvent: ults_CompletionEvent {
    var sdkTransactionID: String
    var transactionStatus: String
    
    init(_ sdkTransactionID: String, _ transactionStatus: String) {
        self.sdkTransactionID=sdkTransactionID
        self.transactionStatus=transactionStatus
    }
    
    func getSDKTransactionID() -> String {
        return sdkTransactionID
    }
    
    func getTransactionStatus() -> String {
        return transactionStatus
    }
}

public class Factory: ults_Factory {
   
    func newAuthenticationRequestParameters(_ sdkTransactionID: String, _ deviceData: String, _ sdkEphemeralPublicKey: String, _ sdkAppID: String, _ sdkReferenceNumber: String, _ messageVersion: String) throws -> ults_AuthenticationRequestParameters {
        let ap = AuthenticationRequestParameters()
        ap.sdkTransactionID=sdkTransactionID
        ap.deviceData=deviceData
        ap.sdkEphemeralPublicKey=sdkEphemeralPublicKey
        ap.sdkAppID=sdkAppID
        ap.messageVersion=messageVersion
        return glue_AuthenticationRequestParameters(ap)
    }
    
    func newRuntimeErrorEvent(_ errorCode: String?, _ errorMessage: String) -> ults_RuntimeErrorEvent {
        return glue_RuntimeErrorEvent(errorCode,errorMessage)
    }
    
    func newCompletionEvent(_ sdkTransactionID: String, _ transactionStatus: String) -> ults_CompletionEvent {
        return glue_CompletionEvent(sdkTransactionID,transactionStatus)
    }

    func newProtolErrorEvent(_ sdkTransactionID: String, _ errorMessage: ults_ErrorMessage) -> ults_ProtocolErrorEvent {
        return glue_ProtocolErrorEvent(sdkTransactionID, errorMessage)
    }
    
    func newErrorMessage(_ transactionID: String, _ errorCode: String, _ errorDescription: String, _ errorDetail: String) -> ults_ErrorMessage {
        return glue_ErrorMessage(transactionID,errorCode,errorDescription,errorDetail)
    }
    
    func newWarning(_ id: String, _ message: String, _ severity: ults_Severity) -> ults_Warning {
        let warning = glue_Warning()
        warning.setID(id)
        warning.setMessage(message)
        warning.setSeverity(severity)
        return warning
    }
    
    func newChallengeParameters() -> ults_ChallengeParameters {
        return glue_ChallengeParameters()
    }

    func newThreeDS2Service() -> ults_ThreeDS2Service {
        return glue_ThreeDS2Service(self)
    }

    func newConfigParameters() -> ults_ConfigParameters {
        return glue_ConfigParameters()
    }

    func newUiCustomization() -> ults_UiCustomization {
        return glue_UiCustomization()
    }
}
