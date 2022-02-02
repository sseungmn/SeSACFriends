//
//  UserCardCommentComponent.swift
//  SeSACFriends
//
//  Created by SEUNGMIN OH on 2022/02/02.
//

import UIKit
import Then
import SnapKit

class UserCardCommentComponent: View {
    let firstCommentLabel = UILabel().then { label in
        label.font = .Body3_R14
        label.textColor = Asset.Colors.gray6.color
        label.numberOfLines = 0
    }
    
    override func setConstraint() {
        addSubview(firstCommentLabel)
        firstCommentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configure() {
        firstCommentLabel.text = "첫 리뷰를 기다리는 중이에요!"
//        firstCommentLabel.text = """
//        [스포티비뉴스=박대성 기자] 토트넘이 새로운 미드필더 영입을 추진한다. 프랑크 케시에(25, AC밀란)에게 접근했는데, 구단 최고 대우로 모셔올 전망이다. 손흥민(29) 연봉을 훌쩍 뛰어넘는다.
//
//        케시에는 아탈란타를 거쳐 AC밀란에서 활약하고 있다. 왕성한 활동량에 박스 투 박스로 AC밀란 중원을 지휘한다. 수비형 미드필더와 중앙 미드필더에서 뛸 수 있고, 상황에 적합한 다양한 패스에 183cm 다부진 피지컬까지, 이탈리아 세리에A 톱 미드필더로 평가되고 있다.
//
//        지난 시즌까지 인터밀란에서 팀을 지휘했던 안토니오 콘테 감독 레이더 망에 포착됐다. 케시에는 2022년이면 AC밀란과 계약이 끝나는데 재계약 협상에 진척이 없다. 세리에A 최고 수준 미드필더를 이적료 0원에 데려올 수 있는 기회다.
//
//        22일(한국시간) '스포츠 이탈리아' 저널리스트 루디 갈레티에 따르면, 토트넘이 이미 케시에에게 접근했다. 자유계약대상자(FA) 영입을 위해서 거액의 연봉을 제안했다. 연봉 1000만 유로(약 134억 원)를 협상 테이블에 올려둔 거로 추정된다.
//
//        영국 매체 '팀토크'도 토트넘과 케시에 협상을 알렸다. 매체는 '케시에가 토트넘 제안을 수락한다면, 토트넘에서 가장 많은 연봉을 받는 선수가 된다. 손흥민 연봉을 넘는 수준이다. 실제 케시에는 AC밀란의 재계약 제안을 거절했다'고 짚었다.
//
//        손흥민은 올해 여름(7월)에 토트넘과 2025년까지 재계약을 체결했다. 토트넘은 손흥민과 재계약을 일찍이 끝내려고 했지만, 신종 코로나 바이러스로 재정적인 여유가 없어지면서 협상을 보류했다. 하지만 양 측은 긍정적이었고, 구단 최고 대우에 서명을 했다.
//
//        케시에가 토트넘에 합류한다면, 손흥미 재계약 1년 만에 최고 연봉이 바뀔 수도 있다. 물론 토트넘이 당장 겨울 이적 시장에 데려올 거로 보이진 않는다. 보스만 룰에 따라 사전 협상을 할 수 있지만, 계약 만료까지 6개월이 남았기에 이적료가 발생한다. 겨울에 협상을 끝내고 여름에 이적료 0원으로 영입할 것이다.
//
//        출처 : SPOTV NEWS(https://www.spotvnews.co.kr)
//"""
    }
}
