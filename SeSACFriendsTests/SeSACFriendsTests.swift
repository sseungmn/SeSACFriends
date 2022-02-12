//
//  SeSACFriendsTests.swift
//  SeSACFriendsTests
//
//  Created by SEUNGMIN OH on 2022/01/18.
//

import XCTest
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
    }

    override func tearDownWithError() throws {
        disposeBag = nil
        auth = nil
        common = nil
    }

    func testIsUser() throws {
        let isUser: Single<Bool> = auth.isUser()
       
        XCTAssertTrue(try isUser.toBlocking().first()!)
    }
    
    func testFCMToken() throws {
        let refreshFCMtoken: Single<Bool> = common.refreshFCMtoken()
        
        XCTAssertEqual(try refreshFCMtoken.toBlocking().first(), true)
    }
    
    func testSignUp() throws {
        let signUp: Single<Void> = auth.signUp()
        
        XCTAssertEqual(((try signUp.toBlocking().first()) != nil), true)
    }

    func testWithdraw() throws {
        let withdraw: Single<Void> = auth.withDraw()
        
        XCTAssertEqual(((try withdraw.toBlocking().first()) != nil), true)
    }
}
