package org.flossware.gradle;

import org.gradle.api.Project;
import org.gradle.testfixtures.ProjectBuilder;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

public class FlosswareStandardsPluginTest {

    @Test
    public void pluginAppliesSuccessfully() {
        final Project project = ProjectBuilder.builder().build();
        project.setVersion("1.0");
        project.getPluginManager().apply("org.flossware.standards");

        assertNotNull(project.getExtensions().findByName("flosswareStandards"));
    }

    @Test
    public void extensionHasCorrectDefaults() {
        final Project project = ProjectBuilder.builder().build();
        project.setVersion("1.0");
        project.getPluginManager().apply("org.flossware.standards");

        final FlosswareStandardsExtension ext =
            project.getExtensions().getByType(FlosswareStandardsExtension.class);

        assertEquals("strict", ext.getCoverageMode().get());
        assertEquals(Integer.valueOf(21), ext.getJavaVersion().get());
        assertTrue(ext.getCheckstyleEnabled().get());
        assertTrue(ext.getPmdEnabled().get());
        assertTrue(ext.getSpotbugsEnabled().get());
        assertTrue(ext.getJacocoEnabled().get());
        assertEquals(Boolean.FALSE, ext.getOwaspEnabled().get());
        assertTrue(ext.getVersionValidationEnabled().get());
    }

    @Test
    public void javaPluginIsApplied() {
        final Project project = ProjectBuilder.builder().build();
        project.setVersion("1.0");
        project.getPluginManager().apply("org.flossware.standards");

        assertTrue(project.getPlugins().hasPlugin("java"));
    }

    @Test
    public void validateVersionTaskExists() {
        final Project project = ProjectBuilder.builder().build();
        project.setVersion("1.0");
        project.getPluginManager().apply("org.flossware.standards");

        assertNotNull(project.getTasks().findByName("validateVersion"));
    }

    @Test
    public void extensionValuesCanBeOverridden() {
        final Project project = ProjectBuilder.builder().build();
        project.setVersion("1.0");
        project.getPluginManager().apply("org.flossware.standards");

        final FlosswareStandardsExtension ext =
            project.getExtensions().getByType(FlosswareStandardsExtension.class);

        ext.getCoverageMode().set("pragmatic");
        ext.getJavaVersion().set(17);
        ext.getCheckstyleEnabled().set(false);
        ext.getOwaspEnabled().set(true);

        assertEquals("pragmatic", ext.getCoverageMode().get());
        assertEquals(Integer.valueOf(17), ext.getJavaVersion().get());
        assertEquals(Boolean.FALSE, ext.getCheckstyleEnabled().get());
        assertTrue(ext.getOwaspEnabled().get());
    }
}
