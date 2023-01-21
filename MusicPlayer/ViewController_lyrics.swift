//
//  ViewController_lyrics.swift
//  MusicPlayer
//
//  Created by 이선영 on 2023/01/19.
//

import UIKit

class ViewController_lyrics: UIViewController {

    @IBOutlet weak var lbllyrics: UILabel!
    
    var lyrics: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let lyrics = lyrics {
            lbllyrics.text = lyrics
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
