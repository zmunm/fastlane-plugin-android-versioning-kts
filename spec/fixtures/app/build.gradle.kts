android {
	compileSdkVersion(28)
	buildToolsVersion = "30.0.3"

	defaultConfig {
		versionCode = 12345
		versionName = "1.0.0" // comment
	}

	productFlavors {
		create("demo") {
			applicationIdSuffix = ".demo"
			versionCode = 123
			versionName = "1.2.1"
		}
		create("qa") {
			applicationIdSuffix = ".demo.qa"
			versionCode = 456
			versionName = "1.1.1"
		}
	}
}
