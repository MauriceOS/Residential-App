plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "org.ncrra.memberapp"
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "org.ncrra.memberapp"
        manifestPlaceholders["appAuthRedirectScheme"] = "ncrra"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        val stagingKeystore = System.getenv("NCRRA_STAGING_KEYSTORE")
        val stagingStorePassword = System.getenv("NCRRA_STAGING_STORE_PASSWORD")
        val stagingKeyAlias = System.getenv("NCRRA_STAGING_KEY_ALIAS")
        val stagingKeyPassword = System.getenv("NCRRA_STAGING_KEY_PASSWORD")
        if (stagingKeystore != null && stagingStorePassword != null && stagingKeyAlias != null && stagingKeyPassword != null) {
            create("ncrraStaging") {
                storeFile = file(stagingKeystore)
                storePassword = stagingStorePassword
                keyAlias = stagingKeyAlias
                keyPassword = stagingKeyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (System.getenv("NCRRA_STAGING_KEYSTORE") != null) {
                signingConfigs.getByName("ncrraStaging")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
