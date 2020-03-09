//
//  SampleSDK.swift
//  Boilerplate empty SDK implementation sample.
//
//  If you would be making a greenfield SDK implementation, you could
//  simply take this file and write your implementation code at the placeholders.
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

class ChallengeParameters: ults_ChallengeParameters {
    
    var threeDSServerTransactionID: String
    var acsTransactionID: String
    var acsRefNumber: String
    var acsSignedContent: String

    init(_ threeDSServerTransactionID: String, _ acsTransactionID: String, _ acsRefNumber: String, _ acsSignedContent: String) {
        
        self.threeDSServerTransactionID = threeDSServerTransactionID
        self.acsTransactionID = acsTransactionID
        self.acsRefNumber = acsRefNumber
        self.acsSignedContent = acsSignedContent
    }

    func set3DSServerTransactionID(_ transactionID: String) {
        self.threeDSServerTransactionID = transactionID
    }
    
    func setAcsTransactionID(_ transactionID: String) {
        self.acsTransactionID = transactionID
    }
    
    func setAcsRefNumber(_ refNumber: String) {
        self.acsRefNumber = refNumber
    }
    
    func setAcsSignedContent(_ signedContent: String) {
        self.acsSignedContent = signedContent
    }
    
    func get3DSServerTransactionID() -> String {
        return threeDSServerTransactionID
    }
    
    func getAcsTransactionID() -> String {
        return acsTransactionID
    }
    
    func getAcsRefNumber() -> String {
        return acsRefNumber
    }
    
    func getAcsSignedContent() -> String {
        return acsSignedContent
    }
}

class Transaction: ults_Transaction
{
    var id: String
    var msg: String

    init(_ id: String, _ msg: String) {
        self.id = id
        self.msg = msg
    }

    func getAuthenticationRequestParameters() -> ults_AuthenticationRequestParameters {
        return AuthenticationRequestParameters()
    }
    
    func doChallenge(_ applicationContext: ults_Context?, _ challengeParameters: ults_ChallengeParameters, _ challengeStatusReceiver: ults_ChallengeStatusReceiver, _ timeOut: Int) throws {
        
        // TODO The context parameter comes from the Specification, you could use it to keep some shared data, if needed
        // TODO Do the challenge processing
        // TODO Call the challengeStatusReceiver with the results
    }
    
    func getProgressView(_ applicationContext: ults_Context?) throws -> ults_ProgressView {
        
        // TODO The context parameter comes from the Specification, you could use it to keep some shared data, if needed
        
        return ProgressView()
    }
    
    func close() throws {
        // TODO you will probably have to clean up some stuff here, like close connections or dialogs
    }
}



class ProgressView: ults_ProgressView {
   
    func show() {
        // TODO show some kind of progress indicator
    }
    
    func close() {
        // TODO hide the progress indicator
    }
}

class ThreeDS2Service: ults_ThreeDS2Service {
    func initialize(_ applicationContext: ults_Context?, _ configParameters: ults_ConfigParameters, _ locale: String?, _ uiCustomization: ults_UiCustomization?) throws {
        // TODO you will probalby need to store these
    }
    
    func createTransaction(_ directoryServerID: String, _ messageVersion: String?) throws -> ults_Transaction {
        return Transaction(directoryServerID, messageVersion!)
    }
    
    func cleanup(_ applicationContext: ults_Context?) throws {
        // TODO some cleanup, if needed
    }
    
    func getSDKVersion() throws -> String {
        return "TODO your version"
    }
    
    func getWarnings() -> Array<ults_Warning> {
        return Array<ults_Warning>()
    }
}

class Warning: ults_Warning {
    var id: String
    var msg: String
    var severity: ults_Severity

    init(_ id: String, _ msg: String, _ severity: ults_Severity) {
        self.id  = id
        self.msg = msg
        self.severity = severity
    }

    func getID() -> String {
        return id
    }
    
    func getMessage() -> String {
        return msg
    }
    
