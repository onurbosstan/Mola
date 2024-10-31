//
//  CalendarVC.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    @IBOutlet weak var calendarContainerView: UIView!
    var calendarView: FSCalendar!
    var notesViewModel = NotesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView = FSCalendar()
        calendarView.delegate = self
        calendarView.dataSource = self
     
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarContainerView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: calendarContainerView.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: calendarContainerView.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: calendarContainerView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarContainerView.trailingAnchor)
        ])
        notesViewModel.loadNotes {
            self.calendarView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesViewModel.loadNotes {
            DispatchQueue.main.async {
                self.calendarView.reloadData()
                self.calendarView.setCurrentPage(Date(), animated: false)
            }
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            let notes = notesViewModel.getNotes(for: date)
            
            if notes.isEmpty {
                let alert = UIAlertController(title: "Uyarı", message: "Bu tarihte yazdığınız not bulunmamaktadır.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if let notesVC = storyboard?.instantiateViewController(withIdentifier: "NotesVC") as? NotesVC {
                    notesVC.selectedDate = date
                    notesVC.isFiltered = true
                    self.navigationController?.pushViewController(notesVC, animated: true)
                }
            }
        }
}
