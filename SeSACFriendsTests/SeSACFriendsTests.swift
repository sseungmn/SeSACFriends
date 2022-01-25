//
//  SeSACFriendsTests.swift
//  SeSACFriendsTests
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import XCTest
import FirebaseMessaging
import Moya
import RxSwift
import RxTest
import RxBlocking

@testable import SeSACFriends

class SeSACFriendsTests: XCTestCase {
    
    var disposeBag: DisposeBag!
    var auth: AuthAPI!
    var common: CommonAPI!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        auth = AuthAPI.shared
        common = CommonAPI.shared
        AuthUserDefaults.idtoken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjNhYTE0OGNkMDcyOGUzMDNkMzI2ZGU1NjBhMzVmYjFiYTMyYTUxNDkiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc2VzYWMtMSIsImF1ZCI6InNlc2FjLTEiLCJhdXRoX3RpbWUiOjE2NDMxMjU1MjksInVzZXJfaWQiOiJSc3JQbGEwRXZNUGhKWkFLT2F3WWNRZ1BIaDgyIiwic3ViIjoiUnNyUGxhMEV2TVBoSlpBS09hd1ljUWdQSGg4MiIsImlhdCI6MTY0MzEyNTUzMCwiZXhwIjoxNjQzMTI5MTMwLCJwaG9uZV9udW1iZXIiOiIrODIxMDc2MDcxMzM5IiwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJwaG9uZSI6WyIrODIxMDc2MDcxMzM5Il19LCJzaWduX2luX3Byb3ZpZGVyIjoicGhvbmUifX0.lYcRTqDG755tRPv40XYcrZv2U6rKQm_refFjKu4lLtEYVQq-ikqPPF9kY1dkt37Po3nQkzd9Z9qFvvBHQ-LShS9JKD-21YJEo35Nc-46FpIQR858YCTG1Ns5EH7pLqDiscqBEkPdt1q55M9TVSvj4OiBUBEizPhcAKX3W5v4ntxl69NCfVSrZFjWuGUO07TCVOL-t0DZNJSbOWYuyRT5JJDxI0s98NMKnPk0ucBH1OeLZPmo_8V3LmUpkUU_ZpyefdYBrDzUOJYPRAjmStsk60af3DlGmSU6d0PjknzAXu-3L6DIC45XtiYwwPph5Nxieiyuzx0H3Y2FfTJnyzI5iA"
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
              AuthUserDefaults.FCMtoken = token
          }
        }
    }

    override func tearDownWithError() throws {
        disposeBag = nil
        auth = nil
        common = nil
        AuthUserDefaults.idtoken = ""
    }

    func testIsUser() throws {
        let isUser: Single<Bool> = auth.isUser()
       
        XCTAssertEqual(try isUser.toBlocking().first(), false)
    }
    
    func testFCMToken() throws {
        let refreshFCMtoken: Single<Bool> = common.refreshFCMtoken()
        
        XCTAssertEqual(try refreshFCMtoken.toBlocking().first(), true)
    }

}
