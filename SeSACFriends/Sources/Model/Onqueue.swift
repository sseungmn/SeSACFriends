//
//  Onqueue.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/08.
//

import Foundation

// MARK: - Onqueue
struct Onqueue: Codable {
    let fromQueueDB, fromQueueDBRequested: [QueuedUser]
    let fromRecommend: [String]
}

// MARK: - QueueDB
struct QueuedUser: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}
