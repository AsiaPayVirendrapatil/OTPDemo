//
//  WebChallengeProtocol.swift
//  emvco3ds_protocols_ios
//
//  Created by Local user on 10/18/17.
//

import UIKit

@objc public protocol WebChallengeProtocol: GenericChallengeProtocol {
    func getWebView() -> UIWebView
}
