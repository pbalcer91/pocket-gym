pragma Singleton

import QtQuick

QtObject {
	id: colors

	readonly property color primary_light: "#92c0ef"
	readonly property color primary: "#72a0cf"
	readonly property color primary_30: "#5072a0cf"
	readonly property color primary_70: "#9972a0cf"
	readonly property color white: "#ffffff"
	readonly property color black: "#141414"
	readonly property color black_30: "#50141414"
	readonly property color black_70: "#99141414"
	readonly property color darkGray: "#2c2c2c"

	readonly property color background: "#4d4d4d"
	readonly property color sectionBackground: "#802c2c2c"
	readonly property color text: "#c7c7c7"
	readonly property color text_50: "#70c7c7c7"
	readonly property color input: "#d3d3d3"
	readonly property color disabledButton: "#c7c7c7"
	readonly property color error: "#d67267"
	readonly property color accept: "#52cc72"
}
