import QtQuick
import QtQuick.Shapes

import Components
import Properties

Item {
	id: form

	property int size

	implicitWidth: form.size
	implicitHeight: form.size

	anchors.centerIn: parent

	z: 999

	signal spinnersStopped

	property bool isInfinite: false

	Behavior on opacity {
		NumberAnimation {
			duration: 250
		}
	}

	Timer {
		id: signalTimer

		interval: 100
		onTriggered: {
			spinnersStopped()
		}
	}

	Shape {
		id: spinnerOne

		property int spinnerSize: form.size

		width: spinnerSize
		height: spinnerSize

		anchors.centerIn: parent
		z: 99

		ShapePath {
			fillColor: "transparent"
			strokeColor: Colors.primary
			strokeWidth: 2
			capStyle: ShapePath.RoundCap

			PathAngleArc {
				centerX: spinnerOne.spinnerSize / 2
				centerY: spinnerOne.spinnerSize / 2
				radiusX: spinnerOne.spinnerSize / 2
				radiusY: spinnerOne.spinnerSize / 2
				startAngle: 75
				sweepAngle: 140
			}
		}

		RotationAnimation on rotation {
			loops: (isInfinite ? Animation.Infinite : 1)
			from: 0
			to: (isInfinite ? -360 : -180)
			duration: 1000
		}
	}

	Shape {
		id: spinnerTwo

		property int spinnerSize: form.size - 20

		width: spinnerSize
		height: spinnerSize

		anchors.centerIn: parent
		z: 99

		ShapePath {
			fillColor: "transparent"
			strokeColor: Colors.primary
			strokeWidth: 2
			capStyle: ShapePath.RoundCap

			PathAngleArc {
				centerX: spinnerTwo.spinnerSize / 2
				centerY: spinnerTwo.spinnerSize / 2
				radiusX: spinnerTwo.spinnerSize / 2
				radiusY: spinnerTwo.spinnerSize / 2
				startAngle: -150
				sweepAngle: 120
			}
		}

		Behavior on spinnerSize {
			NumberAnimation {
				duration: 250
			}
		}

		RotationAnimation on rotation {
			loops: (isInfinite ? Animation.Infinite : 1)
			from: 0
			to: (isInfinite ? 360 : 180)
			duration: 1500

			onStopped: {
				spinnerTwo.spinnerSize = form.size
			}
		}
	}

	Shape {
		id: spinnerThree

		property int spinnerSize: form.size - 40

		onSpinnerSizeChanged: {
			if (spinnerSize == form.size)
				signalTimer.start()
		}

		width: spinnerSize
		height: spinnerSize

		anchors.centerIn: parent
		z: 99

		ShapePath {
			fillColor: "transparent"
			strokeColor: Colors.primary
			strokeWidth: 2
			capStyle: ShapePath.RoundCap

			PathAngleArc {
				centerX: spinnerThree.spinnerSize / 2
				centerY: spinnerThree.spinnerSize / 2
				radiusX: spinnerThree.spinnerSize / 2
				radiusY: spinnerThree.spinnerSize / 2
				startAngle: 320
				sweepAngle: 130
			}
		}

		Behavior on spinnerSize {
			NumberAnimation {
				duration: 250
			}
		}

		RotationAnimation on rotation {
			loops: (isInfinite ? Animation.Infinite : 1)
			from: 0
			to: (isInfinite ? -360 : -180)
			duration: 2000

			onStopped: {
				spinnerThree.spinnerSize = form.size
			}
		}
	}
}
