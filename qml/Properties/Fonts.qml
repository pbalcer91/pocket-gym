pragma Singleton
import QtQuick

QtObject {
	id: fonts

	property var nunito: QtObject {
		id: nunito
		property FontLoader black: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-Black.ttf"
		}

		property FontLoader blackItalic: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-BlackItalic.ttf"
		}

		property FontLoader bold: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-Bold.ttf"
		}

		property FontLoader boldItalic: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-BoldItalic.ttf"
		}

		property FontLoader extraBold: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-ExtraBold.ttf"
		}

		property FontLoader extraBoldItalic: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-ExtraBoldItalic.ttf"
		}

		property FontLoader extraLight: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-ExtraLight.ttf"
		}

		property FontLoader extraLightItalic: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-ExtraLightItalic.ttf"
		}

		property FontLoader italic: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-Italic.ttf"
		}

		property FontLoader light: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-Light.ttf"
		}

		property FontLoader lightItalic: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-LightItalic.ttf"
		}

		property FontLoader regular: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-Regular.ttf"
		}

		property FontLoader semiBold: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-SemiBold.ttf"
		}

		property FontLoader semiBoldItalic: FontLoader {
			source: "qrc:/fonts/Nunito/Nunito-SemiBoldItalic.ttf"
		}
	}

	property var weight: QtObject {
		id: weight

		readonly property int black: Font.Black
		readonly property int extraBold: Font.ExtraBold
		readonly property int bold: Font.Bold
		readonly property int semiBold: Font.DemiBold
		readonly property int regular: Font.Normal
		readonly property int light: Font.Light
	}

	// font template

	readonly property font base: Qt.font({
		family: nunito.regular.name,
		weight: weight.regular,
		pixelSize: 18,
	})
	readonly property int baseHeight: 24

	readonly property font input: Qt.font({
		family: nunito.regular.name,
		weight: weight.regular,
		pixelSize: 16,
		letterSpacing: 0.6,
	})
	readonly property int inputHeight: 24

	readonly property font inputLabel: Qt.font({
		family: nunito.bold.name,
		weight: weight.bold,
		pixelSize: 12,
		letterSpacing: 0.4,
	})
	readonly property int inputLabelHeight: 24

	readonly property font info: Qt.font({
		family: nunito.light.name,
		weight: weight.light,
		pixelSize: 12,
		letterSpacing: 0.4,
	})
	readonly property int infoHeight: 18


	readonly property font button: Qt.font({
		family: nunito.extraBold.name,
		weight: weight.extraBold,
		pixelSize: 12,
		letterSpacing: 0.4,
		capitalization: Font.AllUppercase
	})
	readonly property int buttonHeight: 24

	readonly property font floatingButton: Qt.font({
		family: nunito.bold.name,
		weight: weight.bold,
		pixelSize: 14,
		letterSpacing: 1.2,
		capitalization: Font.AllUppercase
	})
	readonly property int floatingButtonHeight: 24

	readonly property font subTitle: Qt.font({
		family: nunito.bold.name,
		weight: weight.bold,
		pixelSize: 18,
		letterSpacing: 0.6,
		capitalization: Font.AllUppercase
	})
	readonly property int subTitleHeight: 32


	readonly property font list: Qt.font({
		family: nunito.semiBold.name,
		weight: weight.semiBold,
		pixelSize: 18,
		letterSpacing: 0.4,
	})
	readonly property int listHeight: 32

	readonly property font captionBold: Qt.font({
		family: nunito.bold.name,
		weight: weight.bold,
		pixelSize: 16,
		letterSpacing: -0.4,
	})
	readonly property int captionBoldHeight: 20

	readonly property font caption: Qt.font({
		family: nunito.regular.name,
		weight: weight.regular,
		pixelSize: 16,
		letterSpacing: -0.4,
	})
	readonly property int captionHeight: 20

	readonly property font title: Qt.font({
		family: nunito.extraBold.name,
		weight: weight.extraBold,
		pixelSize: 20,
		letterSpacing: 0.6,
		capitalization: Font.AllUppercase
	})
	readonly property int titleHeight: 38

	readonly property font tumblerMainLabel: Qt.font({
		family: nunito.bold.name,
		weight: weight.bold,
		pixelSize: 42,
		letterSpacing: 0.6,
		capitalization: Font.AllUppercase
	})
	readonly property int tumblerMainLabelHeight: 54

	readonly property font tumblerSubLabel: Qt.font({
		family: nunito.regular.name,
		weight: weight.regular,
		pixelSize: 24,
		letterSpacing: 0.6,
		capitalization: Font.AllUppercase
	})
	readonly property int tumblerSubLabelHeight: 32

}
