import QtQuick
import QtQuick.Controls

import Properties

Label {
	id: label

	font: Fonts.base

	lineHeightMode: Text.FixedHeight
	lineHeight: Fonts.baseHeight

	verticalAlignment: Text.AlignVCenter

	color: Colors.text

	wrapMode: Text.Wrap

	elide: Text.ElideNone
}
