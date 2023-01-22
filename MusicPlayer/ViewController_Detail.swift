//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 이선영 on 2023/01/19.
//

import UIKit
import AVFoundation

class ViewController_Detail: UIViewController {
    
    var countries:Country?
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSinger: UILabel!
    
    var player: AVAudioPlayer!
    var timer: Timer!
    
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var lblCurrentTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet var progressSlider: UISlider!
    
    @IBOutlet weak var slVolume: UISlider!
    
    @IBOutlet weak var kakaoButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var snsButton: UIButton!
    
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let countries = countries {
            musicImage.image = UIImage(named: countries.imageName)
            lblName.text = countries.name
            lblSinger.text = countries.state
        }
        
        musicImage.layer.cornerRadius = 15 //이미지 라운드 처리
        
        self.initializePlayer()
        
        Menu()
    }

    func initializePlayer() { //플레이어 초기화 메쏘드
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else {
            print("음원 파일 에셋을 가져올 수 없습니다")
            return
        }
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
        self.progressSlider.maximumValue = Float(self.player.duration)
        self.progressSlider.minimumValue = 0
        self.progressSlider.value = Float(self.player.currentTime)
    }
    
    func updateTimeLabelText(time: TimeInterval) { //레이블 매초마다 업데이트하는 메쏘드
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        
        self.lblCurrentTime.text = timeText
        self.lblEndTime.text = String(player.duration)
    }
    
    func makeAndFireTimer() { //타이머를 만들어주는 메쏘드
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
          
            if self.progressSlider.isTracking { return }
            
            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }
    
    func invalidateTimer() { //타이머 해제해주는 메쏘드
        self.timer.invalidate()
        self.timer = nil
    }

    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.player?.play()
            self.makeAndFireTimer()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.selected)
        } else {
            self.player?.pause()
            self.invalidateTimer()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        }
//        if sender.isSelected {
//            self.makeAndFireTimer()
//        } else {
//            self.invalidateTimer()
//        }
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        self.player.currentTime = TimeInterval(sender.value)
    }
    //볼륨
    @IBAction func slChangeVolume(_ sender: UISlider) {
        player.volume = slVolume.value
    }
    
    //공유
    @IBAction func actShare(_ sender: Any) {
        let alert = UIAlertController(title: "공유", message: "\n\n\n\n\n", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "취소", style: .cancel) { _ in
        }
        alert.addAction(action1)
        
        kakaoButton.frame = CGRect(x: 70, y: 60, width: 50, height: 50)
        alert.view.addSubview(kakaoButton)
        facebookButton.frame = CGRect(x: 160, y: 60, width: 50, height: 50)
        alert.view.addSubview(facebookButton)
        snsButton.frame = CGRect(x: 250, y: 60, width: 50, height: 50)
        alert.view.addSubview(snsButton)

        present(alert, animated: true)
    }
    @IBAction func actKakao(_ sender: Any) {
        // URLScheme 문자열을 통해 URL 인스턴스를 만들어 줍니다.
        if let url = NSURL(string: "kakaolink://"),
           //canOpenURL(_:) 메소드를 통해서 URL 체계를 처리하는 데 앱을 사용할 수 있는지 여부를 확인
           UIApplication.shared.canOpenURL(url as URL) {
            //사용가능한 URLScheme이라면 open(_:options:completionHandler:) 메소드를 호출해서
            //만들어둔 URL 인스턴스를 열어줍니다.
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    @IBAction func actFacebook(_ sender: Any) {
        if let url = NSURL(string: "https://apps.apple.com/kr/app/facebook/id284882215"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    @IBAction func actSns(_ sender: Any) {
        if let url = NSURL(string: "sms://"),
           UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    // 메뉴 생성
    func Menu() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "플레이리스트 추가", image: UIImage(systemName: "line.3.horizontal"), handler: { (_) in
//                    self.performSegue(withIdentifier: "menu_favorite", sender: (Any).self)
                }),
                UIAction(title: "좋아요 추가", image: UIImage(systemName: "heart"), handler: { (_) in
//                    self.performSegue(withIdentifier: "menu_favorite", sender: (Any).self)
                })
            ]
        }
        var demoMenu: UIMenu {
            return UIMenu(image: nil, identifier: nil, options: [], children: menuItems)
        }
        menuButton.menu = demoMenu
        menuButton.showsMenuAsPrimaryAction = true //짧게 눌러서 메뉴
    }
}

extension ViewController_Detail: AVAudioPlayerDelegate {
    //AVAudioPlayerDelegate
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {

        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류발생")
            return
        }

        let message: String
        message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"

        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)

        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in

            self.dismiss(animated: true, completion: nil)
        }

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playPauseButton.isSelected = false
        self.progressSlider.value = 0
        self.updateTimeLabelText(time: 0)
        self.invalidateTimer()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lyrics" {
            let vc = segue.destination as? ViewController_lyrics
            if let countries = countries {
                vc?.lyrics = countries.description
            }
        }
    }
}
