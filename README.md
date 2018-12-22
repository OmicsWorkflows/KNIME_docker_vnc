# KNIME_docker_vnc
Docker file and associated files for running KNIME inside the Docker container build on top of Ubuntu 18.04 with xfce desktop environment accessible via VNC.

Prebuilt Docker images are available on Docker hub [https://hub.docker.com/r/cfprot/knime/](https://hub.docker.com/r/cfprot/knime/).

## Prebuild Docker Images Usage

This chapter explains how to run Docker image on your machine.

At first you will need to install docker application for your platform - [here](https://docs.docker.com/install/) you can find information on Docker project pages.



## List of used programs and extensions and the respective licences

Please note that only the latest docker file/image version is considered here.
 
Docker image contains the below mentioned selected tools found needed and or helping during the work with the KNIME environment. It runs on top of Ubuntu 18.04 LTS. The current version of the docker environment contains the following list of programs. Please inspect your local installation and contact us if you can not locate your local version and or license terms associated to the used program(s).

#### Operation system and its components

- [Ubuntu](https://www.ubuntu.com/) 18.04
  - The Ubuntu consists of the following Ubuntu License. Licence terms are available here: https://www.ubuntu.com/licensing

#### Programs

- [KNIME](https://www.knime.com/) 3.6.1
  - The KNIME nodes consists of the following GNU GPL 3.0 License. Licence terms are available here: https://www.knime.com/downloads/full-license
- [Python](https://www.python.org/) 3.6.5
  - The Python consists of the following Python 3.6 License. Licence terms are available here: https://docs.python.org/3.6/license.html
- [R](https://www.r-project.org/) 3.4.4
  - The R consists of the following GNU General Public Licences. Licence terms are available here: https://www.r-project.org/Licenses/

#### KNIME extensions on top of the standard KNIME Analytics Platform installation

- KNIME Python Integration (org.knime.features.python2.feature.group/3.6.1.v201808311614)
- KNIME Interactive R Statistics Integration (org.knime.features.r.feature.group/3.6.1.v201808311614)
- [OpenMS](http://www.openms.de/) 2.3.0 (de.openms.feature.feature.group/2.3.0.201712211252)
    - The OpenMS consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [PIA](https://github.com/mpc-bioinformatics/pia) 1.3.7 (de.mpc.pia.feature.feature.group/1.3.7.v201803061425)
    - The PIA consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause

#### Python 3 packages
- [numpy](http://www.numpy.org/) 1.15.1
    - The numpy consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [pandas](https://pandas.pydata.org/) 0.23.4
    - The pandas consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [seaborn](https://seaborn.pydata.org/) 0.9.0
    - The seaborn consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [statsmodels](https://www.statsmodels.org/stable/index.html) 0.9.0
    - The statsmodels consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [matplotlib](https://matplotlib.org/) 2.2.3
    - The matplotlib consists of the following Python Software Foundation License (BSD compatible). Licence terms are available here: https://matplotlib.org/users/license.html
- [scipy](https://www.scipy.org/) 1.1.0
    - The scipy consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause

#### R libraries

- [Rserve](https://cran.r-project.org/web/packages/Rserve/index.html)
    - The Rserve consists of the following General Public License (GPL), version 2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-2
- [preprocessCore](https://www.bioconductor.org/packages/release/bioc/html/preprocessCore.html)
    - The preprocessCore consists of the following GNU Library General Public (LGPL) License, version 2 (or higher) license. Licence terms are available here: https://www.r-project.org/Licenses/LGPL-2
- [limma](https://bioconductor.org/packages/release/bioc/html/limma.html)
    - The limma consists of the following General Public License (GPL), version 2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-2
- [Biobase](https://bioconductor.org/packages/release/bioc/html/Biobase.html)
    - The Biobase consists of the following Artistic-2.0 license. Licence terms are available here: https://opensource.org/licenses/Artistic-2.0
- [vsn](https://bioconductor.org/packages/release/bioc/html/vsn.html)
    - The vsn consists of the following Artistic-2.0 license. Licence terms are available here: https://opensource.org/licenses/Artistic-2.0
- [pcaMethods](https://www.bioconductor.org/packages/release/bioc/html/pcaMethods.html)
    - The pcaMethods consists of the following General Public License (GPL), version 3 (or higher) license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-3
- [impute](http://www.bioconductor.org/packages/release/bioc/html/impute.html)
    - The impute consists of the following General Public License (GPL), version 2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-2
- [imp4p](https://cran.r-project.org/web/packages/imp4p/index.html)
    - The imp4p consists of the following General Public License (GPL), version 3 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-3

