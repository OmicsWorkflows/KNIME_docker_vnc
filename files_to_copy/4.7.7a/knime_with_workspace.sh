#!/bin/bash
# start KNIME with dialog to select the workspace folder
#$knime_folder/knime

# OR enable this to start KNIME without to select the workspace folder selecting the default one automatically
$knime_folder/knime -data "${knime_workspace_folder}"
