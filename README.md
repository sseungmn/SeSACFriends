# SeSACFriends

### 프로젝트 소개
* 취미 기반 친구찾기 서비스
* Sesac 교육 프로그램으로부터 API, 기획을 제공받아 스스로 설계, 구현한 프로젝트 입니다.

### 기술스택
|분류|종류|
|:---:|---|
|Project|`MVVM`, `RxSwift`, `SwiftLint`, `SwiftGen`|
|UI|`SnapKIt`, `Then`, `Toast-Swift`, `Tabman`|
|Network|`Moya/RxSwift`, `Soket.IO-Clinet-Swift`|
|Etc|`Firebase/Auth`, `Firebase/Messaging`, `NMapsMap`|
|Test|`RxBlocking`, `RxTest`|

### 특징
* 직접 구현한 라이브러리([`RxNMapsMap`](https://github.com/sseungmn/RxNMapsMap))를 적용했습니다.
* 반복되는 UI를 재사용이 가능하도록 설계, 구현했습니다.
  * 대체로 큰 생산성 향상이 있었지만, 몇몇 부분에서는 오히려 생산성 저하를 경험했습니다.
  * FlowChart를 그려 의존성 부패의 문제점을 발견했고, DIP에 대해 자세히 공부해 해결법을 찾을 수 있었습니다.

* ~~Socket을 이용한 채팅을 구현하는 과정에서 DIP을 적용한 설계, UnitTest를 활용해 개발했습니다.~~
  * ~~예상 개발공수보다 약 X%의 시간 단축을 이뤘습니다.~~
