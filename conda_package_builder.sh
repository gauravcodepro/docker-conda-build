#!/usr/bin/env bash
# -*- coding:  utf-8 -*-
# Author: Gaurav Sablok
# date: 2023-10-15
# MIT License
tidyclean="Your conda is upto date"
read -r -p "please print the help menu:": help
if [[ $help == "yes" ]] 
    then    echo "info, list,config, update, install, create_from_external"
            echo "create, install_specific_channel, uninstall, export, search"
fi
if [[ $help == "no" ]]
then
            read -r -p "please provide the option you can call info or config:" option
            if [[ $option == "info" ]]
            then
                conda info
            elif [[ $option == "config" ]]
            then
                conda config --show
            elif [[ $option == "list" ]]
            then 
                read -r -p "please enter the name of the package:" package
                read -r -p "do you want to show the package channels also:" option
                if [[ $package ]] || [[ $option == "yes" ]]
                then
                    conda list -n "$package" --show-channel-urls
                else
                    conda env list
                    conda list --show-channel-urls
                fi 
             elif [[ $option == "config" ]] 
             then 
                read -r -p "please enter the name of the channel:" channel
                read -r -p "do you want to add channels:" add
                if [[ $channel ]] || [[ $add ]]
                then
                    conda config --add channels "$channel"
                else
                    conda config --show-sources
                fi 
             elif  [[ $option == "update" ]] 
             then
                read -r -p "do you want to update all the channels:" option
                read -r -p "do you want to update a specific channel:" specific
                if [[ $option == "yes" ]]
                then
                    conda update -n base conda
                    conda update --all
                elif [[ $specific ]] 
                then
                    conda update --all -n "$specific"
                fi
             elif [[ $option == "install" ]]
             then 
                read -r -p "please provide the package names:" package_name
                read -r -p "do you want to install to a specific environment:" environment
                if [[ $package_name ]] || [[ $environment ]]
                then
                    conda install -n "$environment" "$package_name"
                elif [[ $package_name ]]
                then
                    conda install "$package_name" --yes
                fi
             elif [[ $option == "create_from_external" ]]
             then 
                read -r -p "please provide the yml or txt file:" yml
                read -r -p "please provide the environment package name:" package
                conda env create -n "$package" --file "$yml"
             elif [[ $option == "create" ]]
             then 
                read -r -p "please provide the environment name:" name
                read -r -p "do you want to install any dependencies: " dependencies
                read -r -p "version number for the dependencies: " version
                if [[ $name ]] 
                then 
                    conda create --name "$name"
                fi 
                if [[ $name ]] && 
                    [[ $dependencies ]] && 
                        [[ $version ]]
                then 
                    conda create --name "$name" "$dependencies"="$version" 
                fi
             elif [[ $option ==  "install_specific_channel" ]]
             then 
                read -r -p "please provide the channel name:" channel
                read -r -p "please provide how many packages you want to install:" number
                count=0
                package_name=()
                    while [[ $count -le "$number" ]]
                    do 
                    read -r -p "please provide the package name:" package
                    package_name+=("package")
                        count=$((count+1))
                    if [[ $count == "$number" ]] 
                    then 
                        break 
                    fi
                    done
                for i in "${package[@]}" 
                do 
                    conda install -c "$channel" "$i" 
                    conda clean --all
                done 
             elif [[ $option == "uninstall" ]] 
             then
                read -r -p "please provide the environment name:" environment
                read -r -p "please provide the package name:" package
                read -r -p "please provide the channel name:" channel
                if [[ $package ]]
                then
                    conda uninstall "$package"
                elif [[ $environment ]]
                then 
                    conda remove -n "$environment" --all
                elif [[ $environment ]] && 
                        [[ $package ]] &&
                            [[ $channel ]]
                then
                    conda remove -n "$environment" -c "$channel" "$package"
                fi
             elif [[ $option == "search" ]]
             then
                    read -r -p "please enter the name of the package:" package
                    conda search "$package"
             else printf "%s$tidyclean"
             fi
fi