    func getSeverity() -> ults_Severity {
        return severity
    }
    
    func setID(_ id: String) {
        self.id = id;
    }

    func setMessage(_ message: String) {
        self.msg = message;
    }

    func setSeverity(_ severity: ults_Severity) {
        self.severity = severity
    }
}

class AuthenticationRequestParameters: ults_AuthenticationRequestParameters {
    
    let sdkReferenceNumber: String = "3DS_LOA_SDK_PPFU_020100_00007"
    var deviceData: String
    var sdkTransactionID: String
    var sdkAppID: String
    var sdkEphemeralPublicKey: String
    var messageVersion: String

    init() {
        self.deviceData = "add_device_data_here"
        self.sdkTransactionID = "add_transaction_id_here"
        self.sdkAppID = "add_app_id_here"
        self.sdkEphemeralPublicKey = "add_ephemeral_public_key_here"
        self.messageVersion = "add_message_version_here"
    }

    func getDeviceData() -> String {
        return self.deviceData
    }
    
    func getSDKTransactionID() -> String {
        return self.sdkTransactionID
    }
    
    func getSDKAppID() -> String {
        return self.sdkAppID
    }
    
    func getSDKReferenceNumber() -> String {
        return self.sdkReferenceNumber
    }
    
    func getSDKEphemeralPublicKey() -> String {
        return self.sdkEphemeralPublicKey
    }
    
    func getMessageVersion() -> String {
        return self.messageVersion
    }
}

class ConfigParameters: ults_ConfigParameters {
    func addParam(_ group: String?, _ paramName: String, _ paramValue: String?) throws {
        // Add implementation
    }
    
    func getParamValue(_ group: String?, _ paramName: String) throws -> String {
        // Add implementation
        return ""
    }
    
    func removeParam(_ group: String?, _ paramName: String) throws -> String {
       // Add implementation
        return ""
    }
}

class Customization: ults_Customization {
    
    var textFontName: String
    var textColor: String
    var textFontSize: Int

    init(_ textFontName: String, _ textColor: String, _ textFontSize: Int) {
        self.textFontName = textFontName
        self.textColor = textColor
        self.textFontSize = textFontSize
    }

    func setTextFontName(_ fontName: String) throws {
        self.textFontName = fontName
    }

    func setTextColor(_ hexColorCode: String) throws {
        self.textColor = hexColorCode
    }

    func setTextFontSize(_ fontSize: Int) throws {
        self.textFontSize = fontSize
    }

    func getTextFontName() -> String {
        return textFontName
    }

    func getTextColor() -> String {
        return textColor
    }

    func getTextFontSize() -> Int {
        return textFontSize
    }
}

class ButtonCustomization: Customization, ults_ButtonCustomization {
    
    var backgroundColor: String
    var cornerRadius: Int

    init(_ textFontName: String, _ textColor: String, _ textFontSize: Int, _ backgroundColor: String, _ cornerRadius: Int) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        super.init(textFontName, textColor, textFontSize)
    }

    func setBackgroundColor(_ hexColorCode: String) throws {
        self.backgroundColor = hexColorCode
    }
    
    func setCornerRadius(_ cornerRadius: Int) throws {
        self.cornerRadius = cornerRadius
    }
    
    func getBackgroundColor() -> String {
        return backgroundColor
    }
    
    func getCornerRadius() -> Int {
        return cornerRadius
    }
}

class ToolbarCustomization: Customization, ults_ToolbarCustomization {
    
    var backgroundColor: String
    var headerText: String

    init(_ textFontName: String, _ textColor: String, _ textFontSize: Int, _ backgroundColor: String, _ headerText: String) {
        self.backgroundColor = backgroundColor
        self.headerText = headerText
        super.init(textFontName, textColor, textFontSize)
    }

    func setBackgroundColor(_ hexColorCode: String) throws {
        self.backgroundColor = hexColorCode
    }

    func setHeaderText(_ headerText: String) throws {
        self.headerText = headerText
    }

