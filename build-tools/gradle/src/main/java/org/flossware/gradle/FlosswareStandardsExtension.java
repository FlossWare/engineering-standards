package org.flossware.gradle;

import org.gradle.api.Project;
import org.gradle.api.provider.Property;

public abstract class FlosswareStandardsExtension {

    private final Property<String> coverageMode;
    private final Property<Integer> javaVersion;
    private final Property<Boolean> checkstyleEnabled;
    private final Property<Boolean> pmdEnabled;
    private final Property<Boolean> spotbugsEnabled;
    private final Property<Boolean> jacocoEnabled;
    private final Property<Boolean> owaspEnabled;
    private final Property<Boolean> versionValidationEnabled;

    public FlosswareStandardsExtension(final Project project) {
        coverageMode = project.getObjects().property(String.class).convention("strict");
        javaVersion = project.getObjects().property(Integer.class).convention(21);
        checkstyleEnabled = project.getObjects().property(Boolean.class).convention(true);
        pmdEnabled = project.getObjects().property(Boolean.class).convention(true);
        spotbugsEnabled = project.getObjects().property(Boolean.class).convention(true);
        jacocoEnabled = project.getObjects().property(Boolean.class).convention(true);
        owaspEnabled = project.getObjects().property(Boolean.class).convention(false);
        versionValidationEnabled = project.getObjects().property(Boolean.class).convention(true);
    }

    public Property<String> getCoverageMode() {
        return coverageMode;
    }

    public Property<Integer> getJavaVersion() {
        return javaVersion;
    }

    public Property<Boolean> getCheckstyleEnabled() {
        return checkstyleEnabled;
    }

    public Property<Boolean> getPmdEnabled() {
        return pmdEnabled;
    }

    public Property<Boolean> getSpotbugsEnabled() {
        return spotbugsEnabled;
    }

    public Property<Boolean> getJacocoEnabled() {
        return jacocoEnabled;
    }

    public Property<Boolean> getOwaspEnabled() {
        return owaspEnabled;
    }

    public Property<Boolean> getVersionValidationEnabled() {
        return versionValidationEnabled;
    }
}
