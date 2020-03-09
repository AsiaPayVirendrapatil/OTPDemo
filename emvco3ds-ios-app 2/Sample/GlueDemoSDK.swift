//
//  GlueDemoSDK.swift
//  Boilerplate empty SDK implementation sample.
//
//  This file represents an EXISTING SDK from a vendor.
//  This will be the target for the GlueDemo.swift implementation, showing how to link an EXISTING SDK to the RefApp
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

class ChallengeParameters {
    var threeDSServerTransactionID: String
    var acsTransactionID: String
    var acsRefNumber: String
    var acsSignedContent: String

    init() {
        self.threeDSServerTransactionID = ""
        self.acsTransactionID = ""
        self.acsRefNumber = ""
        self.acsSignedContent = ""
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

protocol ChallengeStatusReceiver {
    func completed(_ completionEvent: CompletionEvent)
    func cancelled()
    func timedout()
    func protocolError(_ protocolErrorEvent: ProtocolErrorEvent)
    func runtimeError(_ runtimeErrorEvent: RuntimeErrorEvent)
}

class Transaction
{
    var id: String
    var msg: String

    init(_ id: String, _ msg: String) {
        self.id = id
        self.msg = msg
    }

    func getAuthenticationRequestParameters()  throws -> AuthenticationRequestParameters {
        return AuthenticationRequestParameters()
    }
    
    func doChallenge(_ challengeParameters: ChallengeParameters, _ challengeStatusReceiver: ChallengeStatusReceiver, _ timeOut: Int) throws {
        // TODO The context parameter comes from the Specification, you could use it to keep some shared data, if needed
        // TODO Do the challenge processing
        // TODO Call the challengeStatusReceiver with the results
    }
    
    func getProgressView() throws -> ProgressDialog {
        // TODO The context parameter comes from the Specification, you could use it to keep some shared data, if needed
        return ProgressDialog()
    }
    
    func close() throws {
        // TODO you will probably have to clean up some stuff here, like close connections or dialogs
    }
}

class ProgressDialog {
    func start() {
        // TODO show some kind of progress indicator
    }
    
    func stop() {
        // TODO hide the progress indicator
    }
}

class ThreeDS2Service {
    func initialize(_ configParameters: ConfigParameters, _ locale: String?, _ uiCustomization: UiCustomization?) throws {
        // TODO you will probalby need to store these
    }
    
    func createTransaction(_ directoryServerID: String, _ messageVersion: String?) throws -> Transaction {
        return Transaction(directoryServerID, messageVersion!)
    }
    
    func cleanup() throws {
        // TODO some cleanup, if needed
    }
    
    func getSDKVersion() throws -> String {
        return "TODO your version"
    }
    
    func getWarnings() throws -> Array<Warning> {
        return Array<Warning>()
    }
}

enum Severity {
    case LOW
    case MEDIUM
    case HIGH
}

class Warning {
    var id: String
    var msg: String
    var severity: Severity

    init() {
        self.id  = ""
        self.msg = ""
        self.severity = Severity.LOW
    }

    func getID() -> String {
        return id
    }
    
    func getMessage() -> String {
        return msg
    }
    
    func getSeverity() -> Severity {
        return severity
    }
    
    func setID(_ id: String) {
        self.id = id;
    }

    func setMessage(_ message: String) {
        self.msg = message;
    }

    func setSeverity(_ severity: Severity) {
        self.severity = severity
    }
}

class AuthenticationRequestParameters {
    let sdkReferenceNumber: String = "3DS_LOA_SDK_PPFU_020100_00007"
    var deviceData: String
    var sdkTransactionID: String
    var sdkAppID: String
    var sdkEphemeralPublicKey: String
    var messageVersion: String

    init() {
        self.deviceData = "device_data_goes_here"
        self.sdkTransactionID = "transaction_id_goes_here"
        self.sdkAppID = "app_id_goes_here"
        self.sdkEphemeralPublicKey = "ephemeral_public_key_goes_here"
        self.messageVersion = "message_version_goes_here"
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

class ConfigParameters {
    func addParam(_ group: String?, _ paramName: String, _ paramValue: String?) throws {
        // Add implementation here
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

class Customization {
    var textFontName: String
    var textColor: String
    var textFontSize: Int

    init() {
        self.textFontName = ""
        self.textColor = ""
        self.textFontSize = 0
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

class ButtonCustomization: Customization {
    var backgroundColor: String
    var cornerRadius: Int

    override init() {
        self.backgroundColor = ""
        self.cornerRadius = 0
        super.init()
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

class ToolbarCustomization: Customization {
    var backgroundColor: String
    var headerText: String

    override init() {
        self.backgroundColor = ""
        self.headerText = ""
        super.init()
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

class LabelCustomization: Customization {
    var headingTextColor: String
    var headingTextFontName: String
    var headingTextFontSize: Int

    override init() {
        self.headingTextColor = ""
        self.headingTextFontName = ""
        self.headingTextFontSize = 0
        super.init ()
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

class TextBoxCustomization: Customization {
    var borderWidth: Int
    var borderColor: String
    var cornerRadius: Int

    override init() {
        self.borderWidth = 0
        self.borderColor = ""
        self.cornerRadius = 0
        super.init()
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


enum ButtonType {
    case SUBMIT
    case CONTINUE
    case NEXT
    case CANCEL
    case RESEND
}

class UiCustomization {

    func setButtonCustomization(_ buttonCustomization: ButtonCustomization, _ buttonType: ButtonType) throws {
        // TODO implement
    }
    
    func setButtonCustomization(_ buttonCustomization: ButtonCustomization, _ buttonType: String) throws {
        // TODO implement
    }
    
    func setToolbarCustomization(_ toolbarCustomization: ToolbarCustomization) throws {
        // TODO implement
    }
    
    func setLabelCustomization(_ labelCustomization: LabelCustomization) throws {
        // TODO implement
    }
    
    func setTextBoxCustomization(_ textBoxCustomization: TextBoxCustomization) throws {
        // TODO implement
    }
    
    func getButtonCustomization(_ buttonType: ButtonType) throws -> ButtonCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return ButtonCustomization()
    }
    
    func getButtonCustomization(_ buttonType: String) throws -> ButtonCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return ButtonCustomization()
    }
    
    func getToolbarCustomization() throws -> ToolbarCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return ToolbarCustomization()
    }
    
    func getLabelCustomization() throws -> LabelCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return LabelCustomization()
    }
    
    func getTextBoxCustomization() throws -> TextBoxCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return TextBoxCustomization()
    }
}

class RuntimeErrorEvent {
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

class ErrorMessage {
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

class ProtocolErrorEvent {
    var sdkTransactionID: String
    var errorMessage: ErrorMessage

    init (_ sdkTransactionID: String, _ errorMessage: ErrorMessage) {
        self.sdkTransactionID = sdkTransactionID
        self.errorMessage = errorMessage
    }
    
    func getErrorMessage() -> ErrorMessage {
        return errorMessage
    }
    
    func getSDKTransactionID() -> String {
        return sdkTransactionID
    }
}

public class CompletionEvent {
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