    func getBackgroundColor() -> String {
        return backgroundColor
    }

    func getHeaderText() -> String {
        return headerText
    }
}

class LabelCustomization: Customization, ults_LabelCustomization {
    var headingTextColor: String
    var headingTextFontName: String
    var headingTextFontSize: Int

    init(_ textFontName: String, _ textColor: String, _ textFontSize: Int, _ headingTextColor: String, _ headingTextFontName: String, _ headingTextFontSize: Int) {
        self.headingTextColor = headingTextColor
        self.headingTextFontName = headingTextFontName
        self.headingTextFontSize = headingTextFontSize
        super.init(textFontName, textColor, textFontSize)
    }

    func setHeadingTextColor(_ hexColorCode: String) throws {
        self.headingTextColor = hexColorCode
    }
    
    func setHeadingTextFontName(_ fontName: String) throws {
        self.headingTextFontName = fontName
    }
    
    func setHeadingTextFontSize(_ fontSize: Int) throws {
        self.headingTextFontSize = fontSize
    }
    
    func getHeadingTextColor() -> String {
        return headingTextColor
    }
    
    func getHeadingTextFontName() -> String {
        return headingTextFontName
    }
    
    func getHeadingTextFontSize() -> Int {
        return headingTextFontSize
    }
}

class TextBoxCustomization: Customization, ults_TextBoxCustomization {
    var borderWidth: Int
    var borderColor: String
    var cornerRadius: Int

    init(_ textFontName: String, _ textColor: String, _ textFontSize: Int, _ borderWidth: Int, _ borderColor: String, _ cornerRadius: Int) {
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        super.init(textFontName, textColor, textFontSize)
    }

    func setCornerRadius(_ cornerRadius: Int) throws {
        self.cornerRadius = cornerRadius
    }

    func getCornerRadius() -> Int {
        return cornerRadius
    }

    func setBorderWidth(_ borderWidth: Int) throws {
        self.borderWidth = borderWidth
    }
    
    func setBorderColor(_ hexColorCode: String) throws {
        self.borderColor = hexColorCode
    }

    func getBorderWidth() -> Int {
        return borderWidth
    }
    
    func getBorderColor() -> String {
        return borderColor
    }
}

class UiCustomization: ults_UiCustomization {

    func setButtonCustomization(_ buttonCustomization: ults_ButtonCustomization, _ buttonType: ults_ButtonType) throws {
        // TODO implement
    }
    
    func setButtonCustomization(_ buttonCustomization: ults_ButtonCustomization, _ buttonType: String) throws {
        // TODO implement
    }
    
    func setToolbarCustomization(_ toolbarCustomization: ults_ToolbarCustomization) throws {
        // TODO implement
    }
    
    func setLabelCustomization(_ labelCustomization: ults_LabelCustomization) throws {
        // TODO implement
    }
    
    func setTextBoxCustomization(_ textBoxCustomization: ults_TextBoxCustomization) throws {
        // TODO implement
    }
    
    func getButtonCustomization(_ buttonType: ults_ButtonType) throws -> ults_ButtonCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return ButtonCustomization("","",0,"",0)
    }
    
    func getButtonCustomization(_ buttonType: String) throws -> ults_ButtonCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return ButtonCustomization("","",0,"",0)
    }
    
    func getToolbarCustomization() throws -> ults_ToolbarCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return ToolbarCustomization("","",0,"","")
    }
    
    func getLabelCustomization() throws -> ults_LabelCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return LabelCustomization("","",0,"","",0)
    }
    
    func getTextBoxCustomization() throws -> ults_TextBoxCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return TextBoxCustomization("","",0,0,"",0)
    }
}

class RuntimeErrorEvent: ults_RuntimeErrorEvent {
    
    var errorCode: String
    var errorMessage: String

    init (_ errorCode: String?, _ errorMessage: String) {
        self.errorCode = errorCode!
        self.errorMessage = errorMessage
    }
    
