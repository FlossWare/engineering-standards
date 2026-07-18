plugins {
    java
    id("org.flossware.standards") version "2.0"
}

group = "org.flossware"
version = "1.0"

flosswareStandards {
    coverageMode.set("strict")
    javaVersion.set(21)
}

repositories {
    mavenCentral()
    maven {
        url = uri("https://packagecloud.io/flossware/releases/maven2/")
    }
}

dependencies {
    testImplementation("org.junit.jupiter:junit-jupiter:5.10.2")
    testImplementation("org.mockito:mockito-inline:5.2.0")
}
