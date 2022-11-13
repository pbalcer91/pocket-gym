import QtQuick
import QtQuick.Controls

import Properties

Label {
	id: label

	font: Fonts.base

	lineHeightMode: Text.FixedHeight
	lineHeight: Fonts.baseHeight

	verticalAlignment: Text.AlignVCenter

	color: "black"

	wrapMode: Text.Wrap

	elide: Text.ElideNone
}
