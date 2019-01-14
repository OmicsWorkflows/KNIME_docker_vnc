# KNIME_docker_vnc
Docker file and associated files for running KNIME inside the Docker container build on top of Ubuntu with desktop environment accessible via VNC.

The repository is meant for sharing docker files and accompanied files/scripts and to make easier usage of prebuild docker images hosted on docker hub ([https://hub.docker.com/r/cfprot/knime/](https://hub.docker.com/r/cfprot/knime/)).

## Prebuild Docker Images Usage

This chapter explains how to run Docker image on your machine.

1. At first you will need to install docker application for your platform - [here](https://docs.docker.com/install/) you can find information on Docker project pages.
2. Clone this repository, especially scripts folder containing "start_container.sh" file.
3. Adjust "start_container.sh" file to meet your requirements, especially folder containing your workspace(s) and timezone you want to use. Please, check the script file itself for all the details.
4. Start container running the "start_container.sh" with 3 parameters: IMAGE_NAME PORT_TO_RUN_ON WORKSPACE
   - the script has to be executable prior its usage!
   - the specified folder has to be writable on the host system running the container!
   - e.g. on linux run "./start_container.sh cfprot/knime:3.5.3c 5901 test" where:
      - "cfprot/knime:3.6.1a" points to a concrete docker image version of cfprot/knime docker image
      - "5901" specifies the port on which the container will be accesible for VNC connection
      - "test" is the folder within workspaces folder (see "volume_remote_location" settings in the script)
5. Enter the password for the VNC server that will be needed to access the running container.
6. Access the running container using VNC viewer at specified port number and using the specified password, e.g. localhost:5901. We recommend to use latest [TigerVNC viewer](https://github.com/TigerVNC/tigervnc/releases) release.
7. Click on the "Use default config" when starting the container for the first time to get the default Xfce layout.
8. Adjust the access rights to the KNIME workspace folder KNIME has to have write access to the KNIME workspace folder.


## List of used programs and extensions and the respective licences

Please note that only the latest docker file/image version is considered here.

The repository utilizes [docker](https://www.docker.com/) files and the docker images are hosted on [docker hub](https://hub.docker.com).

Docker image contains the below mentioned selected tools found needed and or helping during the work with the KNIME environment. It runs on top of Ubuntu 18.04 LTS. The current version of the docker environment contains the following list of programs. Please inspect your local installation and contact us if you can not locate your local version and or license terms associated to the used program(s).

#### Operation system and its components (alphabetical order)
- [git](https://git-scm.com/) 2.17.1
  - The TigerVNC consists of the following GNU General Public Licence. Licence terms are available here: https://github.com/TigerVNC/tigervnc/blob/master/LICENCE.TXT
- [KNIME](https://www.knime.com/) 3.7.0
  - The KNIME nodes consists of the following GNU GPL 3.0 License. Licence terms are available here: https://www.knime.com/downloads/full-license
- [Python](https://www.python.org/) 2.7.15rc1
  - The Python consists of the following Python 2.7 License. Licence terms are available here: https://docs.python.org/2.7/license.html
- [Python](https://www.python.org/) 3.6.7
  - The Python consists of the following Python 3.6 License. Licence terms are available here: https://docs.python.org/3.6/license.html
- [R](https://www.r-project.org/) 3.4.4
  - The R consists of the following GNU General Public Licences. Licence terms are available here: https://www.r-project.org/Licenses/
- [TigerVNC](https://tigervnc.org/) 1.9.0
  - The TigerVNC consists of the following GNU General Public Licence. Licence terms are available here: https://github.com/TigerVNC/tigervnc/blob/master/LICENCE.TXT
- [Ubuntu](https://www.ubuntu.com/) 18.04
  - The Ubuntu consists of the following Ubuntu License. Licence terms are available here: https://www.ubuntu.com/licensing

#### KNIME extensions on top of the standard KNIME Analytics Platform installation (alphabetical order)

- KNIME Expressions (org.knime.features.testingapplication.feature.group/3.7.0.v201811021340)
- KNIME Interactive R Statistics Integration (org.knime.features.r.feature.group/3.7.0.v201810230750)
- KNIME Python Integration (org.knime.features.python2.feature.group/3.7.0.v201812041252)
- KNIME Report Designer (com.knime.features.reporting.designer.feature.group/3.7.0.v201808081048)
- KNIME Testing Framework (org.knime.features.testingapplication.feature.group/3.7.0.v201811021340)
- [OpenMS](http://www.openms.de/) 2.4.0 (de.openms.feature.feature.group/2.4.0.201810261314)
    - The OpenMS consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [PIA](https://github.com/mpc-bioinformatics/pia) 1.3.9 (de.mpc.pia.feature.feature.group/1.3.9.v201809131534)
    - The PIA consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause

#### Python 3 packages (alphabetical order)
- [matplotlib](https://matplotlib.org/) 2.2.3
    - The matplotlib consists of the following Python Software Foundation License (BSD compatible). Licence terms are available here: https://matplotlib.org/users/license.html
- [numpy](http://www.numpy.org/) 1.15.4
    - The numpy consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [pandas](https://pandas.pydata.org/) 0.23.4
    - The pandas consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [seaborn](https://seaborn.pydata.org/) 0.9.0
    - The seaborn consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [scipy](https://www.scipy.org/) 1.2.0
    - The scipy consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [statsmodels](https://www.statsmodels.org/stable/index.html) 0.9.0
    - The statsmodels consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause

#### R libraries (alphabetical order)
- [Biobase](https://bioconductor.org/packages/release/bioc/html/Biobase.html)
    - The Biobase consists of the following Artistic-2.0 license. Licence terms are available here: https://opensource.org/licenses/Artistic-2.0
- [pcaMethods](https://www.bioconductor.org/packages/release/bioc/html/pcaMethods.html)
    - The pcaMethods consists of the following General Public License (GPL), version 3 (or higher) license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-3
- [imp4p](https://cran.r-project.org/web/packages/imp4p/index.html)
    - The imp4p consists of the following General Public License (GPL), version 3 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-3
- [impute](http://www.bioconductor.org/packages/release/bioc/html/impute.html)
    - The impute consists of the following General Public License (GPL), version 2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-2
- [limma](https://bioconductor.org/packages/release/bioc/html/limma.html)
    - The limma consists of the following General Public License (GPL), version 2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-2
- [preprocessCore](https://www.bioconductor.org/packages/release/bioc/html/preprocessCore.html)
    - The preprocessCore consists of the following GNU Library General Public (LGPL) License, version 2 (or higher) license. Licence terms are available here: https://www.r-project.org/Licenses/LGPL-2
- [Rserve](https://cran.r-project.org/web/packages/Rserve/index.html)
    - The Rserve consists of the following General Public License (GPL), version 2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-2
- [vsn](https://bioconductor.org/packages/release/bioc/html/vsn.html)
    - The vsn consists of the following Artistic-2.0 license. Licence terms are available here: https://opensource.org/licenses/Artistic-2.0

# Licence
This version of docker file and accompanied files are available under the GNU GPL 3.0 License (see the [LICENSE](../master/LICENSE) file for details), unless stated otherwise.