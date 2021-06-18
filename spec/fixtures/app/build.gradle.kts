android {
    compileSdkVersion(28)

    defaultConfig {
		versionCode = 12351
		versionName = "1.6.0" // comment
    }

    productFlavors {
		create("demo") {
			applicationIdSuffix = ".demo"
			versionCode = 124
			versionName = "1.3.0"
		}
		create("qa") {
			applicationIdSuffix = ".demo.qa"
			versionCode = 457
			versionName = "1.2.0"
		}
    }
}
