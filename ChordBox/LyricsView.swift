//
//  PutChordOnLyricsView.swift
//  ChordBox
//
//  Created by Minho Choi on 2021/02/23.
//

import UIKit

private let reuseIdentifer = "Cell"

class LyricsView : UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView : UICollectionView?
    var lyrics = [[String]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        collectionView?.dragInteractionEnabled = true
//        self.layer.borderWidth = 2
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setLayout(lyrics: String) {
        let lyricsChunks = lyrics.split(separator: "\n")
        for chunk in lyricsChunks {
            let arr = chunk.map { String($0) }
            self.lyrics.append(arr)
        }
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        collectionView?.backgroundColor = .clear
        collectionView?.register(MyCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        if let collectionView = collectionView {
            addSubview(collectionView)
        }
    }
    
    func updateLayout() {
        collectionView?.frame = frame
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return lyrics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lyrics[section].count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! MyCell
        let word = lyrics[indexPath.section][indexPath.item]
        if word.starts(with: "^") {
            let fixedChordString = word.replacingOccurrences(of: "^", with: "")
            cell.myCharacter.text = "\(fixedChordString)\n"
            cell.layer.borderColor = UIColor.CustomPalette.pointColor.cgColor
            cell.layer.borderWidth = 2.0
            cell.layer.cornerRadius = 5.0
        } else {
            let fixedLyricsChar = word.replacingOccurrences(of: "\n", with: "")
            cell.myCharacter.text = "\n\(fixedLyricsChar)"
            cell.layer.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if lyrics[indexPath.section][indexPath.item].count != 1{
            collectionView.performBatchUpdates({

                collectionView.deleteItems(at: [indexPath])
                lyrics[indexPath.section].remove(at: indexPath.item)
            })
        }
    }
    
}

// MARK: - Layout Delegate

extension LyricsView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat
        let height : CGFloat
        let text = lyrics[indexPath.section][indexPath.item]
        if text.count == 1 {
            if let ascii = text.first?.asciiValue, ascii <= 127 {
                width = 15
                height = 60
            } else {
                width = 30
                height = 60
            }
        } else {
            width = 200
            height = 60
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: - Drop Delegate

extension LyricsView : UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if session.canLoadObjects(ofClass: NSString.self) {
            return true
        }
        if session.localDragSession?.localContext as? UICollectionView == collectionView {
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            // 아이템이 본래 있던 자리(드래그가 시작된 자리)
            if let sourceIndexPath = item.sourceIndexPath {
                // 드래그한 아이템의 내용(attributedString)
                guard let chordItem = item.dragItem.localObject as? String else { break }//, let imageAR = item.dragItem.localObject as? Double{
                print(chordItem)
                    // performBatchUpdates의 효과는 모델과 뷰를 동시에 수정함으로써 싱크 유지
                collectionView.performBatchUpdates({
                    // 모델 편집 - 본래 위치에서 삭제 후 새로운 위치에 추가
                    lyrics[sourceIndexPath.section].remove(at: sourceIndexPath.item)
                    lyrics[destinationIndexPath.section].insert(chordItem, at: destinationIndexPath.item)
                    // 뷰 편집 - 전체 뷰를 업데이트할 경우 애니메이션 실행되지 않으므로 부자연스러움
                    // 따라서 아이템을 하나씩 지우고 더하는 메소드를 사용
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                    // 애니메이션 실행
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else { // 아이템이 외부에서 왔을 경우
                item.dragItem.itemProvider.loadObject(ofClass: NSString.self) { [weak self] (provider, error) in
                    if let chord = provider as? String {
                        DispatchQueue.main.async {
                            collectionView.performBatchUpdates({
                                self?.lyrics[destinationIndexPath.section].insert(chord, at: destinationIndexPath.item)
                                collectionView.insertItems(at: [destinationIndexPath])
                                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                            })
                        }
                    }
                }
            }
        }
    }
    
    
}

// MARK: - Drag Delegate

extension LyricsView: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        // cellForItem: Returns the visible cell object at the specified index path.
        let phrase = lyrics[indexPath.section]
        let item = "\(phrase[indexPath.item])"
        if item.starts(with: "^") {
            let string = UIDragItem(itemProvider: NSItemProvider(object: item as NSString))
            string.localObject = item
            return [string]
        }
        else {
            return []
        }
    }
}

// MARK: - Cell

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
        img.font = UIFont.monospacedSystemFont(ofSize: 32, weight: .regular)
        img.numberOfLines = 2
        img.adjustsFontSizeToFitWidth = true
        //자동으로 위치 정렬 금지
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    func setupView(){
        //셀에 위에서 만든 이미지 뷰 객체를 넣어준다.
        addSubview(myCharacter)
        layer.backgroundColor = UIColor.white.cgColor
        
        //제약조건 설정하기
        myCharacter.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myCharacter.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        myCharacter.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        myCharacter.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}