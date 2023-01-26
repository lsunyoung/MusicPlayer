//
//  ReiterationButton.swift
//  MusicPlayer
//
//  Created by 이선영 on 2023/01/25.
//

import UIKit

class ReiterationButton: UIButton {

    /// 반복 이미지
    var checkBoxResouces = OnOffResources(
        onImage: UIImage(systemName: "repeat.1")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), //#colorLiteral(
        offImage: UIImage(systemName: "repeat")
    ) {
        didSet {
            self.setChecked(isChecked)
        }
    }
    
    enum DefaultResource {
        static let notCheckedImage = "btn_off"
        static let checkedImage = "btn_on"
    }
    
    /// 상태 변경
    var isChecked: Bool = false {
        didSet {
            guard isChecked != oldValue else { return }
            self.setChecked(isChecked)
        }
    }
    
    /// 이미지 직접 지정 + init
    init(resources: OnOffResources) {
        super.init(frame: .zero)
        self.checkBoxResouces = resources
        commonInit()
    }
    
    /// 일반적인 init + checkBoxResources 변경
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.setImage(checkBoxResouces.offImage, for: .normal)
        
        self.addTarget(self, action: #selector(check), for: .touchUpInside)
        self.isChecked = false
    }
    
    @objc func check(_ sender: UIGestureRecognizer) {
        isChecked.toggle()
    }
    
    /// 이미지 변경
    private func setChecked(_ isChecked: Bool) {
        if isChecked == true {
            self.setImage(checkBoxResouces.onImage, for: .normal)
        } else {
            self.setImage(checkBoxResouces.offImage, for: .normal)
        }
    }
    
    class OnOffResources {
        
        let onImage: UIImage?
        let offImage: UIImage?
        
        init(onImage: UIImage?, offImage: UIImage?) {
            self.onImage = onImage
            self.offImage = offImage
        }
    }
}
