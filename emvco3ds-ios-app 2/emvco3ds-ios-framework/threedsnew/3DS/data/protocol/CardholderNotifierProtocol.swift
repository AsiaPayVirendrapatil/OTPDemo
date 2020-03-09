//  CardholderNotifierProtocol.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

protocol CardholderNotifierProtocol {
    func onSuccessfullyCardholderServerNotified()
    func onErrorCardholderServer(message: String)
}
