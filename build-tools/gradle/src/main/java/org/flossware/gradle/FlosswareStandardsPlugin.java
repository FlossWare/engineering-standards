package org.flossware.gradle;

import com.github.spotbugs.snom.Confidence;
import com.github.spotbugs.snom.Effort;
import com.github.spotbugs.snom.SpotBugsExtension;
import com.github.spotbugs.snom.SpotBugsTask;
import org.gradle.api.GradleException;
import org.gradle.api.Plugin;
import org.gradle.api.Project;
import org.gradle.api.plugins.JavaPluginExtension;
import org.gradle.api.plugins.quality.Checkstyle;
import org.gradle.api.plugins.quality.CheckstyleExtension;
import org.gradle.api.plugins.quality.Pmd;
import org.gradle.api.plugins.quality.PmdExtension;
import org.gradle.api.tasks.compile.JavaCompile;
import org.gradle.api.tasks.testing.Test;
import org.gradle.jvm.toolchain.JavaLanguageVersion;
import org.gradle.testing.jacoco.plugins.JacocoPluginExtension;
import org.gradle.testing.jacoco.tasks.JacocoCoverageVerification;
import org.gradle.testing.jacoco.tasks.JacocoReport;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class FlosswareStandardsPlugin implements Plugin<Project> {

    private static final String STANDARDS_DIR = "flossware-standards";

    private static final List<String> PRAGMATIC_EXCLUDES = Arrays.asList(
        "**/*Application.class",
        "**/Main.class",
        "**/*Main.class",
        "**/*CLI.class",
        "**/*Util.class",
        "**/*Utils.class",
        "**/*Helper.class",
        "**/*Helpers.class",
        "**/*Constants.class",
        "**/dto/**/*DTO.class",
        "**/dto/**/*Request.class",
        "**/dto/**/*Response.class",
        "**/model/**/*Record.class",
        "**/entity/**/*Entity.class",
        "**/generated/**",
        "**/*Builder.class",
        "**/config/**/*Config.class",
        "**/configuration/**/*Configuration.class"
    );

    @Override
    public void apply(final Project project) {
        final FlosswareStandardsExtension ext = project.getExtensions()
            .create("flosswareStandards", FlosswareStandardsExtension.class, project);

        project.getPluginManager().apply("java");

        project.getTasks().withType(Test.class).configureEach(test -> test.useJUnitPlatform());

        project.getTasks().withType(JavaCompile.class).configureEach(task ->
            task.getOptions().setEncoding("UTF-8")
        );

        configureVersionValidation(project, ext);

        project.afterEvaluate(p -> {
            configureJavaToolchain(p, ext);

            if (Boolean.TRUE.equals(ext.getCheckstyleEnabled().get())) {
                configureCheckstyle(p);
            }

            if (Boolean.TRUE.equals(ext.getPmdEnabled().get())) {
                configurePmd(p);
            }

            if (Boolean.TRUE.equals(ext.getSpotbugsEnabled().get())) {
                configureSpotbugs(p);
            }

            if (Boolean.TRUE.equals(ext.getJacocoEnabled().get())) {
                configureJacoco(p, ext);
            }

            if (Boolean.TRUE.equals(ext.getOwaspEnabled().get())) {
                configureOwasp(p);
            }
        });
    }

    private void configureJavaToolchain(final Project project, final FlosswareStandardsExtension ext) {
        final JavaPluginExtension javaExt = project.getExtensions().getByType(JavaPluginExtension.class);
        javaExt.toolchain(toolchain ->
            toolchain.getLanguageVersion().set(JavaLanguageVersion.of(ext.getJavaVersion().get()))
        );
    }

    private void configureCheckstyle(final Project project) {
        project.getPluginManager().apply("checkstyle");

        final File configFile = extractResource(project, "flossware-checkstyle.xml");
        final CheckstyleExtension checkstyle = project.getExtensions().getByType(CheckstyleExtension.class);
        checkstyle.setConfigFile(configFile);
        checkstyle.setMaxWarnings(0);
        checkstyle.setToolVersion("10.12.5");
        checkstyle.setShowViolations(true);
    }

    private void configurePmd(final Project project) {
        project.getPluginManager().apply("pmd");

        final File rulesetFile = extractResource(project, "flossware-pmd-ruleset.xml");
        final PmdExtension pmd = project.getExtensions().getByType(PmdExtension.class);
        pmd.setRuleSets(Collections.emptyList());
        pmd.setRuleSetFiles(project.files(rulesetFile));
        pmd.setConsoleOutput(true);
        pmd.setToolVersion("7.0.0");

        project.getTasks().withType(Pmd.class).configureEach(task ->
            task.getReports().getHtml().getRequired().set(true)
        );
    }

    private void configureSpotbugs(final Project project) {
        project.getPluginManager().apply("com.github.spotbugs");

        final File excludeFile = extractResource(project, "flossware-spotbugs-exclude.xml");
        final SpotBugsExtension spotbugs = project.getExtensions().getByType(SpotBugsExtension.class);
        spotbugs.getEffort().set(Effort.MAX);
        spotbugs.getReportLevel().set(Confidence.LOW);
        spotbugs.getExcludeFilter().set(excludeFile);

        project.getTasks().withType(SpotBugsTask.class).configureEach(task -> {
            task.getReports().maybeCreate("html").getRequired().set(true);
            task.getReports().maybeCreate("xml").getRequired().set(false);
        });
    }

    private void configureJacoco(final Project project, final FlosswareStandardsExtension ext) {
        project.getPluginManager().apply("jacoco");

        final JacocoPluginExtension jacoco = project.getExtensions().getByType(JacocoPluginExtension.class);
        jacoco.setToolVersion("0.8.11");

        project.getTasks().withType(JacocoReport.class).configureEach(report -> {
            report.dependsOn(project.getTasks().withType(Test.class));
            report.getReports().getHtml().getRequired().set(true);
            report.getReports().getXml().getRequired().set(true);

            if ("pragmatic".equals(ext.getCoverageMode().get())) {
                report.getClassDirectories().setFrom(
                    project.files(report.getClassDirectories().getFiles().stream()
                        .map(dir -> project.fileTree(dir, tree -> tree.exclude(PRAGMATIC_EXCLUDES)))
                        .toArray())
                );
            }
        });

        project.getTasks().withType(JacocoCoverageVerification.class).configureEach(verification -> {
            if ("pragmatic".equals(ext.getCoverageMode().get())) {
                verification.getClassDirectories().setFrom(
                    project.files(verification.getClassDirectories().getFiles().stream()
                        .map(dir -> project.fileTree(dir, tree -> tree.exclude(PRAGMATIC_EXCLUDES)))
                        .toArray())
                );
            }

            verification.getViolationRules().rule(rule -> {
                rule.setElement("BUNDLE");
                rule.limit(limit -> {
                    limit.setCounter("INSTRUCTION");
                    limit.setValue("COVEREDRATIO");
                    limit.setMinimum(java.math.BigDecimal.ONE);
                });
                rule.limit(limit -> {
                    limit.setCounter("BRANCH");
                    limit.setValue("COVEREDRATIO");
                    limit.setMinimum(java.math.BigDecimal.ONE);
                });
                rule.limit(limit -> {
                    limit.setCounter("LINE");
                    limit.setValue("COVEREDRATIO");
                    limit.setMinimum(java.math.BigDecimal.ONE);
                });
                rule.limit(limit -> {
                    limit.setCounter("CLASS");
                    limit.setValue("MISSEDCOUNT");
                    limit.setMaximum(java.math.BigDecimal.ZERO);
                });
            });
        });

        project.getTasks().named("check", task ->
            task.dependsOn(project.getTasks().withType(JacocoCoverageVerification.class))
        );
    }

    private void configureOwasp(final Project project) {
        project.getPluginManager().apply("org.owasp.dependencycheck");

        project.getExtensions().configure("dependencyCheck", ext -> {
            try {
                final var method = ext.getClass().getMethod("setFailBuildOnCVSS", float.class);
                method.invoke(ext, 7.0f);
            } catch (final Exception e) {
                project.getLogger().warn("Could not configure OWASP dependency-check: {}", e.getMessage());
            }
        });
    }

    private void configureVersionValidation(final Project project, final FlosswareStandardsExtension ext) {
        project.getTasks().register("validateVersion", task -> {
            task.setGroup("verification");
            task.setDescription("Validates project version matches X.Y format");
            task.onlyIf(t -> ext.getVersionValidationEnabled().get());
            task.doLast(action -> {
                final String version = project.getVersion().toString();
                if (!version.matches("^\\d+\\.\\d+$")) {
                    throw new GradleException(
                        "VERSION ERROR: Version '" + version + "' must be in X.Y format (e.g., 1.0, 2.5), not X.Y.Z or SNAPSHOT"
                    );
                }
            });
        });

        project.getTasks().named("check", task ->
            task.dependsOn("validateVersion")
        );
    }

    private File extractResource(final Project project, final String resourceName) {
        final File outputDir = new File(project.getLayout().getBuildDirectory().getAsFile().get(), STANDARDS_DIR);
        outputDir.mkdirs();
        final File outputFile = new File(outputDir, resourceName);

        try (InputStream is = getClass().getResourceAsStream("/" + resourceName)) {
            if (is == null) {
                throw new GradleException("FlossWare standards resource not found: " + resourceName);
            }
            Files.copy(is, outputFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        } catch (final IOException e) {
            throw new GradleException("Failed to extract FlossWare standards resource: " + resourceName, e);
        }

        return outputFile;
    }
}
