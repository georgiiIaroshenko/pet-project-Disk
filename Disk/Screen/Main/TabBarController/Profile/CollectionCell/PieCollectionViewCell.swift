//
//  MainCollectionViewCell.swift
//  Disk
//
//  Created by Георгий on 17.08.2024.
//

import UIKit
import DGCharts

class PieCollectionViewCell: UICollectionViewCell, ImageRequestProtocol {
    
    private var pieStructViewCell: PieMassiveViewCell = PieMassiveViewCell(usedSizeDouble: 5, usedSizeString: "", freeSizeDouble: 5, freeSizeString: "", fullSizeString: "")
    private var pieChart = PieChartView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCharts()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCharts() {
        contentView.addSubview(pieChart)
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        pieChart.holeColor = UIColor.clear
        pieChart.transparentCircleColor = UIColor.clear
        pieChart.chartDescription.enabled = false
        pieChart.legend.enabled = false
        pieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInCubic)
        updateChartData()
    }
    
    func setup(pieMassiveViewCell: PieMassiveViewCell) {
        self.pieStructViewCell = pieMassiveViewCell
    }
    
    // MARK: - Chart Methods
    
    func updateChartData() {
        
        let usedSpace = pieStructViewCell.usedSizeDouble
        let freeSpace = pieStructViewCell.freeSizeDouble
        
        let dataEntries = [
            PieChartDataEntry(value: usedSpace, label: pieStructViewCell.usedSizeString),
            PieChartDataEntry(value: freeSpace, label: pieStructViewCell.freeSizeString)
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.colors = [UIColor.systemOrange, UIColor.systemGreen]
        dataSet.sliceSpace = 4
        dataSet.selectionShift = 10
        let data = PieChartData(dataSet: dataSet)
        data.setValueTextColor(.black)
        data.setValueFont(UIFont.systemFont(ofSize: 14, weight: .bold))
        
        pieChart.data = data
        pieChart.centerAttributedText = createCenterText(fullSize: pieStructViewCell.fullSizeString)
        pieChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeInCubic)
        pieChart.notifyDataSetChanged()
    }
    
    // MARK: - Constraints
    
    func setupConstraints() {
        pieChart.snp.makeConstraints { make in
            make.edges.equalTo(350)
        }
    }
}

extension PieCollectionViewCell {
    // MARK: - Helper Methods
    
    func createCenterText(fullSize: String?) -> NSAttributedString {
        let fullSizeText = fullSize ?? "Общий размер"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        return NSAttributedString(
            string: fullSizeText,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
                .paragraphStyle: paragraphStyle
            ]
        )
    }
}

