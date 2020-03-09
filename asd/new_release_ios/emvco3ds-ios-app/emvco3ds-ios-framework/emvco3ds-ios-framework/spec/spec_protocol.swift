
public protocol ults_Context {
    // whatever the application implementer needs to represent their application, as long as it conforms to this protocol
    // where used in this specification it may be passed as NIL or an empty conforming object may be passed if not required
}

public protocol ults_ProgressView {
    // this element is not in the specification as that is just a reference to the Android implementation.
    // here we specify this protocol as any "View" that should implement the methods "show()" and "close()"
    // note that the spec says nothing about what happens AFTER you close/cancel/hide this UI element; it is probably
    // not a good idea to persist is beyond the action that provided it. Likewise it is not advisable to show, close and
    // then show again.
    func show()
    func close()
}

public protocol ults_ConfigParameters {
    func addParam(_ group: String?,_ paramName: String, _ paramValue: String?) throws
    func getParamValue(_ group: String?,_ paramName: String) throws -> String
    // note that this should return the paramName that was removed, not its value
    func removeParam(_ group: String?,_ paramName: String) throws -> String
}

public enum ults_ButtonType {
    case SUBMIT
    case CONTINUE
    case NEXT
    case CANCEL
    case RESEND
}

public protocol ults_Customization {
    func setTextFontName(_ fontName: String) throws
    func setTextColor(_ hexColorCode: String) throws
    func setTextFontSize(_ fontSize: Int) throws
    func getTextFontName() -> String
    func getTextColor() -> String
    func getTextFontSize() -> Int
}

public protocol ults_ButtonCustomization: ults_Customization {
    func setBackgroundColor(_ hexColorCode: String) throws
    func setCornerRadius(_ cornerRadius: Int) throws
    func getBackgroundColor() -> String
    func getCornerRadius() -> Int
}

public protocol ults_ToolbarCustomization: ults_Customization {
    func setBackgroundColor(_ hexColorCode: String) throws
    func setHeaderText(_ headerText: String) throws
    func getBackgroundColor() -> String
    func getHeaderText() -> String
}

public protocol ults_LabelCustomization: ults_Customization {
    func setHeadingTextColor(_ hexColorCode: String) throws
    func setHeadingTextFontName(_ fontName: String) throws
    func setHeadingTextFontSize(_ fontSize: Int) throws
    func getHeadingTextColor() -> String
    func getHeadingTextFontName() -> String
    func getHeadingTextFontSize() -> Int
}

public protocol ults_TextBoxCustomization: ults_Customization {
    func setBorderWidth(_ borderWidth: Int) throws
    func setBorderColor(_ hexColorCode: String) throws
    func setCornerRadius(_ cornerRadius: Int) throws
    func getBorderWidth() -> Int
    func getBorderColor() -> String
    func getCornerRadius() -> Int
}

public protocol ults_UiCustomization {
    func setButtonCustomization(_ buttonCustomization: ults_ButtonCustomization, _ buttonType: ults_ButtonType) throws
    func setButtonCustomization(_ buttonCustomization: ults_ButtonCustomization, _ buttonType: String) throws
    func setToolbarCustomization(_ toolbarCustomization: ults_ToolbarCustomization) throws
    func setLabelCustomization(_ labelCustomization: ults_LabelCustomization) throws
    func setTextBoxCustomization(_ textBoxCustomization: ults_TextBoxCustomization) throws
    func getButtonCustomization(_ buttonType: ults_ButtonType) throws -> ults_ButtonCustomization
    func getButtonCustomization(_ buttonType: String) throws -> ults_ButtonCustomization
    func getToolbarCustomization() throws -> ults_ToolbarCustomization
    func getLabelCustomization() throws -> ults_LabelCustomization
    func getTextBoxCustomization() throws -> ults_TextBoxCustomization
}

public protocol ults_AuthenticationRequestParameters {
    func getDeviceData() -> String
    func getSDKTransactionID() -> String
    func getSDKAppID() -> String
    func getSDKReferenceNumber() -> String
    func getSDKEphemeralPublicKey() -> String
    func getMessageVersion() -> String
}

