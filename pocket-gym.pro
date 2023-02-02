QT += quick svg charts network

SOURCES += \
	databasehandler.cpp \
	exercise.cpp \
	main.cpp \
	maincontroller.cpp \
	measurement.cpp \
	training.cpp \
	trainingplan.cpp \
	user.cpp \
	usertrainingsmanager.cpp

resources.files = main.qml
resources.prefix = /$${TARGET}

RESOURCES += qml.qrc \
	fonts.qrc \
	icons.qrc \
	images.qrc

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

include(android_openssl/openssl.pri)

HEADERS += \
	databasehandler.h \
	exercise.h \
	maincontroller.h \
	measurement.h \
	training.h \
	trainingplan.h \
	user.h \
	usertrainingsmanager.h
