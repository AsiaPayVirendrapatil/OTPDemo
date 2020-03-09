
import Foundation



class CresData {
    var acsCounterAtoS : String!
    var acsTransID : String!
    var acsUiType : String!
    var challengeCompletionInd : String!
    var challengeInfoHeader : String!
    var challengeInfoLabel : String!
    var challengeInfoText : String!
    var issuerImage : IssuerImage!
    var messageType : String!
    var messageVersion : String!
    var psImage : IssuerImage!
    var sdkTransID : String!
    var submitAuthenticationLabel : String!
    var threeDSServerTransID : String!
    var challengeSelectInfo : [Any]?
    var acsHTML : String!
    var acsHTMLRefresh : String!
    var resendInformationLabel : String!
    //expand title
    var whyInfoLabel : String!
    var expandInfoLabel : String!
    var whyInfoText : String!
    var expandInfoText : String!
    //04
    var oobContinueLabel : String!
    var challengeInfoTextIndicator : String!
    var challengeAddInfo : String!
    
    var transStatus : String!
    
    var messageExtension : [Any]?
    
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        acsCounterAtoS = dictionary["acsCounterAtoS"] as? String
        acsTransID = dictionary["acsTransID"] as? String
        acsUiType = dictionary["acsUiType"] as? String
        challengeCompletionInd = dictionary["challengeCompletionInd"] as? String
        challengeInfoHeader = dictionary["challengeInfoHeader"] as? String
        challengeInfoLabel = dictionary["challengeInfoLabel"] as? String
        challengeInfoText = dictionary["challengeInfoText"] as? String
        if dictionary["issuerImage"] as? [String:Any] != nil {
            if let issuerImageData = dictionary["issuerImage"] as? [String:Any]{
                issuerImage = IssuerImage(fromDictionary: issuerImageData)
            }
        }
        messageType = dictionary["messageType"] as? String
        messageVersion = dictionary["messageVersion"] as? String
        if dictionary["psImage"] as? [String:Any] != nil {
            if let psImageData = dictionary["psImage"] as? [String:Any]{
                psImage = IssuerImage(fromDictionary: psImageData)
            }
        }
        sdkTransID = dictionary["sdkTransID"] as? String
        submitAuthenticationLabel = dictionary["submitAuthenticationLabel"] as? String
        threeDSServerTransID = dictionary["threeDSServerTransID"] as? String
        challengeSelectInfo = dictionary["challengeSelectInfo"] as? [Any]
        acsHTML = dictionary["acsHTML"] as? String
        acsHTMLRefresh = dictionary["acsHTMLRefresh"] as? String
        resendInformationLabel = dictionary["resendInformationLabel"] as? String
        whyInfoLabel = dictionary["whyInfoLabel"] as? String
        expandInfoLabel = dictionary["expandInfoLabel"] as? String
        whyInfoText = dictionary["whyInfoText"] as? String
        expandInfoText = dictionary["expandInfoText"] as? String
        oobContinueLabel = dictionary["oobContinueLabel"] as? String
        challengeInfoTextIndicator = dictionary["challengeInfoTextIndicator"] as? String
        challengeAddInfo = dictionary["challengeAddInfo"] as? String
        transStatus = dictionary["transStatus"] as? String
        if dictionary["messageExtension"] as? [Any] != nil {
            messageExtension = dictionary["messageExtension"] as? [Any]
        }
    }
    
    
    func toJson() -> [String:Any] {
        let creqDic = [
            "acsCounterAtoS":self.acsCounterAtoS,
            "acsTransID":self.acsTransID,
            "acsUiType":self.acsUiType,
            "challengeCompletionInd":self.challengeCompletionInd,
            "challengeInfoHeader":self.challengeInfoHeader,
            "challengeInfoLabel":self.challengeInfoLabel,
            "challengeInfoText":self.challengeInfoText,
            "issuerImage":self.issuerImage.medium,
            "messageType":self.messageType,
            "messageVersion":self.messageVersion,
            "psImage":self.psImage.medium,
            "sdkTransID":self.sdkTransID,
            "submitAuthenticationLabel":self.submitAuthenticationLabel,
            "threeDSServerTransID":self.threeDSServerTransID,
            "challengeSelectInfo":self.challengeSelectInfo as Any,
            "acsHTML":self.acsHTML,
            "acsHTMLRefresh":self.acsHTMLRefresh,
            "resendInformationLabel":self.resendInformationLabel,
            //expand title
            "whyInfoLabel":self.whyInfoLabel,
            "expandInfoLabel":self.expandInfoLabel,
            "whyInfoText":self.whyInfoText,
            "expandInfoText":self.expandInfoText,
            //04
            "oobContinueLabel":self.oobContinueLabel,
            "challengeInfoTextIndicator":self.challengeInfoTextIndicator,
            "challengeAddInfo":self.challengeAddInfo,
            "transStatus":self.transStatus,
            "messageExtension":self.messageExtension as Any
            ] as [String : Any]
//        let dicData = try! JSONSerialization.data(withJSONObject: creqDic, options: [])
//        return String(data: dicData, encoding: .utf8)!
        return creqDic
    }
}



class ErrorCReq: NSObject {
    var messageType: String = "Erro"
    var messageVersion: String = "2.1.0"
    var errorMessageType: String = "CRes"
    var errorComponent: String = "C"
    var errorDescription: String = "Tag mismatch"
    var errorDetail: String = "Error Tag mismatch"
    var threeDSServerTransID: String?
    var acsTransID: String?
    var errorCode: String?
    var sdkTransID: String?
    
    
    

    init(threeDSServerTransID: String, acsTransID: String , sdkTransID: String, errorCode: String , errorDescription : String , errorDetail : String) {
        self.threeDSServerTransID = threeDSServerTransID
        self.acsTransID = acsTransID
        self.sdkTransID = sdkTransID
        self.errorCode = errorCode
        self.errorDescription = errorDescription
        self.errorDetail = errorDetail
    }
    
    
    func toJson() -> String {        
        let creqDic = [
            "threeDSServerTransID":self.threeDSServerTransID!,
            "acsTransID":self.acsTransID as Any,
            "messageType":self.messageType,
            "messageVersion":self.messageVersion,
            "sdkTransID":self.sdkTransID!,
            "errorMessageType":self.errorMessageType,
            "errorCode":self.errorCode!,
            "errorComponent":self.errorComponent,
            "errorDescription":self.errorDescription,
            "errorDetail":self.errorDetail,
            ] as [String : Any]
        let dicData = try! JSONSerialization.data(withJSONObject: creqDic, options: [])
        return String(data: dicData, encoding: .utf8)!
    }
    
}

