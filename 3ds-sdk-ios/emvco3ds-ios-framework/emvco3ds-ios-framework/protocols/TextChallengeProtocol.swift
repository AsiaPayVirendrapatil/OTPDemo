//
//  TextChallengeListener.swift
//  emvco3ds_protocols_ios
//
//  Created by Kinaan, William on 16/08/2017.
//  Test

import UIKit

@objc public protocol TextChallengeProtocol : GenericChallengeProtocol {
     func typeTextChallengeValue(_ value : String)
}
