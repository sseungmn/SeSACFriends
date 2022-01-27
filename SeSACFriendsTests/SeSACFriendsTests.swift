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
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
              AuthUserDefaults.FCMtoken = token
          }
        }
        
        AuthUserDefaults.phoneNumber = "+821042225861"
        AuthUserDefaults.nick = "minios"
        AuthUserDefaults.birth = "1998-09-15T00:00:00.000Z"
        AuthUserDefaults.email = "minios@gmail.com"
        AuthUserDefaults.gender = -1
        
    }

    override func tearDownWithError() throws {
        disposeBag = nil
        auth = nil
        common = nil
    }

    func testIsUser() throws {
        let isUser: Single<Void> = auth.isUser()
       
        XCTAssertTrue(try isUser.toBlocking().first())
    }
    
    func testFCMToken() throws {
        let refreshFCMtoken: Single<Bool> = common.refreshFCMtoken()
        
        XCTAssertEqual(try refreshFCMtoken.toBlocking().first(), true)
    }
    
    func testSignUp() throws {
        let signUp: Single<Bool> = auth.signUp()
        
        XCTAssertEqual(try signUp.toBlocking().first(), true)
    }

    func testWithdraw() throws {
        let withdraw: Single<Bool> = auth.withDraw()
        
        XCTAssertEqual(try withdraw.toBlocking().first(), true)
    }
}
