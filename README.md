# KNIME_docker_vnc
Docker file and associated files for running KNIME inside the Docker container build on top of Ubuntu with desktop environment accessible via VNC.

The repository is meant for sharing docker files and accompanied files/scripts and to make easier usage of prebuild docker images hosted on docker hub ([https://hub.docker.com/r/cfprot/knime/](https://hub.docker.com/r/cfprot/knime/)).

The current docker image version is built using KNIME 4.7.7, see [the list of used programs below](https://github.com/OmicsWorkflows/KNIME_docker_vnc#list-of-used-programs-and-extensions-and-the-respective-licences).

## Prebuild Docker Images Usage

This chapter explains how to run Docker image on your machine.

Please note that the procedure below was successfully tested on Ubuntu 20.04 (64-bit) and Windows 10 (64-bit, Professional and Educational version) with Docker for desktop application installed. Earlier versions were tested also using Docker toolbox (Windows 7 Professional and Windows 10 Home) but there was an issue with read only access to the mounted workspace which is limiting for the optimal container usage and we do not recommend to use it.

1. At first you will need to install docker application for your platform - [here](https://docs.docker.com/install/) you can find information on Docker project pages.
   - please note that the docker application needs virtualization enabled on your system and it may need to be enabled in the bios of your system
   - please note that docker application uses different type of virtualization than e.g. VirtualBox application so these two can not run on simultaneously; even though [it may be possible](https://docs.docker.com/desktop/faqs/windowsfaqs/#can-i-use-virtualbox-alongside-docker-desktop) with the latest Docker versions
2. [Download](https://github.com/OmicsWorkflows/KNIME_docker_vnc/archive/master.zip) and unzip or clone this repository using your version control system to get mainly the "scripts" folder containing scripts to assist you to run the docker container in the next steps.
   - there are platform specific (Linux, Windows, Mac) scripts to help you to run the docker container on your platform
      - start_container.sh - Linux
      - start_container.bat - Windows
      - start_container.command - Mac
3. Adjust "start_container" script for your platform (Windows, Linux, Mac) to meet your system setup, especially folder that will contain your workspace(s) ("folder_with_workspaces" settings), default VNC server password and timezone you want to use. Please, check the script file settings part itself for all the details.
   - it is a good practice to create brand new folder that will hold all your KNIME workspaces ("workspaces_folder" variable) and one additional subfolder in it to be used for the specific container (to be specified during the script running)
   - please note that our docker image is designed to mount selected folder from your local filesystem to enable data transfer between the container and the system running the container. This requires you to setup shared drive on Windows machines
   - KNIME has to have write access to the KNIME workspace folder, please adjust the access rights to the KNIME workspace folder if needed
4. Run the "start_container" script for your platform to create a docker container based on the prebuild image, there are two supported ways:
   1. run the script file itself without any argument (e.g. by double-clicking on it) and provide few arguments when asked;
   
      or
   
   2. run the script file on the command line with 3 parameters provided directly and separated by space: `IMAGE_NAME`, `PORT_TO_RUN_ON`, `WORKSPACE`
      - examples for container start are:
         - **Windows**: `start_container.bat cfprot/knime:latest 5901 test`
         - **Linux**: `./start_container.sh cfprot/knime:latest 5901 test`      
         - **Mac**: `./start_container.command cfprot/knime:latest 5901 test`      
         - where:
            - **`cfprot/knime:latest`** points to the latest docker image version of cfprot/knime docker image (change `latest` tag to e.g. `3.7.2a` to run specific version of the docker image)
            - **`5901`** specifies the port on which the container will be accesible for VNC connection
            - **`test`** is the folder within workspaces folder (see "folder_with_workspaces" settings in the script) that will be mounted as KNIME workspace folder and will be used by default by KNIME
   - please note that the script may need to be set as executable on your system prior its usage
   - please note that this step will automatically initiate download of the selected docker image version from the [docker hub](https://hub.docker.com/r/cfprot/knime/tags); the download process will take place only once, when you will want to use concrete docker image for the first time; the images have around 5GB so the download process will take some time
   - the downloaded image will take about 10GB on your hard drive based on your docker application settings
   - there will be messages from the docker container start you can ignore after the download will be completed
   - you can close the window with the script output as well now or you can just minimize it to use it to stop the started container
5. Access the running container using VNC viewer at specified port number, e.g. "localhost::5901" in case of connecting into the locally running container. Use the password `knime` or the one you have set in the script file. We recommend to use latest [TigerVNC viewer](https://github.com/TigerVNC/tigervnc/releases) release to connect into the running container.
6. You can verify that everything is set up correctly by starting KNIME and confirming the locations of its workspace. This will create some files on your hard drive inside the workspace folder specified before.
7. You can transfer data to and from the running container using the specified workspace folder that is identical on your computer and inside the container
   - e.g. "C:\knime-workspaces\test" on your computer (you specify this folder during the container start)
   - "/home/knimeuser/knime-workspace/" inside the running container (this is fixed destination folder; it is specified in the container start script file as well, but should not be changed)
8. The container will run until you restart your system that is running the container or kill the container start process. If you would like to get information on the actually running docker containers or stop the currently running container, you can use the following commands on the command line (for all, Windows, Linux and Mac systems)
   - `docker ps -a` lists the running docker containers
   - `docker stop knime5901` stops and kills the running container with name "knime5901"

        - WARNING: you may lose not saved work from inside of your container as this will remove the container completely and you will not be able to access it again! Save your work and close the KNIME application prior this command running optimally!
    - `docker system prune -a` removes downloaded and currently not used docker images from your system
        - WARNING: you will need to download the docker image again if needed later on
9. If you want to use also our [metanodes](https://github.com/OmicsWorkflows/KNIME_metanodes) and or [workflows](https://github.com/OmicsWorkflows/KNIME_workflows), unzip also "gitfolders.zip" file content directly into your workspace folder - it contains "gitfolders" folder with two additional subfolders ("KNIME_metanodes" and "KNIME_workflows") to hold the content of the two GitHub repositories
10. To stop the running container you can
    - press `Ctrl+C` while the container start script window is active
    - use the `docker stop 'container name'` command in the command line (see above)
    - restart the computer

## List of used programs and extensions and the respective licences

Please note that only the latest docker file/image version is mentioned here.

The repository utilizes [docker](https://www.docker.com/) files and the docker images are hosted on [docker hub](https://hub.docker.com).

Docker image contains the below-mentioned selected tools found needed and or helping during the work with the KNIME environment. It runs on top of Ubuntu 20.04 LTS. The current version of the docker environment contains the following list of programs and other additional programs and packages required by the following ones. Please inspect your local installation and contact us if you can not locate your local application/package version and or license terms associated to the used program(s).

#### Operation system and its components (alphabetical order)
- [git](https://git-scm.com/) 2.25.1
  - The git consists of the following GNU General Public License version 2.0. Licence terms are available here: http://opensource.org/licenses/GPL-2.0
- [KNIME](https://www.knime.com/) 4.7.7
  - The KNIME nodes consists of the following GNU GPL 3.0 License. Licence terms are available here: https://www.knime.com/downloads/full-license
- [Python](https://www.python.org/) 3.10.4 and 3.6.9
  - The Python consists of the following Python 3.10 License. Licence terms are available here: https://docs.python.org/3.10/license.html
- [R](https://www.r-project.org/) 4.2.0 and 3.6.3
  - The R consists of the following GNU General Public Licences. Licence terms are available here: https://www.r-project.org/Licenses/
- [TigerVNC](https://tigervnc.org/) 1.10.0
  - The TigerVNC consists of the following GNU General Public Licence. Licence terms are available here: https://github.com/TigerVNC/tigervnc/blob/master/LICENCE.TXT
- [Ubuntu](https://www.ubuntu.com/) 20.04
  - The Ubuntu consists of the following Ubuntu License. Licence terms are available here: https://www.ubuntu.com/licensing

#### KNIME extensions on top of the standard KNIME Analytics Platform installation (alphabetical order)

- KNIME Expressions (4.7.3.v202305091619)
- KNIME Interactive R Statistics Integration (4.7.0.v202211090002)
- KNIME Python Legacy Integration (4.7.1.v202301311311)
- KNIME Python Integration (4.7.3.v202305111430)
- KNIME Report Designer (4.7.2.v202303211209)
- KNIME Testing Framework (4.7.2.v202303211209)
- [OpenMS](http://www.openms.de/) 2.7.0 (2.7.0.202109131426)
    - The OpenMS consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [PIA](https://github.com/mpc-bioinformatics/pia) 1.4.5 (1.4.5.v202201211506)
    - The PIA consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause

#### Python 3 or 2 packages (alphabetical order; not covering the packages installed automatically together with the mentioned ones)
- [dash](https://plotly.com/dash/) 1.12.0 (python 3)
    - The Dash consists of the following MIT License. Licence terms are available here: https://github.com/plotly/dash/blob/master/LICENSE
- [dash-bio](https://dash.plotly.com/dash-bio) 0.4.8 (python 3)
    - The dash-bio consists of the following MIT License. Licence terms are available here: https://github.com/plotly/dash-bio/blob/master/LICENSE
- [matplotlib](https://matplotlib.org/) 3.1.3 (python 3) and 2.2.4 (python 2)
    - The matplotlib consists of the following Python Software Foundation License (BSD compatible). Licence terms are available here: https://matplotlib.org/users/license.html
- [numpy](http://www.numpy.org/) 1.18.1 (python 3) and 1.16.6 (python 2)
    - The numpy consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [pandas](https://pandas.pydata.org/) 1.0.1 (python 3) and 0.24.2 (python 2)
    - The pandas consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [scipy](https://www.scipy.org/) 1.4.1 (python 3) and 1.2.3 (python 2)
    - The scipy consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [seaborn](https://seaborn.pydata.org/) 0.10.0 (python 3) and 0.9.0 (python 2)
    - The seaborn consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause
- [statsmodels](https://www.statsmodels.org/stable/index.html) 0.11.1 (python 3) and 0.10.2 (python 2)
    - The statsmodels consists of the following BSD/3clause license. Licence terms are available here: https://opensource.org/licenses/BSD-3-Clause

#### R libraries (alphabetical order; not covering the libraries installed automatically together with the mentioned ones)
- [Biobase](https://bioconductor.org/packages/release/bioc/html/Biobase.html)
    - The Biobase consists of the following Artistic-2.0 license. Licence terms are available here: https://opensource.org/licenses/Artistic-2.0
- [compositions](https://cran.r-project.org/web/packages/compositions/index.html)
    - The compositions consists of the following General Public License (GPL), version >=2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-3
- [corpcor](https://cran.r-project.org/web/packages/corpcor/index.html)
    - The corpcor consists of the following General Public License (GPL), version >=3 license. Licence terms are available here: https://cran.r-project.org/web/licenses/GPL-3
- [gprofiler2](https://cran.r-project.org/web/packages/gprofiler2/index.html)
    - The gprofiler2 consists of the following General Public License (GPL), version >=2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-3
- [Hotelling](https://cran.r-project.org/web/packages/Hotelling/index.html)
    - The Hotelling consists of the following General Public License (GPL), version 2, 3 license. Licence terms are available here: https://cran.r-project.org/web/licenses/GPL-2, https://www.r-project.org/Licenses/GPL-3
- [imp4p](https://cran.r-project.org/web/packages/imp4p/index.html)
    - The imp4p consists of the following General Public License (GPL), version 3 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-3
- [impute](http://www.bioconductor.org/packages/release/bioc/html/impute.html)
    - The impute consists of the following General Public License (GPL), version 2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-2
- [limma](https://bioconductor.org/packages/release/bioc/html/limma.html)
    - The limma consists of the following General Public License (GPL), version 2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-2
- [pcaMethods](https://www.bioconductor.org/packages/release/bioc/html/pcaMethods.html)
    - The pcaMethods consists of the following General Public License (GPL), version 3 (or higher) license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-3
- [plotly](https://cran.r-project.org/web/packages/plotly/index.html)
    - The plotly consists of the following MIT license and License file. Licence terms are available here: https://cran.r-project.org/web/licenses/MIT and https://cran.r-project.org/web/packages/plotly/LICENSE
- [preprocessCore](https://www.bioconductor.org/packages/release/bioc/html/preprocessCore.html)
    - The preprocessCore consists of the following GNU Library General Public (LGPL) License, version 2 (or higher) license. Licence terms are available here: https://www.r-project.org/Licenses/LGPL-2
- [proDA](https://const-ae.github.io/proDA/)
    - The proDA consists of the following GPL-3 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-3
- [robCompositions](https://cran.r-project.org/web/packages/robCompositions/index.html)
    - The robCompositions consists of the following General Public License (GPL), version >=2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-3
- [Rserve](https://cran.r-project.org/web/packages/Rserve/index.html)
    - The Rserve consists of the following General Public License (GPL), version 2 license. Licence terms are available here: https://www.r-project.org/Licenses/GPL-2
- [UpSetR](https://cran.r-project.org/web/packages/UpSetR/index.html)
    - The UpSetR consists of the following MIT license and License file. Licence terms are available here: https://cran.r-project.org/web/licenses/MIT and https://cran.r-project.org/web/packages/UpSetR/LICENSE
- [vsn](https://bioconductor.org/packages/release/bioc/html/vsn.html)
    - The vsn consists of the following Artistic-2.0 license. Licence terms are available here: https://opensource.org/licenses/Artistic-2.0

# Contributors

The project is maintained by people from several laboratories (in alphabetical order):
- Kristína Gömöryová
  - [Laboratory of cellular communication](http://www.sci.muni.cz/bryjalab/), Department of Experimental Biology, Faculty of Science, Masaryk University, Brno, Czech Republic 
- Karolína Kryštofová
    - [Proteomics Research group](https://www.ceitec.eu/proteomics-zbynek-zdrahal/rg49), Central European Institute of Technology, Masaryk University, Brno, Czech Republic
    - member of [EuBIC](https://eupa.org/eupa-initiatives/eubic/) ![EuBIC logo](eubic_logo.png)
- David Potěšil
  - [Proteomics Research group](https://www.ceitec.eu/proteomics-zbynek-zdrahal/rg49), Central European Institute of Technology, Masaryk University, Brno, Czech Republic
  - member of [EuBIC](https://eupa.org/eupa-initiatives/eubic/) ![EuBIC logo](eubic_logo.png)

# Acknowledgement

We would like to acknowledge work of all the people behind all open-source software, especially the one we are using for the docker image build.

Computational resources for the image were supplied by the project "e-Infrastruktura CZ" (e-INFRA LM2018140) provided within the program Projects of Large Research, Development and Innovations Infrastructures.
 
# Licence
This version of docker file and accompanied files are available under the GNU GPL 3.0 License (see the [LICENSE](../master/LICENSE) file for details), unless stated otherwise.