public protocol ults_ChallengeParameters {
    func set3DSServerTransactionID(_ transactionID: String)
    func setAcsTransactionID(_ transactionID: String)
    func setAcsRefNumber(_ refNumber: String)
    func setAcsSignedContent(_ signedContent: String)
    func get3DSServerTransactionID() -> String
    func getAcsTransactionID() -> String
    func getAcsRefNumber() -> String
    func getAcsSignedContent() -> String
}

public protocol ults_Transaction {
    func getAuthenticationRequestParameters() -> ults_AuthenticationRequestParameters
    func doChallenge(_ applicationContext: ults_Context?,
                     _ challengeParameters: ults_ChallengeParameters,
                     _ challengeStatusReceiver: ults_ChallengeStatusReceiver,
                     _ timeOut: Int) throws
    func getProgressView(_ applicationContext: ults_Context?) throws -> ults_ProgressView
    func close() throws
}

public protocol ults_ThreeDS2Service {
    func initialize(_ applicationContext: ults_Context?,
                    _ configParameters: ults_ConfigParameters,
                    _ locale: String?,
                    _ uiCustomization: ults_UiCustomization?) throws
    func createTransaction(_ directoryServerID: String,
                           _ messageVersion: String?) throws -> ults_Transaction
    func cleanup(_ applicationContext: ults_Context?) throws
    func getSDKVersion() throws -> String
    func getWarnings() -> Array<ults_Warning>
}

public enum ults_Severity {
    case LOW
    case MEDIUM
    case HIGH
}

public protocol ults_Warning {
    func getID() -> String
    func getMessage() -> String
    func getSeverity() -> ults_Severity
}

public protocol ults_CompletionEvent {
    func getSDKTransactionID() -> String
    func getTransactionStatus() -> String
}

public protocol ults_ErrorMessage {
    func getTransactionID() -> String
    func getErrorCode() -> String
    func getErrorDescription() -> String
    func getErrorDetails() -> String
}

public protocol ults_ProtocolErrorEvent {
    func getErrorMessage() -> ults_ErrorMessage
    func getSDKTransactionID() -> String
}

public protocol ults_RuntimeErrorEvent {
    func getErrorCode() -> String?
    func getErrorMessage() -> String
}

public protocol ults_ChallengeStatusReceiver {
    func completed(_ completionEvent: ults_CompletionEvent)
    func cancelled()
    func timedout()
    func protocolError(_ protocolErrorEvent: ults_ProtocolErrorEvent)
    func runtimeError(_ runtimeErrorEvent: ults_RuntimeErrorEvent)
}

public protocol ults_Factory {
    func newRuntimeErrorEvent(_ errorCode: String?,
                              _ errorMessage: String) -> ults_RuntimeErrorEvent
    func newProtolErrorEvent(_ sdkTransactionID: String,
                             _ errorMessage: ults_ErrorMessage) -> ults_ProtocolErrorEvent
    func newCompletionEvent(_ sdkTransactionID: String,
                            _ transactionStatus: String) -> ults_CompletionEvent
    func newErrorMessage(_ transactionID: String,
                         _ errorCode: String,
                         _ errorDescription: String,
                         _ errorDetail: String) -> ults_ErrorMessage
    func newWarning(_ id: String,
                    _ message: String,
                    _ severity: ults_Severity) -> ults_Warning
    func newAuthenticationRequestParameters(_ sdkTransactionID: String,
                                            _ deviceData: String,
                                            _ sdkEphemeralPublicKey: String,
                                            _ sdkAppID: String,
                                            _ sdkReferenceNumber: String,
                                            _ messageVersion: String) throws -> ults_AuthenticationRequestParameters
    
    func newChallengeParameters() -> ults_ChallengeParameters
    func newThreeDS2Service() -> ults_ThreeDS2Service
    func newConfigParameters() -> ults_ConfigParameters
    func newUiCustomization() -> ults_UiCustomization 
}
