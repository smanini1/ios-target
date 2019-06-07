//
//  LogoutTests.swift
//  ios-target
//
//  Created by Rootstrap on 5/16/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import KIF
import OHHTTPStubs
@testable import ios_base_Debug

class LogoutTests: KIFTestCase {
  
  override func beforeAll() {
    super.beforeAll()
    
    SessionManager.currentSession = Session(uid: "rootstrap@gmail.com", client: "client", token: "token", expires: Date(timeIntervalSinceNow: 3.15576E+07)) //Simulates the login
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
      let vc = navigationController.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
      navigationController.pushViewController(vc, animated: true)
    }
  }
  
  override func beforeEach() {
    super.beforeEach()
    
    tester().waitForView(withAccessibilityIdentifier: "AfterLoginSignupView")
  }
  
  override func afterAll() {
    super.afterAll()
    
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.popToRootViewController(animated: true)
    }
  }
  
  // MARK: - Tests
  
  func testLogoutSuccessfully() {
    stub(condition: isPath("/api/v1/users/sign_out")) { _ in
      let stubPath = OHPathForFile("LogoutSuccess.json", type(of: self))
      return fixture(filePath: stubPath!, status: 200, headers: ["Content-Type": "application/json"]).requestTime(0, responseTime: OHHTTPStubsDownloadSpeedWifi)
    }
    
    tester().tapView(withAccessibilityIdentifier: "LogoutButton")
    tester().waitForView(withAccessibilityIdentifier: "StartView")
    XCTAssertEqual(SessionManager.validSession, false)
  }
}
