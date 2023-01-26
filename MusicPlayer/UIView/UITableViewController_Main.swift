//
//  UITableViewController_Main.swift
//  MusicPlayer
//
//  Created by 이선영 on 2023/01/19.
//

import UIKit

class UITableViewController_Main: UITableViewController {
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Music"
        tableView.dataSource = self
        tableView.rowHeight = 120
        Menu()
        self.tableView.keyboardDismissMode = .onDrag //스크롤 시 키보드 내림
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))) //화면 터치 시 키보드 내림
    }
    @objc func handleTap(sender: UITapGestureRecognizer) { //화면 터치 시 키보드 내림
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    // 네비게이션 아이템 버튼 메뉴 생성
    func Menu() {
        var menuItems: [UIAction] {
            return [
                UIAction(title: "플레이리스트", image: UIImage(systemName: "line.3.horizontal"), handler: { (_) in
                    self.performSegue(withIdentifier: "menu_favorite", sender: (Any).self)
                }),
                UIAction(title: "좋아요", image: UIImage(systemName: "heart"), handler: { (_) in
                    self.performSegue(withIdentifier: "menu_favorite", sender: (Any).self)
                })
            ]
        }
        var demoMenu: UIMenu {
            return UIMenu(image: nil, identifier: nil, options: [], children: menuItems)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "line.horizontal.3.circle"), primaryAction: nil, menu: demoMenu)
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let countries = countries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "musiccell", for: indexPath)
        let musicImage = cell.viewWithTag(1) as? UIImageView
        musicImage?.image = UIImage(named: countries.imageName)
        
        let lblName = cell.viewWithTag(2) as? UILabel
        lblName?.text = countries.name
        
        let lblSinger = cell.viewWithTag(3) as? UILabel
        lblSinger?.text = countries.state

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "musicdetail" {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {return}
            let vc = segue.destination as? ViewController_Detail
            vc?.countries = countries[selectedIndexPath.row]
        }
    }


}