    func getErrorCode() -> String? {
        return errorCode
    }
    
    func getErrorMessage() -> String {
        return errorMessage
    }
    
}

class ErrorMessage: ults_ErrorMessage {
    
    var transactionID: String
    var errorCode: String
    var errorDescription: String
    var errorDetail: String

    init(_ transactionID: String, _ errorCode: String, _ errorDescription: String, _ errorDetail: String) {
        self.transactionID=transactionID
        self.errorCode=errorCode
        self.errorDescription=errorDescription
        self.errorDetail=errorDetail
    }
    
    func getTransactionID() -> String {
        return transactionID
    }
    
    func getErrorCode() -> String {
        return errorCode
    }
    
    func getErrorDescription() -> String {
        return errorDescription
    }
    
    func getErrorDetails() -> String {
        return errorDetail
    }
}

class ProtocolErrorEvent: ults_ProtocolErrorEvent {
    var sdkTransactionID: String
    var errorMessage: ErrorMessage

    init (_ sdkTransactionID: String, _ errorMessage: ErrorMessage) {
        self.sdkTransactionID = sdkTransactionID
        self.errorMessage = errorMessage
    }
    
    func getErrorMessage() -> ults_ErrorMessage {
        return errorMessage
    }
    
    func getSDKTransactionID() -> String {
        return sdkTransactionID
    }
}

public class CompletionEvent: ults_CompletionEvent {
    var sdkTransactionID: String
    var transactionStatus: String
    
    init(_ sdkTransactionID: String, _ transactionStatus: String) {
        self.sdkTransactionID = sdkTransactionID
        self.transactionStatus = transactionStatus
    }
    
    func getSDKTransactionID() -> String {
        return sdkTransactionID
    }
    
    func getTransactionStatus() -> String {
        return transactionStatus
    }
}

public class SampleFactory: ults_Factory {
   
    func newAuthenticationRequestParameters(_ sdkTransactionID: String, _ deviceData: String, _ sdkEphemeralPublicKey: String, _ sdkAppID: String, _ sdkReferenceNumber: String, _ messageVersion: String) throws -> ults_AuthenticationRequestParameters {
       
        let ret = AuthenticationRequestParameters()
        ret.sdkTransactionID = sdkTransactionID
        ret.deviceData = deviceData
        ret.sdkEphemeralPublicKey = sdkEphemeralPublicKey
        ret.sdkAppID = sdkAppID
        ret.messageVersion = messageVersion
        
        return ret
    }
    
    func newRuntimeErrorEvent(_ errorCode: String?, _ errorMessage: String) -> ults_RuntimeErrorEvent {
        return RuntimeErrorEvent(errorCode,errorMessage)
    }
    
    func newProtolErrorEvent(_ sdkTransactionID: String, _ errorMessage: ults_ErrorMessage) -> ults_ProtocolErrorEvent {
        return ProtocolErrorEvent(sdkTransactionID, errorMessage as! ErrorMessage)
    }
    
    func newCompletionEvent(_ sdkTransactionID: String, _ transactionStatus: String) -> ults_CompletionEvent {
        return CompletionEvent(sdkTransactionID,transactionStatus)
    }
    
    func newErrorMessage(_ transactionID: String, _ errorCode: String, _ errorDescription: String, _ errorDetail: String) -> ults_ErrorMessage {
        return ErrorMessage(transactionID,errorCode,errorDescription,errorDetail)
    }
    
    func newWarning(_ id: String, _ message: String, _ severity: ults_Severity) -> ults_Warning {
        return Warning(id, message, severity)
    }
    
    func newChallengeParameters() -> ults_ChallengeParameters {
        return ChallengeParameters("","","","")
    }

    func newThreeDS2Service() -> ults_ThreeDS2Service {
        return ThreeDS2Service()
    }

    func newConfigParameters() -> ults_ConfigParameters {
        return ConfigParameters()
    }

    func newUiCustomization() -> ults_UiCustomization {
        return UiCustomization()
    }
}
