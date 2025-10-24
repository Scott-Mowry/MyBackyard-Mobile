import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("stg") {
            dimension = "flavor-type"
            applicationId = "com.app.mybackyardusa1.stg"
            resValue(type = "string", name = "app_name", value = "[Stg]My Backyard")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.app.mybackyardusa1"
            resValue(type = "string", name = "app_name", value = "My Backyard")
        }
    }
}