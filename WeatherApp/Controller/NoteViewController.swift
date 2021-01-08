//
//  NoteViewController.swift
//  WeatherApp
//
//  Created by Jieun Bae on 1/5/21.
//

import UIKit

class NoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let tableView: UITableView =
        
        {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        
        return table
        }()
    
    private var notes = [Note]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Note"
        view.addSubview(tableView)
        getNote()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(pressCancel))
        
        }
    
    @objc private func pressCancel()
    
        {
        self.dismiss(animated: true, completion: nil)
                
        }
            
    @objc private func pressAdd()
    
        {
        let alert = UIAlertController(title: "Add New Note", message: "What would you like to add?", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title:"Submit", style: .cancel, handler: { [weak self] _ in
        guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
        return
            
        }
            self?.addNote(name: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = note.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
        {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = notes[indexPath.row]
        let line = UIAlertController(title: "Edit", message: "", preferredStyle: .actionSheet)
       
        line.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       
        line.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
        let alert = UIAlertController(title: "Edit note", message: "What would you like to edit?", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = item.name
        alert.addAction(UIAlertAction(title:"Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                    
        }
        self?.updateNote(item: item, newName: newName)
            }))
            self.present(alert, animated: true)
        }))
        line.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteNote(item: item)
        }))
                
        
        present(line, animated: true)
        }
    
        func getNote() {
        do{
        notes = try context.fetch(Note.fetchRequest())
            
        DispatchQueue.main.async{
        self.tableView.reloadData()
        }
        }
        catch {
           
        }
    }
    
    func addNote(name: String) {
        let new = Note(context: context)
        new.name = name
        new.date = Date()
        
        do {
            try context.save()
            getNote()
        }
        catch {
            
        }
    }
    
    func deleteNote(item: Note) {
        context.delete(item)
        
        do {
            try context.save()
            getNote()
        }
        catch {
            
        }
    }
    
    func updateNote(item: Note, newName: String) {
        item.name = newName
        do {
            try context.save()
            getNote()
        }
        catch {
            
        }
        
    }
}
