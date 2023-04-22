//
//  ViewController.swift
//  RandomGenerator
//
//  Created by Mac  on 2023/4/22.
//

import UIKit


let INITIALLOWERBOUND = 0
let INITIALUPPERBOUND = 9999999

class RangedNumberGenerationCell: UITableViewCell {
    var index = 0
    @IBOutlet weak var Number: UILabel!
    @IBOutlet weak var LowerBound: UITextField!
    @IBOutlet weak var UpperBound: UITextField!
    @IBOutlet weak var GenerateButton: UIButton!

    @IBAction func TextFieldEnd(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func Generate(_ sender: UIButton) {
        var lower_bound: Int?
        var upper_bound: Int?
        if Int(LowerBound.text!) != nil {
            if Int(UpperBound.text!) != nil{
                upper_bound = Int(UpperBound.text!)
                lower_bound = Int(LowerBound.text!)
            } else {
                return
            }
        } else {
            return
        }
        if lower_bound! > upper_bound! {
            swap(&lower_bound, &upper_bound)
            LowerBound.text = String(lower_bound!)
            UpperBound.text = String(upper_bound!)
        }
        let difference = upper_bound! - lower_bound! + 1
        Numbers[index] = (Int(arc4random()) % difference) + lower_bound!
        Number.text = String(Numbers[index])
    }
}

var Numbers = [0]

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var editingStyle = 0
    @IBOutlet weak var GenerationBoard: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RangedNumberGenerationCell") as! RangedNumberGenerationCell
        cell.Number.text = String(Numbers[indexPath.row])
        cell.LowerBound.text = String(INITIALLOWERBOUND)
        cell.UpperBound.text = String(INITIALUPPERBOUND)
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //print(editingStyle)
        if editingStyle == 0 {
            return .delete
        } else if editingStyle == 1 {
            return .insert
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Numbers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    
    @IBAction func GenerateNumbers(_ sender: UIButton) {
        let top = Numbers.count - 1
        if top < 0 {
            return
        }
        for i in 0...top {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = GenerationBoard.cellForRow(at: indexPath) as! RangedNumberGenerationCell
            cell.Generate(cell.GenerateButton)
        }
    }
    @IBAction func AddRow(_ sender: UIButton) {
        Numbers.append(0)
        GenerationBoard.reloadData()
    }
    
    @IBAction func DeleteRow(_ sender: UIButton) {
        if !GenerationBoard.isEditing || editingStyle == 0 {
            editingStyle = 0
            GenerationBoard.isEditing = !GenerationBoard.isEditing
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("didLoad")
        // Do any additional setup after loading the view.
    }


}

