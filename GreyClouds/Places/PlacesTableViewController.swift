//
//  PlacesTableViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 01.06.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {

    let cities:[String] = ["Wrocław", "London"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        default:
            return 44
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cities.count
        default:
            return 1
        }
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = self.getCellNameFor(section: indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)

        if indexPath.section == 0 {
            if let cityTableViewCell = cell as? CityTableViewCell {
                cityTableViewCell.cityLabelOutlet.text = cities[indexPath.row]
            }
        }

        return cell
    }

    private func getCellNameFor(section: Int) -> String {
        switch section {
        case 0:
            return "city-cell"
        case 1:
            return "city-settings-cell"
        default:
            return ""
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
