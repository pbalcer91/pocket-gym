pragma Singleton

import QtQuick
import QtQuick.Controls

QtObject {
	id: properties

	property ApplicationWindow appWindow: null
	readonly property size screenSize: (appWindow ?
											Qt.size(appWindow.width, appWindow.height)
										  : Qt.size(0,0))

	readonly property int toolBarHeight: 56

	readonly property int iconSize: 26
	readonly property int smallIconSize: 18

	readonly property int smallMargin: 12
	readonly property int margin: 24
	readonly property int padding: 8
	readonly property int buttonPadding: 6

	readonly property int radius: 10
	readonly property int buttonRadius: 20

	readonly property int selectIndicatorHeight: 2
}
