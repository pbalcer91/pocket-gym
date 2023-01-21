import QtQuick
import QtQuick.Layouts
import QtCharts

import Components
import Properties

Item {
	id: content

	ColumnLayout {
		id: mainColumn

		anchors.fill: parent
		//anchors.margins: Properties.margin

		ChartView {
			id: progressChart

			width: parent.width
			height: 400

			title: "Waga"
			titleFont: Fonts.list
			titleColor: Colors.text

			backgroundColor: "transparent"

			antialiasing: true

			legend.visible: false

			LineSeries {
				color: Colors.primary

				pointsVisible: true
				width: 3



				axisX: ValuesAxis {
					color: Colors.black_70
					labelsColor: Colors.text

					labelFormat: "%d"
				}

				axisY: ValuesAxis {
					color: Colors.black_70
					labelsColor: Colors.text

					labelFormat: "%d"
				}

				XYPoint { x: 0; y: 70 }
				XYPoint { x: 1; y: 72 }
				XYPoint { x: 2; y: 74.5 }
				XYPoint { x: 3; y: 75 }
				XYPoint { x: 4; y: 77 }
				XYPoint { x: 5; y: 81 }
				XYPoint { x: 6; y: 85 }
			}
		}
	}
}
