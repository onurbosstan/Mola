//
//  CalendarViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 10.10.2024.
//

import Foundation

class CalendarViewModel {
    private var notes: [Date: [String]] = [:]
    
    func getNotes(for date: Date) -> [String] {
        return notes[date] ?? []
    }
    
    func addNote(_ note: String, for date: Date) {
        if notes[date] != nil {
            notes[date]?.append(note)
        } else {
            notes[date] = [note]
        }
    }
}
