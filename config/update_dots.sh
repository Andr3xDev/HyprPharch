#!/bin/bash

#--------------------------------------------------------------------------------------
# Open screen as credits
#--------------------------------------------------------------------------------------

clear
cat <<"EOF"
---------------------------------------------------------------------------------------

  ,------.           ,--.
  |  .-.  \  ,---. ,-'  '-. ,---.
  |  |  \  :| .-. |'-.  .-'(  .-'
  |  '--'  /' '-' '  |  |  .-'  `)
  `-------'  `---'   `--'  `----'
  ,--. ,--.          ,--.          ,--.
  |  | |  | ,---.  ,-|  | ,--,--.,-'  '-. ,---.
  |  | |  || .-. |' .-. |' ,-.  |'-.  .-'| .-. :
  '  '-'  '| '-' '\ `-' |\ '-'  |  |  |  \   --.
   `-----' |  |-'  `---'  `--`--'  `--'   `----'
           `--'


      , _ ,     RESUME:  Terminal CLI to update and control my dotfiles on 
     ( o o )             github.
    /'` ' `'\
    |'''''''|   AUTHOR:  Andr3xDev
    |\\'''//|   URL: https://github.com/Andr3xDev/Mini-projects/tree/main/Dots%20update
       """
---------------------------------------------------------------------------------------
EOF
sleep 2
clear


#--------------------------------------------------------------------------------------
# Main menu
# This function will display the main menu and will call the other functions in loop
#--------------------------------------------------------------------------------------

# Main menu function to call the other functions based on the user choice
function main_menu() {
    while true; do
        print_menu
        case $choice in
        1)
            update_dots
            ;;
        2)
            multiple_updates
            ;;
        3)
            exit_script
            ;;
        *)
            main_menu
            ;;
        esac
    done
}

# Print the main menu options and read the user choice
function print_menu() {
    clear
    echo "-------------------------------------"
    echo "This are the options available:"
    echo ""
    echo "1. Update specific dots"
    echo "2. Update multiple dots"
    echo "3. Exit"
    echo "-------------------------------------"
    read -p "Select an option: " choice
}


#--------------------------------------------------------------------------------------
# Functions to resume the script based on the user choices
#--------------------------------------------------------------------------------------

# Update the dots repo function to update the selected dotfiles directory
function update_dots() {
    validate_git

    # Origin directory
    script_dir=$PWD
    branch=main

    echo $script_dir
    if [[ $? -eq 0 ]]; then
        cd ~/.config/
        echo "Posible folders that are not excluded:"
        echo ""
        ls
        echo ""
        read -p "Select folder you want to update or upload:  " dotfiles_objetive
        read -p "Commit title:  " commit_message

        validate_directory ~/.config/$dotfiles_objetive

        if [[ $? -eq 0 ]]; then
            cp -r ~/.config/$dotfiles_objetive $script_dir
            cd $script_dir
            git checkout $branch
            git pull origin main
            git add $dotfiles_objetive
            git commit -m "$commit_message"
            git push
        else
            echo "Error: solve the posible problems before use the script"
            exit 1
        fi
    else
        echo "Error: can't validate the git credentials or the git connection."
        exit 1
    fi
}

# Update the dots repo function to update the selected dotfiles directory
function update_dir() {
    clear
    read -p "Select directory in .config: " text

    validate_directory ~/.config/$text || return 1
    if [ $? -eq 0 ]; then
        echo "Directory found"
    else
        echo "Error: can't find the directory $text"
    fi
}

# Update multiple dots files at the same time to push them only once
function multiple_updates() {
    validate_git
    script_dir=$PWD
    branch=main

    if [[ $? -eq 0 ]]; then
        directories=""
        ls ~/.config/
        echo "Select target directories, type 'end' to finish"

        while true; do
            printf "> "
            read input
            if [ "$input" = "end" ]; then
                break
            fi
        
            directories="$directories $input"
        done

        read -p "Commit title: " commit_message
        git checkout $branch

        for dotfiles_objective in $directories; do
            cp -r ~/.config/"$dotfiles_objective" "$script_dir"
            cd "$script_dir"
            git pull origin main
            git add "$dotfiles_objective"
        done

        git commit -m "$commit_message"
        git push
    else
        echo "Error: can't validate the git credentials or the git connection."
        exit 1
    fi
}


# Exit the script
function exit_script() {
    printf "\n\nExiting the script...\n"
    echo "thanks for using the script"
    exit 0
}


#--------------------------------------------------------------------------------------
# Validate functions to check the user git credentials and the git connection or directory existence
# If the user doesn't have the credentials or the connection, the script will exit
# Else, the script will continue
#--------------------------------------------------------------------------------------

# Validate git will make sure the user has the git credentials and the git connection
function validate_git() {
    clear
    echo "Validating git credentials and connection..."
    sleep 1
    validate_git_credentials || return 1
    validate_git_connection || return 1
}

# Validate the user git credentials
function validate_git_credentials() {
    if ! git config --global user.name &>/dev/null || ! git config --global user.email &>/dev/null; then
        clear
        echo "Credentials not found"
        echo "Please configure your git credentials or your git settings"
        echo "Try using this to test or configure:"
        echo "  git config --global user.name"
        echo "  git config --global user.email"
        sleep 1
        return 1
    fi
}

# Validate the git connection by SSH
function validate_git_connection() {
    if ssh -T git@github.com &>/dev/null; then
        clear
        echo "Error: can't validate connection to GitHub by SSH."
        echo "Please check your SSH keys and your GitHub account."
        return 1
    fi
}

# Validate the directory existence before update
function validate_directory() {
    if [ ! -d "$1" ]; then
        clear
        echo "Error: can't find the directory $1"
        echo "Please check the directory path and try again."
        return 1
    fi
}


#--------------------------------------------------------------------------------------
# Run the script
#--------------------------------------------------------------------------------------
main_menu
