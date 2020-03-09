//  ConnectorProtocol.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

protocol ConnectorProtocol {
    func onConfigurationError()
    func onConnectionError()
    func onUnexpectedError()
    func onValidationErrorResponse()
    func onSuccessfulAResReceived(aRes: ARes)
    func onTimeoutError()
}
