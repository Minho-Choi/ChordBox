//
//  PutChordOnLyricsView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/23.
//

import UIKit

class LyricsView : UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView : UICollectionView?
    var lyrics = [String.SubSequence]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
//        self.layer.borderWidth = 2
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setLayout(lyrics: String) {
        self.lyrics = lyrics.split(separator: "\n")
        print(lyrics)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 20, height: 20)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        collectionView?.register(MyCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        if let collectionView = collectionView {
            addSubview(collectionView)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return lyrics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lyrics[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! MyCell
        let phrase = "\(lyrics[indexPath.section])"
        cell.myCharacter.text = "\(phrase[phrase.index(phrase.startIndex, offsetBy: indexPath.row)])"
        return cell
    }
    
    //위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //좌우간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}


class MyCell: UICollectionViewCell{
    //부모 메서드 초기화 시켜줘야 한다.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
//        self.layer.borderWidth = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //셀에 이미지 뷰 객체를 넣어주기 위해서 생성
    let myCharacter: UILabel = {
        let img = UILabel()
        img.textAlignment = .center
        img.adjustsFontSizeToFitWidth = true
        //자동으로 위치 정렬 금지
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    func setupView(){
        backgroundColor = .yellow
        //셀에 위에서 만든 이미지 뷰 객체를 넣어준다.
        addSubview(myCharacter)
        //제약조건 설정하기
        myCharacter.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myCharacter.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        myCharacter.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        myCharacter.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    }
}
