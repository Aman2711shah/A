apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'dev.flutter.flutter-gradle-plugin'

android {
    namespace 'com.wazeet.ai'
    compileSdk flutter.compileSdkVersion
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
        coreLibraryDesugaringEnabled true
    }

    kotlinOptions {
        jvmTarget = '11'
    }

    defaultConfig {
        applicationId 'com.wazeet.ai'
        minSdk flutter.minSdkVersion
        targetSdk flutter.targetSdkVersion
        versionCode flutter.versionCode
        versionName flutter.versionName
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
}
