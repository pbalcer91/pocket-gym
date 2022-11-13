QT += quick svg

SOURCES += \
        logging.cpp \
        main.cpp

resources.files = main.qml 
resources.prefix = /$${TARGET}

RESOURCES += qml.qrc \
	fonts.qrc \
	icons.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/qml

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH = $$PWD/qml

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
	android/AndroidManifest.xml \
	android/build.gradle \
	android/gradle.properties \
	android/gradle/wrapper/gradle-wrapper.jar \
	android/gradle/wrapper/gradle-wrapper.properties \
	android/gradlew \
	android/gradlew.bat \
	android/res/values/libs.xml

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
	ANDROID_PACKAGE_SOURCE_DIR = \
		$$PWD/android
}

HEADERS += \
	logging.h
