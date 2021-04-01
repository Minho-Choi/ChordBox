# ChordBox
## 기타 코드와 가사를 메트로놈 박자에 맞추어 보여주는 앱
### Guitar chord and lyrircs slideshow app for singers with guitar 
---
## 기능
> ### 박자에 맞추어 코드 이름과 코드 모양, 가사 보여주기
>> #### 메트로놈 소리 같이 남 -> Done
>> #### 속도 조절 가능, 노래 시작 전 클릭 주기 가능 -> 시작 전 click 구현 필요
>> #### 카포, 다운튜닝, 조옮김 지원
>>> ##### 계이름을 객체화해야 함 -> Done
>> #### 코드 보여주기 위핸 custom view -> Done
>>> 가로, 세로 layout에서 형태 깨지지 않도록 수정 필요
> ### 악보 작성 화면
>> #### 외부 api에서 가사 검색 -> Done
>> #### 가사 검색 실패 시 WebView 연결
>> #### 검색한 가사에 코드 입력 -> On Progress
>> ##### UICollectionView 이용하여 가사를 word 단위 cell로 나눔
>> ##### 코드 cell을 collectionview에 드래그 드롭해서 추가할 수 있도록 함
>> ##### 드롭한 코드 cell을 복사, 이동, 삭제하기 위한 picker view 추가
>> ##### 드래그 드롭 대신 커서를 이용한 편집 기능 구현 중
>> ##### Undo, Redo 기능 추가 중(Undo 정상작동하나 Redo 작동하지 않는 문제 발생)
> ### 만든 악보 공유
>> #### 악보를 서버에 업로드해서 게시판화해서 운영한다
>> #### 평점을 매길 수 있도록 한다
>> #### 다운로드받아서 오프라인으로 사용할 수 있도록 한다
---
## 수익 모델?
> ### 악보를 제작자가 팔 수 있도록 하고 수수료 받기
> ### 기능 잠금해제
> ### 저장공간 제한
> ### 광고 삽입
---
## 앱에 사용된 기술
> ### Layout -> 코드 기반 AutoLayout (NSLayoutConstraint 인스턴스)
>> #### 다른 구현 방법 : Storyboard, Snapkit 등 
> ### DB -> CoreData
> ### 오디오 기능 -> AVFoundation, AudioKit
> ### HTTP request: URLSession
> ### SwiftLint
