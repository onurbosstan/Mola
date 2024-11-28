//
//  MonthlyNotesChartVC.swift
//  Mola
//
//  Created by Onur Bostan on 28.11.2024.
//

import UIKit
import Charts
import DGCharts

class MonthlyNotesChartVC: UIViewController {
    @IBOutlet weak var chartView: BarChartView!
    var viewModel = MonthlyNotesChartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChartView()
        loadChartData()
        
    }
    private func setupChartView() {
        chartView.noDataText = "Veri Bulunamadı."
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.granularity = 1
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        
        let months = ["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        chartView.xAxis.setLabelCount(12, force: false)
    }
    private func loadChartData() {
        viewModel.fetchNotes { [weak self] success in
            guard let self = self else { return }
                if success {
                self.updateChartData()
            } else {
                print("Veri alınırken hata oluştu")
            }
        }
    }
        
    private func updateChartData() {
        let monthlyData = viewModel.monthlyNoteCounts
        var dataEntries: [BarChartDataEntry] = []

        for (month, count) in monthlyData {
            dataEntries.append(BarChartDataEntry(x: Double(month), y: Double(count)))
        }

        let dataSet = BarChartDataSet(entries: dataEntries, label: "Notlar")
        dataSet.colors = [UIColor.systemBlue]
        let data = BarChartData(dataSet: dataSet)
        
        DispatchQueue.main.async {
            self.chartView.data = data
            self.chartView.notifyDataSetChanged()
        }
    }
}
