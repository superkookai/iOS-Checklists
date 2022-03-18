//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Weerawut Chaiyasomboon on 4/3/2565 BE.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count{
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataModel.lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        if let temp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            cell = temp
        }else{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let checklist = dataModel.lists[indexPath.row]
        
        cell.textLabel?.text = checklist.name
        
        let countUnchecked = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel?.text = "(No Items)"
        }else{
            cell.detailTextLabel?.text = countUnchecked == 0 ? "All done" : "\(countUnchecked) Remaining"
        }
        
        cell.imageView?.image = UIImage(named: checklist.iconName)
        
        cell.accessoryType = .detailDisclosureButton

        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        controller.checklistToEdit = dataModel.lists[indexPath.row]
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destination as! ChecklistViewController
            controller.checkList = sender as? Checklist
        }else if segue.identifier == "AddChecklist"{
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    

}

//MARK: - ListDetailViewControllerDelegate

extension AllListsViewController: ListDetailViewControllerDelegate{
    
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        
//        let newRowIndex = dataModel.lists.count
//
//        dataModel.lists.append(checklist)
//
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
        
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        
//        if let index = dataModel.lists.firstIndex(of: checklist){
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath){
//                cell.textLabel?.text = checklist.name
//            }
//        }
        
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    
}


//MARK: - UINavigationControllerDelegate

extension AllListsViewController: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        //Was Back button tap?
        if viewController === self{
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
