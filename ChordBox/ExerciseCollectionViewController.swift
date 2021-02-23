//
//  ExerciseCollectionViewController.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/23.
//

import UIKit

private let reuseIdentifer = "Cell"

class ExerciseCollectionViewController: UIViewController{
    
    var lyrics =
        """
So are you happy now?
Finally happy now, are you?
뭐 그대로야 난
다 잃어버린 것 같아
모든 게 맘대로 왔다가 인사도 없이 떠나
이대로는 무엇도 사랑하고 싶지 않아
다 해질 대로 해져버린
기억 속을 여행해
우리는 오렌지 태양 아래
그림자 없이 함께 춤을 춰
정해진 이별 따위는 없어
아름다웠던 그 기억에서 만나
Forever young
우우우 우우우우
우우우 우우우우
Forever, we young
우우우 우우우우
이런 악몽이라면 영영 깨지 않을게
섬 그래 여긴 섬
서로가 만든 작은 섬
예 음 forever young
영원이란 말은 모래성
작별은 마치 재난문자 같지
그리움과 같이 맞이하는 아침
서로가 이 영겁을 지나
꼭 이 섬에서 다시 만나
지나듯 날 위로하던 누구의 말대로 고작
한 뼘짜리 추억을 잊는 게 참 쉽지 않아
시간이 지나도 여전히
날 붙드는 그곳에
우리는 오렌지 태양 아래
그림자 없이 함께 춤을 춰
정해진 안녕 따위는 없어
아름다웠던 그 기억에서 만나
우리는 서로를 베고 누워
슬프지 않은 이야기를 나눠
우울한 결말 따위는 없어
난 영원히 널 이 기억에서 만나
Forever young
우우우 우우우우
우우우 우우우우
Forever, we young
우우우 우우우우
이런 악몽이라면 영영 깨지 않을게
"""
    
    let lyricsView = LyricsView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(lyricsView)
        
        NSLayoutConstraint.activate([
            lyricsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lyricsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lyricsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lyricsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutSubviews()
        lyricsView.setLayout(lyrics: lyrics)
    }
    
    

}


