package org.flossware.gradle;

import org.gradle.testkit.runner.BuildResult;
import org.gradle.testkit.runner.GradleRunner;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.gradle.testkit.runner.TaskOutcome.FAILED;
import static org.gradle.testkit.runner.TaskOutcome.SUCCESS;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class FlosswareStandardsPluginFunctionalTest {

    @Rule
    public final TemporaryFolder testProjectDir = new TemporaryFolder();

    private File buildFile;
    private File settingsFile;

    @Before
    public void setup() throws IOException {
        buildFile = testProjectDir.newFile("build.gradle");
        settingsFile = testProjectDir.newFile("settings.gradle");
        Files.writeString(settingsFile.toPath(), "rootProject.name = 'test-project'\n");
    }

    @Test
    public void pluginAppliesAndTasksExist() throws IOException {
        writeBuildFile("1.0", "strict");

        final BuildResult result = createRunner("tasks", "--group=verification").build();

        assertTrue(result.getOutput().contains("validateVersion"));
    }

    @Test
    public void validVersionPassesValidation() throws IOException {
        writeBuildFile("1.0", "strict");

        final BuildResult result = createRunner("validateVersion").build();

        assertEquals(SUCCESS, result.task(":validateVersion").getOutcome());
    }

    @Test
    public void semverVersionFailsValidation() throws IOException {
        writeBuildFile("1.0.0", "strict");

        final BuildResult result = createRunner("validateVersion").buildAndFail();

        assertEquals(FAILED, result.task(":validateVersion").getOutcome());
        assertTrue(result.getOutput().contains("VERSION ERROR"));
        assertTrue(result.getOutput().contains("X.Y format"));
    }

    @Test
    public void snapshotVersionFailsValidation() throws IOException {
        writeBuildFile("1.0-SNAPSHOT", "strict");

        final BuildResult result = createRunner("validateVersion").buildAndFail();

        assertEquals(FAILED, result.task(":validateVersion").getOutcome());
        assertTrue(result.getOutput().contains("VERSION ERROR"));
    }

    @Test
    public void pragmaticCoverageModeAccepted() throws IOException {
        writeBuildFile("1.0", "pragmatic");

        final BuildResult result = createRunner("tasks").build();

        assertTrue(result.getOutput().contains("BUILD SUCCESSFUL"));
    }

    private void writeBuildFile(final String version, final String coverageMode) throws IOException {
        final String content = String.format(
            "plugins {\n" +
            "    id 'org.flossware.standards'\n" +
            "}\n\n" +
            "version = '%s'\n\n" +
            "flosswareStandards {\n" +
            "    coverageMode = '%s'\n" +
            "}\n\n" +
            "repositories {\n" +
            "    mavenCentral()\n" +
            "}\n",
            version, coverageMode
        );
        Files.writeString(buildFile.toPath(), content);
    }

    private GradleRunner createRunner(final String... arguments) {
        return GradleRunner.create()
            .withProjectDir(testProjectDir.getRoot())
            .withArguments(arguments)
            .withPluginClasspath();
    }
}
