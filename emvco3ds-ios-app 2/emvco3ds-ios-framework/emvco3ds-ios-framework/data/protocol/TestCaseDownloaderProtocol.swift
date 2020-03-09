//  TestCaseDownloaderProtocol.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

protocol TestCaseDownloaderProtocol {
    func onConfigurationError()
    func onNetworkError()
    func onTcDeserializationError()
    func onSuccessfullyFetchedTcMessage(tcMessage: TcMessage)
    func onSuccessfullyDeleteAllTestCases()
    func onError(message : String)
}
