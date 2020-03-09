//  TestManagementNotifierProtocol.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

protocol TestManagementNotifierProtocol {
    func onSuccessfullyNotified()
    func onError(message: String)
}
