//
//  MulitSelectChallengeProtocol.swift
//  emvco3ds_protocols_ios
//
//  Created by Kinaan, William on 12/09/2017.
//

import UIKit

@objc public protocol MultiSelectChallengeProtocol: GenericChallengeProtocol {
    //The SDK should select the view component that shows the option related to the index value.
    //For example, if the view component is UISwitch, and the index is 1, then the SDK should:
    // switch the UISwitch to true
        func selectIndex(_ index : Int)
}
