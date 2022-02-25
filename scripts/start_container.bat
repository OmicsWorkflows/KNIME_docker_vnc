@echo off
@SETLOCAL EnableDelayedExpansion
:: you can start the container running this script in the commandline directly with 3 parameters: [IMAGE_NAME] [PORT_TO_RUN_ON] [WORKSPACE],
:: e.g. ".\start_container.bat cfprot/knime:latest 5901 test" where
::     "cfprot/knime:latest" points to the latest docker image version (replace 'latest' by any older image version, e.g. 3.7.2a)
::     "5901" specifies the port on which the container will be accesible for VNC connection
::     "test" is the folder within workspaces folder (see "volume_remote_location" below)
:: order of parameters must be kept (we don't support switches...)
::
:: alternatively just run the script file itself and provide it with the parameters it requests


::::::::::::::::::::::::::::::::::::::::::::::::::::::
::: settings to be adjusted on the given PC/server :::
::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: folder containing subfolder you want to mount as your KNIME workspace folder (e.g. "D:\knime-workspaces\")
set folder_with_workspaces=D:\knime-workspaces\
:: timezone in which the container will run
set timezone="Europe/Prague"

:: default docker image version to be used
set default_image_name=cfprot/knime:latest
set default_port=5901
set default_workspace=knime-workspace
set default_vnc_password=knime1

:::::::::::::::::::::::::::::::::::::::
::: END OF THE SCRIPT SETTINGS PART :::
:::::::::::::::::::::::::::::::::::::::


:: folder inside the container where volume will be mounted, do not change
set volume_mount_point=/home/knimeuser/knime-workspace

if "%~1"=="" (
    set /P image_name_input="Please provide docker image name (leave empty for "!default_image_name!"): "
    if "!image_name_input!" == "" (
        set image_name=%default_image_name%
    ) else (
        set image_name=!image_name_input!
    )
) else (
    set image_name=%~1
)

if "%~2"=="" (
    set /P port_input="Which port should the container run on? (e.g. 5901; leave empty for "!default_port!"): "
    if "!port_input!"=="" (
        set port=%default_port%
    ) else (
        set port=!port_input!
    )
) else (
    set port=%2
)

if "%~3"=="" (
    set /P workspace_input="Name of the workspace to use - leave blank for "!default_workspace!": "
    if "!workspace_input!"=="" (
        set workspace=%default_workspace%
    ) else (
        set workspace=!workspace_input!
    )
) else (
    set workspace=%~3
)

call :joinpath %folder_with_workspaces% %workspace%

:: checks for the presence of the workspace directory
if not exist !workspace_path! (
    echo The expected workspace directory "!workspace_path!" does not exists.
    echo Is the workspaces folder ^("%folder_with_workspaces%"^) set correctly in the script?
    echo Check also that the provided workspace folder ^("!workspace!"^) exists in the workspaces folder.
    echo The script will exit now.
    pause
    exit
)

docker run -it --shm-size=1g --name knime%port% -p %port%:5901 -v %workspace_path%:%volume_mount_point% -e CONTAINER_TIMEZONE=%timezone% -e TZ=%timezone% -e VNCPASSWORD=$default_vnc_password --rm %image_name%

if errorlevel 1 (
   echo Error level returned is %errorlevel%
   pause
   exit
)

:: joins folder_with_workspaces and workspace varibles into a absolute path in more robust way
:joinpath
set Path1=%~1
set Path2=%~2
if {%Path1:~-1,1%}=={\} (set workspace_path=%Path1%%Path2%) else (set workspace_path=%Path1%\%Path2%)
goto :eof