import QtQuick
import QtQuick.Layouts

import Properties

ListView {
	id: listView

	property string emptyInfo: ""

	clip: true

	spacing: 8

	currentIndex: -1

	implicitHeight: (listView.count == 0 ?
						 60
					   : contentHeight)

	implicitWidth: contentWidth

	Layout.topMargin: (listView.count == 0 ?
						   0
						 : Properties.smallMargin)

	PLabel {
		id: emptyInfoLabel

		anchors.centerIn: parent

		horizontalAlignment: Text.AlignHCenter

		text: listView.emptyInfo

		font: Fonts.caption
		lineHeight: Fonts.captionHeight

		visible: (listView.count == 0 && listView.emptyInfo != "")
	}
}
