plugins {
    `java-gradle-plugin`
    `maven-publish`
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(21))
    }
}

repositories {
    mavenCentral()
    gradlePluginPortal()
}

dependencies {
    implementation("com.github.spotbugs.snom:spotbugs-gradle-plugin:6.0.7")
    implementation("org.owasp:dependency-check-gradle:10.0.2")

    testImplementation("junit:junit:4.13.2")
}

gradlePlugin {
    plugins {
        create("flosswareStandards") {
            id = "org.flossware.standards"
            implementationClass = "org.flossware.gradle.FlosswareStandardsPlugin"
            displayName = "FlossWare Build Standards"
            description = "Convention plugin enforcing FlossWare quality standards: Checkstyle, PMD, SpotBugs, JaCoCo, version format validation"
        }
    }
}

testing {
    suites {
        val functionalTest by registering(JvmTestSuite::class) {
            useJUnit()
            dependencies {
                implementation(project())
            }
        }
    }
}

gradlePlugin.testSourceSets.add(sourceSets["functionalTest"])

tasks.named<Task>("check") {
    dependsOn(testing.suites.named("functionalTest"))
}

tasks.processResources {
    from(rootProject.file("../src/main/resources")) {
        include("flossware-checkstyle.xml")
        include("flossware-pmd-ruleset.xml")
        include("flossware-spotbugs-exclude.xml")
        include("jacoco-pragmatic-excludes.xml")
    }
}

publishing {
    repositories {
        maven {
            name = "packagecloud"
            url = uri("https://packagecloud.io/flossware/releases/maven2/")
            credentials(HttpHeaderCredentials::class) {
                name = "Authorization"
                value = "Bearer ${System.getenv("PACKAGECLOUD_TOKEN") ?: ""}"
            }
            authentication {
                create<HttpHeaderAuthentication>("header")
            }
        }
    }
}
