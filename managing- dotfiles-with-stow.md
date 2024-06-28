# Managing Dotfiles with GNU Stow

GNU Stow is a powerful, lightweight symlink farm manager that can be used to manage your dotfiles. This guide will help you set up and use Stow to organize and maintain your dotfiles efficiently.

## Prerequisites

- GNU Stow installed on your system.

    ```sh
    Copy code
    sudo apt update
    sudo apt install stow
    Stowing Dotfiles
    ```

- A directory named `dotfiles` in your home directory.

## Initial Setup

1. **Create the `dotfiles` Directory**

    Ensure you have a directory called `dotfiles` in your home directory.

    ```sh
    mkdir -p ~/dotfiles
    ```

2. **Organize Your Dotfiles**

    Inside the `dotfiles` directory, create subdirectories for each application or configuration you want to manage. Move the respective dotfiles into these subdirectories. For example:

    ```sh
    mkdir -p ~/dotfiles/pipewire
    mkdir -p ~/dotfiles/wireplumber

    mv ~/.config/pipewire/* ~/dotfiles/pipewire/
    mv ~/.config/wireplumber/* ~/dotfiles/wireplumber/
    ```

## Using Stow

3. **Stow Your Dotfiles**

    Navigate to your `dotfiles` directory and use Stow to create symlinks in your home directory. The `-t` option specifies the target directory.

    ```sh
    cd ~/dotfiles
    stow -t ~ pipewire
    stow -t ~ wireplumber
    ```

4. **Verify the Symlinks**

    Check that the symlinks have been created correctly in your home directory.

    ```sh
    ls -l ~/.config/pipewire
    ls -l ~/.config/wireplumber
    ```

## Adding New Dotfiles

5. **Add New Configurations**

    When you want to add new configurations, create a new subdirectory in your `dotfiles` directory, move the configuration files there, and run `stow` again.

    ```sh
    mkdir -p ~/dotfiles/newapp
    mv ~/.config/newapp/* ~/dotfiles/newapp/
    cd ~/dotfiles
    stow -t ~ newapp
    ```

## Updating Dotfiles

6. **Update and Apply Changes**

    If you update your dotfiles in the `dotfiles` directory, you can simply re-run `stow` to apply the changes.

    ```sh
    cd ~/dotfiles
    stow -t ~ pipewire
    stow -t ~ wireplumber
    ```

## Unstowing Dotfiles

7. **Remove Symlinks**

    If you need to remove the symlinks created by Stow, use the `-D` option.

    ```sh
    cd ~/dotfiles
    stow -D -t ~ pipewire
    stow -D -t ~ wireplumber
    ```

