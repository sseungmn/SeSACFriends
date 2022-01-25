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
        AuthUserDefaults.idtoken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjNhYTE0OGNkMDcyOGUzMDNkMzI2ZGU1NjBhMzVmYjFiYTMyYTUxNDkiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vc2VzYWMtMSIsImF1ZCI6InNlc2FjLTEiLCJhdXRoX3RpbWUiOjE2NDMxMzY2MTUsInVzZXJfaWQiOiJ3Rk11WWNYUllkZW9PU1B3MHdvQjJJVkw4M3YxIiwic3ViIjoid0ZNdVljWFJZZGVvT1NQdzB3b0IySVZMODN2MSIsImlhdCI6MTY0MzEzNjYxNiwiZXhwIjoxNjQzMTQwMjE2LCJwaG9uZV9udW1iZXIiOiIrODIxMDQyMjI1ODYxIiwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJwaG9uZSI6WyIrODIxMDQyMjI1ODYxIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGhvbmUifX0.NTPkiq3PyGomcpOdBmxCufaRp1Xk2OXuSnrvNyGg7fAFi2XzmvHzynELAIBSChYyh3oRR5sI8mAWSUp38JJNpxIhzkVvQJkG5xDuDCWVgfTV9wiqrV2yaCOp5Jv0ei93dZD0at0Z1vQsfztYu-WtvrPKewHjk-z_u10SHn7ges0lEkvrekmGOUPzsHtV75NA9lK6FhqXfhMqkNW_b8pJZF2uN24B3M3nGeGA98J_iRvDBXALe16XMYic2zOBu7Apl-xh4Vg6O5EpZig8_QPsLN3aKwRy4iEuU7U88b0JxVo7PDkJMGHw-St3IMpzLuI3GDYgiT0wuKiEyzDg0N4Vlw"
        
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
        let isUser: Single<Bool> = auth.isUser()
       
        XCTAssertEqual(try isUser.toBlocking().first(), false)
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
